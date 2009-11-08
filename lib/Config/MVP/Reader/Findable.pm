package Config::MVP::Reader::Findable;
our $VERSION = '0.093120';


use Moose::Role;
# ABSTRACT: a config class that Config::MVP::Reader::Finder can find


use File::Spec;


requires 'default_extension';


sub can_be_found {
  my ($self, $arg) = @_;

  my $config_file = $self->filename_from_args($arg);
  return -r "$config_file" and -f _;
}


sub filename_from_args {
  my ($self, $arg) = @_;

  # XXX: maybe we should detect conflicting cases -- rjbs, 2009-08-18
  my $filename;
  if ($arg->{filename}) {
    $filename = $arg->{filename}
  } else {
    my $basename = $arg->{basename};
    confess "no filename or basename supplied"
      unless defined $arg->{basename} and length $arg->{basename};

    my $extension = $self->default_extension;
    $filename = $basename;
    $filename .= ".$extension" if defined $extension;
  }

  return File::Spec->catfile("$arg->{root}", $filename);
}

no Moose::Role;
1;


__END__
=pod

=head1 NAME

Config::MVP::Reader::Findable - a config class that Config::MVP::Reader::Finder can find

=head1 VERSION

version 0.093120

=head1 DESCRIPTION

Config::MVP::Reader::Findable is a role meant to be composed alongside
Config::MVP::Reader.  It indicates to L<Config::MVP::Reader::Finder> that the
composing config reader can look in a directory and decide whether there's a
relevant file in the configuration root.

=head1 METHODS

=head2 default_extension

This method, B<which must be composed by classes including this role>, returns
the default extension used by files in the format this reader can read.

When the Finder tries to find configuration, it have a directory root and a
basename.  Each (Findable) reader that it tries in turn will look for a file
F<basename.extension> in the root directory.  If exactly one file is found,
that file is read.

=head2 can_be_found

This method gets the same arguments as C<read_config> and returns true if this
config reader will be able to handle the request.

=head2 filename_from_args

This method gets the same arguments as C<read_config> and will return the fully
qualified filename of the file it would want to read for configuration.  This
file is not guaranteed to exist or be readable.

=head1 AUTHOR

  Ricardo Signes <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2009 by Ricardo Signes.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

