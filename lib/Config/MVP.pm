package Config::MVP;
our $VERSION = '0.092080';

use strict;
use warnings;
# ABSTRACT: multivalue-property package-oriented configuration


1;

__END__

=pod

=head1 NAME

Config::MVP - multivalue-property package-oriented configuration

=head1 VERSION

version 0.092080

=head1 DESCRIPTION

MVP is a mechanism for loading configuration (or other information) for
libraries.

It is meant to build up a L<Config::MVP::Sequence|Config::MVP::Sequence>
object, which is an ordered collection of sections.  Sections are
L<Config::MVP::Section|Config::MVP::Section> objects.

Each section has a name and a payload (a hashref) and may be associated with a
package.  No two sections in a sequence may have the same name.

You may construct a sequence by hand, but it may be easier to use the
sequence-generating helper, L<Config::MVP::Assembler>.

Config::MVP was designed for systems that will load plugins, possibly each
plugin multiply, each with its own configuration.  For examples of Config::MVP
in use, you can look at L<Dist::Zilla|Dist::Zilla> or L<App::Addex|App::Addex>.

=head1 AUTHOR

  Ricardo Signes <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2009 by Ricardo Signes.

This is free software; you can redistribute it and/or modify it under
the same terms as perl itself.

=cut 


