package Config::MVP::Sequence;
our $VERSION = '0.093000';


use Moose;
# ABSTRACT: an ordered set of named configuration sections


use Tie::IxHash;
use Config::MVP::Section;

# This is a private attribute and should not be documented for futzing-with,
# most likely. -- rjbs, 2009-08-09
has sections => (
  isa => 'HashRef[Config::MVP::Section]',
  reader   => '_sections',
  init_arg => undef,
  default  => sub {
    tie my %section, 'Tie::IxHash';
    return \%section;
  },
);


sub add_section {
  my ($self, $section) = @_;

  my $name = $section->name;
  confess "already have a section named $name" if $self->_sections->{ $name };

  $self->_sections->{ $name } = $section;
}


sub delete_section {
  my ($self, $name) = @_;
  my $sections = $self->_sections;

  return unless exists $sections->{ $name };
  return delete $sections->{ $name };
}


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

no Moose;
1;

__END__
=pod

=head1 NAME

Config::MVP::Sequence - an ordered set of named configuration sections

=head1 VERSION

version 0.093000

=head1 DESCRIPTION

A Config::MVP::Sequence is an ordered set of configuration sections, each of
which has a name unique within the sequence.

For the most part, you can just consult L<Config::MVP> to understand what this
class is and how it's used.

=head1 METHODS

=head2 add_section

  $sequence->add_section($section);

This method adds the given section to the end of the sequence.  If the sequence
already contains a section with the same name as the new section, an exception
will be raised.

=head2 delete_section

  my $deleted_section = $sequence->delete_section( $name );

This method removes a section from the sequence and returns the removed
section.  If no section existed, the method returns false.

=head2 section_named

  my $section = $sequence->section_named( $name );

This method returns the section with the given name, if one exists in the
sequence.  If no such section exists, the method returns false.

=head2 section_names

  my @names = $sequence->section_names;

This method returns a list of the names of the sections, in order.

=head2 sections

  my @sections = $sequence->sections;

This method returns the section objects, in order.

=head1 AUTHOR

  Ricardo Signes <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2009 by Ricardo Signes.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

