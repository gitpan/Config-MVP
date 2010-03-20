
use strict;
use warnings;



use ExtUtils::MakeMaker 6.11;



my %WriteMakefileArgs = (
                       'test' => {
                                   'TESTS' => 't/*.t'
                                 },
                       'NAME' => 'Config::MVP',
                       'DISTNAME' => 'Config-MVP',
                       'CONFIGURE_REQUIRES' => {
                                                 'ExtUtils::MakeMaker' => '6.11'
                                               },
                       'AUTHOR' => 'Ricardo Signes <rjbs@cpan.org>',
                       'BUILD_REQUIRES' => {},
                       'ABSTRACT' => 'multivalue-property package-oriented configuration',
                       'EXE_FILES' => [],
                       'VERSION' => '0.100780',
                       'PREREQ_PM' => {
                                        'Test::More' => '0.88',
                                        'Moose::Role' => '0',
                                        'Tie::IxHash' => '0',
                                        'File::Spec' => '0',
                                        'Module::Pluggable::Object' => '0',
                                        'Moose' => '0'
                                      },
                       'LICENSE' => 'perl'
                     );


delete $WriteMakefileArgs{LICENSE}
  unless eval { ExtUtils::MakeMaker->VERSION(6.31) };

WriteMakefile(%WriteMakefileArgs);



