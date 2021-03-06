#############
# $Id: run_lane.pm 14884 2012-01-09 12:26:19Z mg8 $
# Created By: ajb
# Last Maintained By: $Author: mg8 $
# Created On: 2011-01-11
# Last Changed On: $Date: 2012-01-09 12:26:19 +0000 (Mon, 09 Jan 2012) $
# $HeadURL: svn+ssh://svn.internal.sanger.ac.uk/repos/svn/new-pipeline-dev/npg-tracking/trunk/lib/npg/email/event/annotation/run_lane.pm $

package npg::email::event::annotation::run_lane;
use strict;
use warnings;
use Moose;
use Carp;
use English qw{-no_match_vars};
use Readonly; Readonly::Scalar our $VERSION => do { my ($r) = q$LastChangedRevision: 14884 $ =~ /(\d+)/mxs; $r; };

extends qw{npg::email::run};
with qw{npg::email::roles::event_attributes};

Readonly::Scalar my $TEMPLATE => 'run_lane_annotation.tt2';

has q{_entity_check} => ( isa => q{Str}, init_arg => undef, is => q{ro}, default => q{npg_tracking::Schema::Result::RunLaneAnnotation} );

sub _build_template {
  my ($self) = @_;
  return $TEMPLATE;
}

=head1 NAME

npg::email::event::annotation::run_lane

=head1 VERSION

$LastChangedRevision: 14884 $

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 SUBROUTINES/METHODS

=head2 run

  $oNotify->run();

This method notifies the relevant people that this status change on a run has occured and updates
the database to state that it has been done;

=cut

sub run {
  my ($self) = @_;

  $self->compose_email();
  $self->send_email(
    {
      body => $self->next_email(),
      to   => $self->watchers(),
      subject => q{Run Lane } . $self->id_run() . q{_} . $self->lane() . q{ has been annotated by } . $self->user(),
    }
  );

  $self->update_event_as_notified();

  return;
}

=head2 compose_email

Collect the data required for the notification email and process the e-mail
template using it. Create an email object that can be sent from the main 'run'
method.

=cut

sub compose_email {
  my ($self) = @_;

  my $details      = $self->batch_details();
  my $template_obj = $self->email_templates_object();

  $template_obj->process(
    $self->template(),
    {
      run        => $self->id_run(),
      lane       => $self->lane(),
      lanes      => $details->{lanes},
      annotation => $self->event_row->description(),
      dev        => $self->dev(),
    },
  ) or do {
    croak sprintf '%s error: %s', $template_obj->error->type(), $template_obj->error->info();
  };

  return $template_obj;
}

=head2 lane

Returns the lane position number for the lane this annotation is on

=cut

sub lane {
  my ( $self ) = @_;
  return $self->event_row->entity_obj->run_lane->position();
}

=head2 understands

This method is used by the npg::email::event factory to determine if it is the correct one to
return.

=cut

sub understands {
  my ( $class, $data ) = @_;

  if (
      (    $data->{event_row}
        && $data->{event_row}->event_type->description() eq q{annotation}
        && $data->{event_row}->event_type->entity_type->description() eq q{run_lane_annotation} )
         ||
      (    $data->{entity_type} eq q{run_lane_annotation}
        && $data->{event_type}  eq q{annotation} )
     ) {
    return $class->new( $data );
  }

  return;
}


no Moose;
__PACKAGE__->meta->make_immutable;
1;
__END__

=head1 DIAGNOSTICS

=head1 CONFIGURATION AND ENVIRONMENT

=head1 DEPENDENCIES

=over

=item Moose

=item Carp

=item English -no_match_vars

=item Readonly

=back

=head1 INCOMPATIBILITIES

=head1 BUGS AND LIMITATIONS

=head1 AUTHOR

$Author: mg8 $

=head1 LICENSE AND COPYRIGHT

Copyright (C) 2011 GRL, by Andy Brown (ajb@sanger.ac.uk)

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
