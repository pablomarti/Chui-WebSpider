#!/usr/bin/perl
# Copyright 2011 Jeffrey Kegler
# This file is part of Marpa::PP.  Marpa::PP is free software: you can
# redistribute it and/or modify it under the terms of the GNU Lesser
# General Public License as published by the Free Software Foundation,
# either version 3 of the License, or (at your option) any later version.
#
# Marpa::PP is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser
# General Public License along with Marpa::PP.  If not, see
# http://www.gnu.org/licenses/.

# Tests of the sequence in the Marpa::PP::Grammar doc

use 5.010;
use strict;
use warnings;

use Fatal qw(open close);
use Test::More tests => 4;

use lib 'tool/lib';
use Marpa::PP::Test;

BEGIN {
    Test::More::use_ok('Marpa::PP');
}

## no critic (Subroutines::RequireArgUnpacking)
sub sequence { shift; return 'seq(' .  ( join q{;}, @_ ) . ')' }
sub item     { shift; return 'item(' . ( join q{;}, @_ ) . ')' }
## use critic

my $grammar;
my $recce;
my $value_ref;
my $value;

my $min0 =
#<<< no perltidy
# Marpa::PP::Display
# name: Marpa::PP::Grammar min 0 sequence example

    { lhs => 'sequence', rhs => ['item'], min => 0 }

# Marpa::PP::Display::End
; # semicolon to terminate rule

$grammar = Marpa::PP::Grammar->new(
    {   start     => 'sequence',
        terminals => [qw(item)],
        rules     => [$min0],
        actions => 'main'
    }
);

$grammar->precompute();

$recce = Marpa::PP::Recognizer->new( { grammar => $grammar } );

$recce->read( 'item', '0' );
$recce->read( 'item', '1');

$value_ref = $recce->value();
$value = $value_ref ? ${$value_ref} : 'No Parse';
$value //= 'undef returned';

Marpa::PP::Test::is( $value, 'seq(0;1)', 'min 0 value' );

my $min1 =
#<<< no perltidy
# Marpa::PP::Display
# name: Marpa::PP::Grammar min 1 sequence example

    { lhs => 'sequence', rhs => ['item'], min => 1 }

# Marpa::PP::Display::End
; # semicolon to terminate rule

$grammar = Marpa::PP::Grammar->new({
     start => 'sequence',
     rules => [ $min1 ],
        actions => 'main'
});

$grammar->precompute();

$recce = Marpa::PP::Recognizer->new( { grammar => $grammar } );

$recce->read( 'item', '0' );
$recce->read( 'item', '1');

$value_ref = $recce->value();
$value = $value_ref ? ${$value_ref} : 'No Parse';
$value //= 'undef returned';

Marpa::PP::Test::is( $value, 'seq(0;1)', 'min 1 value' );

my $multipart = [
#<<< no perltidy
# Marpa::PP::Display
# name: Marpa::PP::Grammar multipart rhs sequence example

    { lhs => 'sequence', rhs => [qw(item)], min => 0 },
    { lhs => 'item', rhs => [qw(part1 part2)], },

# Marpa::PP::Display::End
]; # semicolon to terminate rule

$grammar = Marpa::PP::Grammar->new(
    {   start => 'sequence',
        terminals => [qw(part1 part2)],
        rules => $multipart,
        actions => 'main'
    }
);


$grammar->precompute();

$recce = Marpa::PP::Recognizer->new( { grammar => $grammar } );

$recce->read( 'part1', '0' );
$recce->read( 'part2', '1');

$value_ref = $recce->value();
$value = $value_ref ? ${$value_ref} : 'No Parse';
$value //= 'undef returned';

Marpa::PP::Test::is( $value, 'seq(item(0;1))', 'multipart rhs value' );

1; # In case used as "do" file

# Local Variables:
#   mode: cperl
#   cperl-indent-level: 4
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4:
