package Config::MVP::Reader;
BEGIN {
  $Config::MVP::Reader::VERSION = '0.101410';
}
use Moose::Role;
# ABSTRACT: role to load MVP-style config from a file

use Config::MVP::Assembler;


has assembler => (
  is   => 'ro',
  isa  => 'Config::MVP::Assembler',
  lazy => 1,
  builder => 'build_assembler',
);


sub build_assembler { Config::MVP::Assembler->new; }


requires 'read_config';

no Moose::Role;
1;

__END__
=pod

=head1 NAME

Config::MVP::Reader - role to load MVP-style config from a file

=head1 VERSION

version 0.101410

=head1 DESCRIPTION

The config role provides some helpers for writing a configuration loader using
the L<Config::MVP|Config::MVP> system to load and validate its configuration.
It delegates assembly of the configuration sequence to an Assembler.  The
Reader is responsible for opening, reading, and interpreting a file.

=head1 ATTRIBUTES

=head2 assembler

The L<assembler> attribute must be a Config::MVP::Assembler, has a sensible
default that will handle the standard needs of a config loader.  Namely, it
will be pre-loaded with a starting section for root configuration.  That
starting section will alias C<author> to C<authors> and will set that up as a
multivalue argument.

=head1 METHODS

=head2 build_assembler

This is the builder for the C<assembler> attribute and must return a
Config::MVP::Assembler object.  It's here so subclasses can produce assemblers
of other classes or with pre-loaded sections.

=head2 read_config

  my $sequence = $reader->read_config(\%arg);

This method, B<which must be implemented by classes including this role>, is
passed a hashref of arguments and returns a Config::MVP::Sequence.

Likely arguments include:

  root     - the name of the directory in which to look
  filename - the filename in that directory to read

=head1 AUTHOR

  Ricardo Signes <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Ricardo Signes.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

