# NAME

Mojolicious::Plugin::JSONAPI - Mojolicious Plugin for building JSON API compliant applications

# VERSION

version 0.1

# SYNOPSIS

    # Mojolicious

    # Using route helpers

    sub startup {
        my ($self) = @_;

        $self->plugin('JSONAPI', { namespace => 'api' });

        $self->resource_routes({
            resource => 'post',
            relationships => ['author', 'comments'],
        });

        # Now the following routes are available:

        # GET '/api/posts'
        # POST '/api/posts'
        # PATCH '/api/posts/:post_id
        # DELETE '/api/posts/:post_id

        # GET '/api/posts/:post_id/relationships/author'
        # POST '/api/posts/:post_id/relationships/author'
        # PATCH '/api/posts/:post_id/relationships/author'
        # DELETE '/api/posts/:post_id/relationships/author'

        # GET '/api/posts/:post_id/relationships/comments'
        # POST '/api/posts/:post_id/relationships/comments'
        # PATCH '/api/posts/:post_id/relationships/comments'
        # DELETE '/api/posts/:post_id/relationships/comments'

        # You can use the following helpers too:

        $self->resource_document($dbic_row, $options);

        $self->compound_resource_document($dbic_row, $options);

        $self->resource_documents($dbic_resultset, $options);
    }

# DESCRIPTION

This module intends to supply the user with helper methods that can be used to build JSON API
compliant data structures.

See [http://jsonapi.org/](http://jsonapi.org/) for the JSON API specification. At the time of writing, the version was 1.0.

The specification takes backwards compatability pretty seriously, so your app should be able to use this
plugin without much issue.

`Mojolicious::Lite` is not supported yet as I personally felt that if you're dealing with database schemas
and converting them into strict JSON structures, that's enough for you to think about migrating to `Mojolicious`.

# OPTIONS

- `namespace`

    The prefix that's added to all routes, defaults to 'api'. You can also provided an empty string as the namespace,
    meaing no prefix will be added.

# HELPERS

## resource\_routes(_HashRef_ $spec)

Creates a set of routes for the given resource. `$spec` is a hash reference that can consist of the following:

    {
        resource        => 'post', # name of resource, required
        controller      => 'api-posts', # name of controller, defaults to "api-{resource_plural}"
        relationships   => ['author', 'comments'], # default is []
    }

`resource` should be a singular noun, which will be turned into it's pluralised version (e.g. "post" -> "posts").

Specifying `relationships` will create additional routes that fall under the resource.

**NOTE**: Your relationships should be in the correct form (singular/plural) based on the relationship in your
schema management system. For example, if you have a resource called 'post' and it has many comments, make
sure comments is passed in as a plural noun.

## render\_error(_Str_ $status, _ArrayRef_ $errors, _HashRef_ $data. _HashRef_ $meta)

Renders a JSON response under the required top-level `errors` key. `errors` is an array reference of error objects
as described in the specification. See [Error Objects](http://jsonapi.org/format/#error-objects).

Can optionally provide a reference to the primary data for the route as well as meta information, which will be added
to the response as-is. Use `data_for_type` to generate the right structure for this argument.

## resource\_document

Available in controllers:

    $c->resource_document($dbix_row, $options);

See [resource\_document](https://metacpan.org/pod/JSONAPI::Document#resource_document\(DBIx::Class::Row-$row,-HashRef-$options\)) for usage.

## compound\_resource\_document

Available in controllers:

    $c->compound_resource_document($dbix_row, $options);

See [compound\_resource\_document](https://metacpan.org/pod/JSONAPI::Document#compound_resource_document\(DBIx::Class::Row-$row,-HashRef-$options\)) for usage.

## resource\_documents

Available in controllers:

    $c->resource_documents($dbix_resultset, $options);

See [resource\_documents](https://metacpan.org/pod/JSONAPI::Document#resource_documents\(DBIx::Class::Row-$row,-HashRef-$options\)) for usage.
