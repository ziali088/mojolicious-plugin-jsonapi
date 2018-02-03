#! perl -w

use Test::Most;

use Mojolicious::Lite;
use Test::Mojo;

plugin 'JSONAPI';

use Data::Dumper;

my $method_status_map = {
    GET     => 200,
    POST    => 201,
    PATCH   => 200,
    DELETE  => 200,
};

my $PARAM_ID = ''; # change this on each subtest to read the right $c->param()

app->hook(before_render => sub {
    my ($c) = @_;
    my $method = $c->tx->req->method;
    my $path = $c->tx->req->url->path;
    if ( $method =~ m/PATCH|DELETE/ ) {
        is($c->param($PARAM_ID), 20, "resource id param is accessible for $method $path");
    }

    if ( $method eq 'GET' && $c->tx->req->url->path =~ m{/api/\w+/20} ) {
        is($c->param($PARAM_ID), 20, "resource id param is accessible for $method $path");
    }

});

app->hook(after_dispatch => sub {
    my ($c) = @_;

    my $method = $c->tx->req->method;
    return $c->render(
        status => $method_status_map->{$method},
        json => {}
    );
});

subtest 'resource with relationships' => sub {
    $PARAM_ID = 'post_id';

    app->resource_routes({
        resource => 'post',
        relationships => ['author', 'comments'],
    });

    my $t = Test::Mojo->new();

    $t->get_ok('/api/posts')->status_is(200);
    $t->post_ok('/api/posts')->status_is(201);

    $t->get_ok('/api/posts/20')->status_is(200);
    $t->patch_ok('/api/posts/20')->status_is(200);
    $t->delete_ok('/api/posts/20')->status_is(200);

    $t->get_ok('/api/posts/20/relationships/author')->status_is(200);
    $t->post_ok('/api/posts/20/relationships/author')->status_is(201);
    $t->patch_ok('/api/posts/20/relationships/author')->status_is(200);
    $t->delete_ok('/api/posts/20/relationships/author')->status_is(200);

    $t->get_ok('/api/posts/20/relationships/comments')->status_is(200);
    $t->post_ok('/api/posts/20/relationships/comments')->status_is(201);
    $t->patch_ok('/api/posts/20/relationships/comments')->status_is(200);
    $t->delete_ok('/api/posts/20/relationships/comments')->status_is(200);
};

subtest 'singular resource name to plural' => sub {
    $PARAM_ID = 'person_id';

    app->resource_routes({
        resource => 'person',
    });

    my $t = Test::Mojo->new();

    $t->get_ok('/api/people')->status_is(200);
    $t->post_ok('/api/people')->status_is(201);
    $t->patch_ok('/api/people/20')->status_is(200);
    $t->delete_ok('/api/people/20')->status_is(200);
};

done_testing;
