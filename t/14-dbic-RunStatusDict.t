#########
# Author:        jo3
# Maintainer:    $Author: dj3 $
# Created:       2010_05_26
# Last Modified: $Date: 2010-10-07 13:00:50 +0100 (Thu, 07 Oct 2010) $
# Id:            $Id: 14-dbic-RunStatusDict.t 11232 2010-10-07 12:00:50Z dj3 $
# $HeadURL: svn+ssh://svn.internal.sanger.ac.uk/repos/svn/new-pipeline-dev/npg-tracking/trunk/t/14-dbic-RunStatusDict.t $

use strict;
use warnings;

use English qw(-no_match_vars);

use Test::More tests => 13;
use Test::Deep;
use Test::Exception::LessClever;
use Test::MockModule;

use lib q{t};
use t::dbic_util;

use Readonly; Readonly::Scalar our $VERSION => do { my ($r) = q$Revision: 11232 $ =~ /(\d+)/msx; $r; };

Readonly::Scalar my $ABSURD_ID => 100_000_000;


use_ok('npg_tracking::Schema::Result::RunStatusDict');


my $schema = t::dbic_util->new->test_schema();
my $test;

lives_ok { $test = $schema->resultset('RunStatusDict')->new( {} ) }
         'Create test object';


throws_ok { $test->check_row_validity() }
          qr/Argument required/ms,
          'Exception thrown for no argument supplied';


is( $test->check_row_validity('run exploded'), undef, 'Invalid description' );
is( $test->check_row_validity($ABSURD_ID),     undef, 'Invalid id' );

my $row = $test->check_row_validity('run complete');

is(
    ( ref $row ),
    'npg_tracking::Schema::Result::RunStatusDict',
    'Valid description...'
);
is( $row->id_run_status_dict(), 4, '...and the correct row' );



$row = $test->check_row_validity(1);

is(
    ( ref $row ),
    'npg_tracking::Schema::Result::RunStatusDict',
    'Valid id...'
);
is( $row->description(), 'run pending', '...and the correct row' );

my $row2 = $test->_insist_on_valid_row(1);

cmp_deeply( $row, $row2, 'Internal method returns same row' );


{
    my $broken_db_test =
        Test::MockModule->new('DBIx::Class::ResultSet');

    $broken_db_test->mock( count => sub { return 2; } );

    $test = $schema->resultset('RunStatusDict')->new( {} );

    throws_ok { $test->check_row_validity(1) }
              qr/Panic![ ]Multiple[ ]run_status_dict[ ]rows[ ]found/msx,
              'Exception thrown for multiple db matches';

    $broken_db_test->mock( count => sub { return 0; } );
    is( $test->check_row_validity(1), undef, 'Return undef for no matches' );

    throws_ok { $test->_insist_on_valid_row(1) }
              qr/Invalid[ ]identifier:[ ]1/msx,
              'Internal validator croaks as it\'s supposed to';
}


1;
