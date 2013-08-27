
use strict;
use warnings;



use ExtUtils::MakeMaker 6.30;



my %WriteMakefileArgs = (
  "ABSTRACT" => "multivalue-property package-oriented configuration",
  "AUTHOR" => "Ricardo Signes <rjbs\@cpan.org>",
  "BUILD_REQUIRES" => {},
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => "6.30"
  },
  "DISTNAME" => "Config-MVP",
  "EXE_FILES" => [],
  "LICENSE" => "perl",
  "NAME" => "Config::MVP",
  "PREREQ_PM" => {
    "Class::Load" => "0.17",
    "File::Spec" => "0",
    "Module::Pluggable::Object" => "0",
    "Moose" => "0.91",
    "Moose::Role" => "0",
    "Moose::Util::TypeConstraints" => "0",
    "MooseX::OneArgNew" => "0",
    "Params::Util" => "0",
    "Role::HasMessage" => "0",
    "Role::Identifiable::HasIdent" => "0",
    "StackTrace::Auto" => "0",
    "Test::More" => "0.88",
    "Throwable" => "0",
    "Tie::IxHash" => "0",
    "Try::Tiny" => "0",
    "overload" => "0",
    "strict" => "0",
    "warnings" => "0"
  },
  "TEST_REQUIRES" => {
    "File::Spec" => "0",
    "IO::Handle" => "0",
    "IPC::Open3" => "0",
    "Test::Fatal" => "0",
    "Test::More" => "0.96",
    "lib" => "0"
  },
  "VERSION" => "2.200004",
  "test" => {
    "TESTS" => "t/*.t"
  }
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.63_03) } ) {
  my $tr = delete $WriteMakefileArgs{TEST_REQUIRES};
  my $br = $WriteMakefileArgs{BUILD_REQUIRES};
  for my $mod ( keys %$tr ) {
    if ( exists $br->{$mod} ) {
      $br->{$mod} = $tr->{$mod} if $tr->{$mod} > $br->{$mod};
    }
    else {
      $br->{$mod} = $tr->{$mod};
    }
  }
}

unless ( eval { ExtUtils::MakeMaker->VERSION(6.56) } ) {
  my $br = delete $WriteMakefileArgs{BUILD_REQUIRES};
  my $pp = $WriteMakefileArgs{PREREQ_PM};
  for my $mod ( keys %$br ) {
    if ( exists $pp->{$mod} ) {
      $pp->{$mod} = $br->{$mod} if $br->{$mod} > $pp->{$mod};
    }
    else {
      $pp->{$mod} = $br->{$mod};
    }
  }
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);



