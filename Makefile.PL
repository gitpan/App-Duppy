
use strict;
use warnings;



use ExtUtils::MakeMaker 6.30;



my %WriteMakefileArgs = (
  "ABSTRACT" => "a wrapper around casperjs to pass test configurations as json files",
  "AUTHOR" => "Emmanuel \"BHS_error\" Peroumalnaik, Fabrice \"pokki\" Gabolde",
  "BUILD_REQUIRES" => {},
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => "6.30"
  },
  "DISTNAME" => "App-Duppy",
  "EXE_FILES" => [
    "bin/duppy"
  ],
  "LICENSE" => "perl",
  "NAME" => "App::Duppy",
  "PREREQ_PM" => {
    "Carp" => 0,
    "DDP" => 0,
    "FindBin" => 0,
    "IO::All" => 0,
    "IPC::Cmd" => 0,
    "JSON" => 0,
    "Moo" => 0,
    "MooX::Options" => 0,
    "Try::Tiny" => 0,
    "lib" => 0,
    "strict" => 0,
    "warnings" => 0
  },
  "TEST_REQUIRES" => {
    "Test::More" => 0
  },
  "VERSION" => "0.02",
  "test" => {
    "TESTS" => "t/*.t"
  }
);


my %FallbackPrereqs = (
  "Carp" => 0,
  "DDP" => 0,
  "FindBin" => 0,
  "IO::All" => 0,
  "IPC::Cmd" => 0,
  "JSON" => 0,
  "Moo" => 0,
  "MooX::Options" => 0,
  "Test::More" => 0,
  "Try::Tiny" => 0,
  "lib" => 0,
  "strict" => 0,
  "warnings" => 0
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.63_03) } ) {
  delete $WriteMakefileArgs{TEST_REQUIRES};
  delete $WriteMakefileArgs{BUILD_REQUIRES};
  $WriteMakefileArgs{PREREQ_PM} = \%FallbackPrereqs;
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);



