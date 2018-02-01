package Mojolicious::Plugin::JSONAPI;

use Mojo::Base 'Mojolicious::Plugin';

# ABSTRACT: Mojolicious Plugin for building JSON API compliant applications.

sub register {
    my ($self, $app, $args) = @_;
}

1;

__END__

=encoding UTF-8

=head1 NAME

Mojolicious::Plugin::JSONAPI - Mojolicious Plugin for building JSON API compliant applications

=head1 VERSION

=head1 SYNOPSIS

=head1 DESCRIPTION

This module intends to supply the user with helper methods that can be used to build JSON API
compliant data structures.

See L<http://jsonapi.org/> for the JSON API specification. At the time of writing, the version was 1.0.

The specification takes backwards compatability pretty seriously, so your app should be able to use this
plugin without much issue.

=head1 METHODS

=cut
