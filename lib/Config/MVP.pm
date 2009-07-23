package Config::MVP;
our $VERSION = '0.092040';

use strict;
use warnings;
# ABSTRACT: multivalue-property configuration


1;

__END__

=pod

=head1 NAME

Config::MVP - multivalue-property configuration

=head1 VERSION

version 0.092040

=head1 DESCRIPTION

MVP is a state machine for loading configuration (or other information) for
libraries.  It expects to generate a list of named sections, each of which
relates to a Perl namespace and contains a set of named parameters.

=head1 AUTHOR

  Ricardo Signes <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2009 by Ricardo Signes.

This is free software; you can redistribute it and/or modify it under
the same terms as perl itself.

=cut 


