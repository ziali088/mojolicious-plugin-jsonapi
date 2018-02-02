package Mojolicious::Plugin::JSONAPI;

use Mojo::Base 'Mojolicious::Plugin';

use Carp ();

# ABSTRACT: Mojolicious Plugin for building JSON API compliant applications.

sub register {
    my ($self, $app, $args) = @_;

    # Add detection for application/vnd.api+json content type, fallback to application/json
    $app->types->type(json => [ 'application/vnd.api+json', 'application/json' ]);

    $self->create_route_helpers($app);
}

sub create_route_helpers {
    my ($self, $app) = @_;

    $app->helper(resource_routes => sub {
        my ($self, $spec) = @_;
        $spec->{resource} || Carp::confess('resource is a required param');
        $spec->{controller} ||= 'api-' . $spec->{resource};
        $spec->{relationships} ||= [];
    });
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

=head2 resource_routes(HashRef $spec)

Creates a set of routes for the given resource. C<$spec> is a hash reference of the resources specification
with the following options:

    {
        resource        => 'posts', # name of resource, required
        controller      => 'api-posts', # name of controller, defaults to 'api-' . $spec->{resource}
        relationships   => ['comments'],
    }

Specifying C<relationships> will create additional routes that fall under the resource.

=cut
