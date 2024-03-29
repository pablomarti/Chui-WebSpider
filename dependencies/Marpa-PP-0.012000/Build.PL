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

use 5.010;
use strict;
use warnings;
use Fatal qw(open close mkdir chdir);
use File::Spec 0.82;
use IPC::Cmd;
use File::Path;

use Config;
use Module::Build;

use lib 'config';
use Marpa::PP::Build_Me;
use Marpa::PP::Config;

my %build_requires =
    map { ( $_, $Marpa::PP::VERSION_FOR_CONFIG{$_} ) }
    qw( ExtUtils::CBuilder Test::More );
my %configure_requires =
    map { ( $_, $Marpa::PP::VERSION_FOR_CONFIG{$_} ) } qw( Module::Build );
my %requires =
    map { ( $_, $Marpa::PP::VERSION_FOR_CONFIG{$_} ) }
    qw( Scalar::Util List::Util Task::Weaken Carp Data::Dumper Storable );
my %recommends =
    map { ( $_, $Marpa::PP::VERSION_FOR_CONFIG{$_} ) } qw( PPI Test::Weaken );

my %pod_files = map { ( "pod/$_" => "lib/Marpa/PP/$_" ) } qw(
    Advanced/Bibliography.pod
    Advanced/Models.pod
    Debug.pod
    Grammar.pod
    Recognizer.pod
    Rewrite.pod
    Semantics/Infinite.pod
    Semantics/Null.pod
    Semantics/Order.pod
    Semantics.pod
    Support.pod
    Tracing.pod
    Vocabulary.pod
);
$pod_files{'pod/Marpa_PP.pod'} = 'lib/Marpa/PP.pod';

my @no_index_namespace_inclusive = qw(
    Marpa::PP::Callback
    Marpa::PP::Display
    Marpa::PP::Internal
    Marpa::PP::Offset
    Marpa::PP::Perl
    Marpa::PP::Test
    Marpa::PP::Value
);

my @files_to_cleanup = (
    'lib/Marpa/PP/Version.pm',   'pperl/Marpa/PP/Perl/Version.pm',
    'lib/Marpa/PP/Installed.pm', 'pperl/Marpa/PP/Perl/Installed.pm',
    'libmarpa/main/build',
);

my $build = Marpa::PP::Build_Me->new(
    add_to_cleanup     => \@files_to_cleanup,
    module_name        => 'Marpa::PP',
    dist_author        => 'Jeffrey Kegler',
    dist_abstract      => 'PP Version of Marpa',
    recommends         => \%recommends,
    requires           => \%requires,
    configure_requires => \%configure_requires,
    build_requires     => \%build_requires,
    dynamic_config     => 1,
    PL_files           => {},
    meta_merge         => {
        resources =>
            { repository => 'git://github.com/jeffreykegler/Marpa-PP.git', },
        no_index => {
            directory => [qw( pperl config inc t tool author.t )],
            namespace => [
                'Marpa::PP::Recognizer', 'Marpa::PP::Grammar',
                @no_index_namespace_inclusive
            ],
            package => [@no_index_namespace_inclusive],
        }
    },
    pod_files          => \%pod_files,
    create_readme      => 0,
    create_makefile_pl => 'small',
    test_files         => [ map { glob $_ } qw(t/*.t) ],
);

$build->create_build_script;
