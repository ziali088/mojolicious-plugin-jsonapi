package Mojolicious::Plugin::JSONAPI;

use Mojo::Base 'Mojolicious::Plugin';

use Carp ();
use Lingua::EN::Inflexion ();

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
        $spec->{namespace} ||= 'api';
        $spec->{controller} ||= 'api-' . $spec->{resource};
        $spec->{relationships} ||= [];

        my $resource = Lingua::EN::Inflexion::noun($spec->{resource});
        my $resource_singular = $resource->singular;
        my $resource_plural = $resource->plural;

        my $r = $app->routes->under( sprintf('/%s/%s', $spec->{namespace}, $resource_plural) )->to(controller => $spec->{controller});

        $r->get('/')->to(action => "search_${resource_plural}");

        $r->post('/')->to(action => "create_${resource_singular}");

        foreach my $method ( qw/get patch delete/ ) {
            $r->$method("/:${resource_singular}_id")->to(action => "${method}_${resource_singular}");
        }

        foreach my $relationship ( @{$spec->{relationships}} ) {
            my $path = "/:${resource_singular}_id/relationships/${relationship}";
            foreach my $method ( qw/get post patch delete/ ) {
                $r->$method($path)->to(action => "${method}_related_${relationship}");
            }
        }
    });
}

1;

__END__

=encoding UTF-8

=head1 NAME

Mojolicious::Plugin::JSONAPI - Mojolicious Plugin for building JSON API compliant applications

=head1 VERSION

=head1 SYNOPSIS

    # Mojolicious

    # Using route helpers

    sub startup {
        my ($self) = @_;

        $self->plugin('JSONAPI');

        # Create the following routes:

        # GET '/posts'
        # POST '/posts'
        # PATCH '/posts/:post_id
        # DELETE '/posts/:post_id

        # GET '/posts/:post_id/relationships/author'
        # POST '/posts/:post_id/relationships/author'
        # PATCH '/posts/:post_id/relationships/author'
        # DELETE '/posts/:post_id/relationships/author'

        # GET '/posts/:post_id/relationships/comments'
        # POST '/posts/:post_id/relationships/comments'
        # PATCH '/posts/:post_id/relationships/comments'
        # DELETE '/posts/:post_id/relationships/comments'

        $self->resource_routes({
            resource => 'post',
            relationships => ['author', 'comments'],
        });
    }

=head1 DESCRIPTION

This module intends to supply the user with helper methods that can be used to build JSON API
compliant data structures.

See L<http://jsonapi.org/> for the JSON API specification. At the time of writing, the version was 1.0.

The specification takes backwards compatability pretty seriously, so your app should be able to use this
plugin without much issue.

C<Mojolicious::Lite> is not supported yet as I personally felt that if you're dealing with database schemas
and converting them into strict JSON structures, that's enough for you to think about migrating to C<Mojolicious>.

=head1 METHODS

=head2 resource_routes(I<HashRef> $spec)

Creates a set of routes for the given resource. C<$spec> is a hash reference of the resources specification
with the following options:

    {
        resource        => 'post', # name of resource, required
        namespace       => 'api', # namespace to create the resource under i.e. '/api/posts'. default is 'api'
        controller      => 'api-posts', # name of controller, defaults to 'api-' . $spec->{resource}
        relationships   => ['author', 'comments'], # default is []
    }

C<resource> should be a singular noun, which will be turned into it's pluralised version (e.g. "post" -> "posts").

Specifying C<relationships> will create additional routes that fall under the resource.

B<NOTE>: Your relationships should be in the correct form (singular/plural) based on the relationship in your
schema management system. So if you have a resource called "post" and it C<has_many> "comments", make sure
comments is passed in as a plural noun (same for C<belongs_to>).

=cut
