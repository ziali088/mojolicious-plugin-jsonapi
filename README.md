# NAME

Mojolicious::Plugin::JSONAPI - Mojolicious Plugin for building JSON API compliant applications

# VERSION

# SYNOPSIS

# DESCRIPTION

This module intends to supply the user with helper methods that can be used to build JSON API
compliant data structures.

See [http://jsonapi.org/](http://jsonapi.org/) for the JSON API specification. At the time of writing, the version was 1.0.

The specification takes backwards compatability pretty seriously, so your app should be able to use this
plugin without much issue.

# METHODS

## resource\_routes(HashRef $spec)

Creates a set of routes for the given resource. `$spec` is a hash reference of the resources specification
with the following options:

    {
        resource        => 'posts', # name of resource, required
        controller      => 'api-posts', # name of controller, defaults to 'api-' . $spec->{resource}
        relationships   => ['comments'],
    }

Specifying `relationships` will create additional routes that fall under the resource.
