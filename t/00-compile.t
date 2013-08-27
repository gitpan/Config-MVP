use strict;
use warnings;

# this test was generated with Dist::Zilla::Plugin::Test::Compile 2.019

use Test::More 0.88;



my @module_files = (
    'Config/MVP.pm',
    'Config/MVP/Assembler.pm',
    'Config/MVP/Assembler/WithBundles.pm',
    'Config/MVP/Error.pm',
    'Config/MVP/Reader.pm',
    'Config/MVP/Reader/Findable.pm',
    'Config/MVP/Reader/Findable/ByExtension.pm',
    'Config/MVP/Reader/Finder.pm',
    'Config/MVP/Reader/Hash.pm',
    'Config/MVP/Section.pm',
    'Config/MVP/Sequence.pm'
);

my @scripts = (

);

# no fake home requested

use IPC::Open3;
use IO::Handle;
use File::Spec;

my @warnings;
for my $lib (@module_files)
{
    open my $stdout, '>', File::Spec->devnull or die $!;
    open my $stdin, '<', File::Spec->devnull or die $!;
    my $stderr = IO::Handle->new;

    my $pid = open3($stdin, $stdout, $stderr, qq{$^X -Mblib -e"require q[$lib]"});
    waitpid($pid, 0);
    is($? >> 8, 0, "$lib loaded ok");

    if (my @_warnings = <$stderr>)
    {
        warn @_warnings;
        push @warnings, @_warnings;
    }
}



is(scalar(@warnings), 0, 'no warnings found') if $ENV{AUTHOR_TESTING};



done_testing;
