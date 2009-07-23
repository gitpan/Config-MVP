package Config::MVP::Section;
our $VERSION = '0.092040';

use Moose;
# ABSTRACT: one section of an MVP configuration sequence

has name    => (is => 'ro', isa => 'Str',       required => 1);
has package => (is => 'ro', isa => 'ClassName', required => 0);

has multivalue_args => (
  is  => 'ro',
  isa => 'ArrayRef',
  default => sub { [] },
);

has payload => (
  is  => 'ro',
  isa => 'HashRef',
  init_arg => undef,
  default  => sub { {} },
);

sub add_setting {
  my ($self, $name, $value) = @_;

  my $mva = $self->multivalue_args;

  if (grep { $_ eq $name } @$mva) {
    my $array = $self->payload->{$name} ||= [];
    push @$array, $value;
    return;
  }

  if (exists $self->payload->{$name}) {
    Carp::croak "multiple values given for property $name in section "
              . $self->name;
  }

  $self->payload->{$name} = $value;
}

no Moose;
1;

__END__

=pod

=head1 NAME

Config::MVP::Section - one section of an MVP configuration sequence

=head1 VERSION

version 0.092040

=head1 AUTHOR

  Ricardo Signes <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2009 by Ricardo Signes.

This is free software; you can redistribute it and/or modify it under
the same terms as perl itself.

=cut 


