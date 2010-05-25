package Config::MVP::Reader;
BEGIN {
  $Config::MVP::Reader::VERSION = '1.101450';
}
use Moose::Role;
# ABSTRACT: role to load MVP-style config from a file

use Config::MVP::Assembler;


sub build_assembler { Config::MVP::Assembler->new; }


sub read_config {
  my ($self, $location, $arg) = @_;
  $arg ||= {};

  my $assembler = $arg->{assembler} || $self->build_assembler;

  $self->read_into_assembler($location, $assembler);
}

requires 'read_into_assembler';

no Moose::Role;
1;

__END__
=pod

=head1 NAME

Config::MVP::Reader - role to load MVP-style config from a file

=head1 VERSION

version 1.101450

=head1 DESCRIPTION

The config role provides some helpers for writing a configuration loader using
the L<Config::MVP|Config::MVP> system to load and validate its configuration.
It delegates assembly of the configuration sequence to an Assembler.  The
Reader is responsible for opening, reading, and interpreting a file.

=head1 METHODS

=head2 build_assembler

If no Assembler is provided to C<read_config>'s C<assembler> parameter, this
method will be called on the Reader to construct one.

It must return a Config::MVP::Assembler object, and by default will return an
entirely generic one.

=head2 read_config

  my $sequence = $reader->read_config($location, \%arg);

=head1 AUTHOR

  Ricardo Signes <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Ricardo Signes.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

