package Foo::Metaboondle;
our $VERSION = '0.093000';



sub mvp_bundle_config {
  return (
    [ 'boondle_X', 'Foo::Boondle', { } ],
    [ 'boondle_3', 'Foo::Boo2',    { xyzzy => 'plugh' } ],
  );
}

1;
