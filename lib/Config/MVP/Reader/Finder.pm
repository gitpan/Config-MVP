package Config::MVP::Reader::Finder;
BEGIN {
  $Config::MVP::Reader::Finder::VERSION = '1.101450';
}
use Moose;
with qw(Config::MVP::Reader);
# ABSTRACT: a reader that finds an appropriate file


use Module::Pluggable::Object;


sub default_search_path {
  return qw(Config::MVP::Reader)
}

has _module_pluggable_object => (
  is => 'ro',
  init_arg => undef,
  default  => sub {
    my ($self) = @_;
    Module::Pluggable::Object->new(
      search_path => [ $self->default_search_path ],
      inner       => 0,
      require     => 1,
    );
  },
);

sub _which_reader {
  my ($self, $location) = @_;

  my @options;

  for my $pkg ($self->_module_pluggable_object->plugins) {
    next unless $pkg->isa('Moose::Object');
    next unless $pkg->does('Config::MVP::Reader::Findable');

    my $location = $pkg->refined_location($location);

    next unless defined $location;

    push @options, [ $pkg, $location ];
  }

  confess "no viable configuration could be found" unless @options;

  # XXX: Improve this error message -- rjbs, 2010-05-24
  confess "multiple possible config plugins found" if @options > 1;

  return {
    'package'  => $options[0][0],
    'location' => $options[0][1],
  };
}

sub read_config {
  my ($self, $location, $arg) = @_;
  $self = $self->new unless blessed($self);
  $arg ||= {};

  local $arg->{assembler} = $arg->{assembler} || $self->build_assembler;

  my $which  = $self->_which_reader($location);
  my $reader = $which->{package}->new;

  return $reader->read_config( $which->{location}, $arg );
}

sub build_assembler { }

sub read_into_assembler {
  die "This method should never be called or reachable";
}

no Moose;
__PACKAGE__->meta->make_immutable;
1;

__END__
=pod

=head1 NAME

Config::MVP::Reader::Finder - a reader that finds an appropriate file

=head1 VERSION

version 1.101450

=head1 DESCRIPTION

The Finder reader multiplexes many other readers that implement the
L<Config::MVP::Reader::Findable> role.  It uses L<Module::Pluggable> to search
for modules, limits them to objects implementing the Findable role, and then
selects the those which report that they are able to read a configuration file
found in the config root directory.  If exactly one findable configuration
reader finds a file, it is used to read the file and the configuration sequence
is returned.  Otherwise, an exception is raised.

The Finder's assembler is passed to the Findable reader when it's instantiated.
That means that a single subclass of Finder with its own assembler can use
generic configuration readers to avoid needless, tiny subclasses.

=head1 METHODS

=head2 default_search_path

This is the default search path used to find configuration readers.  This
method should return a list, and by default returns:

  qw(Config::MVP::Reader)

=head1 AUTHOR

  Ricardo Signes <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Ricardo Signes.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

