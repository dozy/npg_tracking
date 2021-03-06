# Author:        Marina Gourtovaia
# Maintainer:    $Author: mg8 $
# Created:       14 April 2009
# Last Modified: $Date: 2013-01-23 16:49:39 +0000 (Wed, 23 Jan 2013) $
# Id:            $Id: bait.pm 16549 2013-01-23 16:49:39Z mg8 $
# $HeadURL: svn+ssh://svn.internal.sanger.ac.uk/repos/svn/new-pipeline-dev/npg-tracking/trunk/lib/npg_tracking/data/bait.pm $
#
package npg_tracking::data::bait;

use strict;
use warnings;
use Moose;

our $VERSION = do { my ($r) = q$Revision: 16549 $ =~ /(\d+)/smx; $r; };

with qw/
          npg_tracking::glossary::run
          npg_tracking::glossary::lane
          npg_tracking::glossary::tag
          npg_tracking::data::bait::find
       /;

__PACKAGE__->meta->make_immutable;
no Moose;

1;
__END__

=head1 NAME

npg_tracking::data::bait

=head1 VERSION

$Revision: 16549 $

=head1 SYNOPSIS

=head1 DESCRIPTION

A wrapper class for finding the location of bait and target intervals files.

=head1 SUBROUTINES/METHODS

=head1 DIAGNOSTICS

=head1 CONFIGURATION AND ENVIRONMENT

=head1 DEPENDENCIES

=over

=item warnings

=item strict

=item Moose

=item npg_tracking::glossary::run

=item npg_tracking::glossary::lane

=item npg_tracking::glossary::tag

=item npg_tracking::data::bait::find

=back

=head1 INCOMPATIBILITIES

=head1 BUGS AND LIMITATIONS

=head1 AUTHOR

Author: Marina Gourtovaia E<lt>mg8@sanger.ac.ukE<gt>

=head1 LICENSE AND COPYRIGHT

Copyright (C) 2010 GRL, by Marina Gourtovaia

This file is part of NPG.

NPG is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

=cut
