package Config::MVP::Assembler;
our $VERSION = '0.092100';

use Moose;
# ABSTRACT: multivalue-property config-loading state machine

use Config::MVP::Sequence;
use Config::MVP::Section;


has sequence_class => (
  is   => 'ro',
  isa  => 'ClassName',
  lazy => 1,
  default => 'Config::MVP::Sequence',
);

has section_class => (
  is   => 'ro',
  isa  => 'ClassName',
  lazy => 1,
  default => 'Config::MVP::Section',
);

has sequence => (
  is  => 'ro',
  isa => 'Config::MVP::Sequence',
  default  => sub { $_[0]->sequence_class->new },
  init_arg => undef,
);

sub current_section {
  my ($self) = @_;

  my (@sections) = $self->sequence->sections;
  return $sections[ -1 ] if @sections;

  return;
}

sub expand_package { $_[1] }

sub change_section {
  my ($self, $package_moniker, $name) = @_;

  $name = $package_moniker unless defined $name and length $name;

  my $package = $self->expand_package($package_moniker);

  # We already inspected this plugin.
  my $pkg_data = do {
    confess "illegal package name $package"
      unless Params::Util::_CLASS($package);

    eval "require $package; 1"
      or confess "couldn't load plugin $name given in config: $@";

    {
      alias =>   eval { $package->mvp_aliases         } || {},
      multi => [ eval { $package->mvp_multivalue_args } ],
    };
  };

  my $section = $self->section_class->new({
    name    => $name,
    package => $package,
    aliases => $pkg_data->{alias},
    multivalue_args => $pkg_data->{multi},
  });

  $self->sequence->add_section($section);
}

sub add_value {
  my ($self, $name, $value) = @_;

  confess "can't set value without a section to work in"
    unless my $section = $self->current_section;

  $section->add_value($name => $value);
}

no Moose;
1;

__END__

=pod

=head1 NAME

Config::MVP::Assembler - multivalue-property config-loading state machine

=head1 VERSION

version 0.092100

=head1 DESCRIPTION

Config::MVP::Assembler is a helper for constructing a Config::MVP::Sequence
object.

=head1 TYPICAL USE

  my $assembler = Config::MVP::Assembler->new;

  # Maybe you want a starting section:
  my $section = $assembler->section_class->new({ name => '_' });
  $assembler->sequence->add_section($section);

  # We'll add some values, which will go to the starting section:
  $assembler->add_value(x => 10);
  $assembler->add_value(y => 20);

  # Change to a new section...
  $assembler->change_section($moniker);

  # ...and add values to that section.
  $assembler->add_value(x => 100);
  $assembler->add_value(y => 200);

The code above creates an assembler and populates it step by step.  In the end,
to get values, you could do something like this:

  my @output;

  for my $section ($assembler->sequence->sections) {
    push @output, [ $section->name, $section->package, $section->payload ];
  }

When changing sections, the given section "moniker" is used for the new section
name.  The result of passing that moniker to the assembler's
C<L</expand_package>> method is used as the section's package name.  (By
default, this method does nothing.)  The new section's C<multivalue_args> and
C<aliases> are determined by calling the C<mvp_multivalue_args> and
C<mvp_aliases> methods on the package.

=head1 AUTHOR

  Ricardo Signes <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2009 by Ricardo Signes.

This is free software; you can redistribute it and/or modify it under
the same terms as perl itself.

=cut 


