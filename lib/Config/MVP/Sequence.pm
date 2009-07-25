package Config::MVP::Sequence;
our $VERSION = '0.092060';

use Moose;
# ABSTRACT: an ordered set of named configuration sections


use Tie::IxHash;
use Config::MVP::Section;

has sections => (
  isa => 'HashRef[Config::MVP::Section]',
  reader   => '_sections',
  init_arg => undef,
  default  => sub {
    tie my %section, 'Tie::IxHash';
    return \%section;
  },
);

sub section_named {
  my ($self, $name) = @_;
  my $sections = $self->_sections;

  return unless exists $sections->{ $name };
  return $sections->{ $name };
}

sub section_names {
  my ($self) = @_;
  return keys %{ $self->_sections };
}

sub sections {
  my ($self) = @_;
  return values %{ $self->_sections };
}

sub add_section {
  my ($self, $section) = @_;

  my $name = $section->name;
  confess "already have a section named $name" if $self->_sections->{ $name };

  $self->_sections->{ $name } = $section;
}

no Moose;
1;

__END__

=pod

=head1 NAME

Config::MVP::Sequence - an ordered set of named configuration sections

=head1 VERSION

version 0.092060

=head1 DESCRIPTION

For the most part, you can just consult L<Config::MVP> or
L<Config::MVP::Assembler>.

=head1 AUTHOR

  Ricardo Signes <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2009 by Ricardo Signes.

This is free software; you can redistribute it and/or modify it under
the same terms as perl itself.

=cut 


