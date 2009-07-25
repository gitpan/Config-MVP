
use strict;
use warnings;

use ExtUtils::MakeMaker;

WriteMakefile(
  DISTNAME  => 'Config-MVP',
  NAME      => 'Config::MVP',
  AUTHOR    => 'Ricardo\ Signes\ \<rjbs\@cpan\.org\>',
  ABSTRACT  => 'multivalue\-property\ package\-oriented\ configuration',
  VERSION   => '0.092060',
  EXE_FILES => [ qw() ],
  (eval { ExtUtils::MakeMaker->VERSION(6.31) } ? (LICENSE => 'perl') : ()),
  PREREQ_PM    => {
    "Tie::IxHash" => '0',
    "Moose" => '0',
  },
);
