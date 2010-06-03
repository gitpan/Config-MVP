package Config::MVP::Sequence;
BEGIN {
  $Config::MVP::Sequence::VERSION = '2.101540';
}
use Moose;
# ABSTRACT: an ordered set of named configuration sections


use Tie::IxHash;
use Config::MVP::Section;
use Moose::Util::TypeConstraints ();

# This is a private attribute and should not be documented for futzing-with,
# most likely. -- rjbs, 2009-08-09
has sections => (
  isa      => 'HashRef[Config::MVP::Section]',
  reader   => '_sections',
  init_arg => undef,
  default  => sub {
    tie my %section, 'Tie::IxHash';
    return \%section;
  },
);

has assembler => (
  is   => 'ro',
  isa  => Moose::Util::TypeConstraints::class_type('Config::MVP::Assembler'),
  weak_ref => 1,
  predicate => '_assembler_has_been_set',
  reader    => '_assembler',
  writer    => '__set_assembler',
);

sub _set_assembler {
  my ($self, $assembler) = @_;
  confess "can't change Config::MVP::Sequence's assembler after it's set"
    if $self->assembler;
  $self->__set_assembler($assembler);
}

sub assembler {
  my ($self) = @_;
  return undef unless $self->_assembler_has_been_set;
  my $assembler = $self->_assembler;

  unless (defined $assembler) {
    confess "tried to access assembler for a Config::MVP::Sequence, "
          . "but it has been destroyed"
  }

  return $assembler;
}


has is_finalized => (
  is  => 'ro',
  isa => 'Bool',
  traits   => [ 'Bool' ],
  init_arg => undef,
  default  => 0,
  handles  => { finalize => 'set' },
);


sub add_section {
  my ($self, $section) = @_;

  confess "can't add sections to finalized sequence" if $self->is_finalized;

  my $name = $section->name;
  confess "already have a section named $name" if $self->_sections->{ $name };

  $section->_set_sequence($self);

  if (my @names = $self->section_names) {
    my $last_section = $self->section_named( $names[-1] );
    $last_section->finalize unless $last_section->is_finalized;
  }

  $self->_sections->{ $name } = $section;
}


sub delete_section {
  my ($self, $name) = @_;

  confess "can't delete sections from finalized sequence"
    if $self->is_finalized;

  my $sections = $self->_sections;

  return unless exists $sections->{ $name };

  $sections->{ $name }->_clear_sequence;

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

version 2.101540

=head1 DESCRIPTION

A Config::MVP::Sequence is an ordered set of configuration sections, each of
which has a name unique within the sequence.

For the most part, you can just consult L<Config::MVP> to understand what this
class is and how it's used.

=head1 ATTRIBUTES

=head2 is_finalized

This attribute is true if the sequence has been marked finalized, which will
prevent any changes (via methods like C<add_section> or C<delete_section>).  It
can be set with the C<finalize> method.

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

This software is copyright (c) 2010 by Ricardo Signes.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

