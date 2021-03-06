#! perl -w

use Test::Most;
use Mojolicious::Lite;
use Test::Mojo;

use_ok('Mojolicious::Plugin::JSONAPI');

{
    plugin 'JSONAPI', { namespace => 'api' };

    my $test = {};    # modified in each subtest for different scenarios

    get '/api/resource' => sub {
        my ($c) = @_;
        my $fields = $c->requested_fields();
        is_deeply($fields, $test, 'included fields for the resource');
        $c->render(status => 200, json => {});
    };

    get '/api/resource/relationships/author' => sub {
        my ($c) = @_;
        my $fields = $c->requested_fields();
        is_deeply($fields, $test, 'included fields for the resource for relationship route');
        $c->render(status => 200, json => {});
    };

    my $t = Test::Mojo->new();

    subtest 'no fields specified' => sub {
        $t->get_ok('/api/resource');
    };

    subtest 'main resource fields' => sub {
        $test = { fields => [qw/comments blogs/], };
        $t->get_ok('/api/resource?fields[resource]=comments,blogs');
    };

    subtest 'main resources field and relation fields' => sub {
        $test = {
            fields         => [qw/comments blogs/],
            related_fields => {
                author => [qw/name number/] } };
        $t->get_ok('/api/resource?fields[resource]=comments,blogs&fields[author]=name,number');
    };

    subtest 'can get main resource from related route' => sub {
        $test = {
            fields         => [qw/comments blogs/],
            related_fields => {
                author => [qw/name number/] } };
        $t->get_ok('/api/resource/relationships/author?fields[resource]=comments,blogs&fields[author]=name,number');
    };
}

{    # Without namespace
    plugin 'JSONAPI';

    my $test = {};    # modified in each subtest for different scenarios

    get '/weezle' => sub {
        my ($c) = @_;
        my $fields = $c->requested_fields();
        is_deeply($fields, $test, 'included fields for the resource');
        $c->render(status => 200, json => {});
    };

    get '/weezle/relationships/author' => sub {
        my ($c) = @_;
        my $fields = $c->requested_fields();
        is_deeply($fields, $test, 'included fields for the resource for relationship route');
        $c->render(status => 200, json => {});
    };

    my $t = Test::Mojo->new();

    subtest 'no fields specified' => sub {
        $t->get_ok('/api/weezle');
    };

    subtest 'main resource fields' => sub {
        $test = { fields => [qw/comments blogs/], };
        $t->get_ok('/weezle?fields[weezle]=comments,blogs');
    };

    subtest 'main resources field and relation fields' => sub {
        $test = {
            fields         => [qw/comments blogs/],
            related_fields => {
                author => [qw/name number/] } };
        $t->get_ok('/weezle?fields[weezle]=comments,blogs&fields[author]=name,number');
    };

    subtest 'can get main resource from related route' => sub {
        $test = {
            fields         => [qw/comments blogs/],
            related_fields => {
                author => [qw/name number/] } };
        $t->get_ok('/weezle/relationships/author?fields[weezle]=comments,blogs&fields[author]=name,number');
    };
}

{    # With long namespace
    plugin 'JSONAPI', { namespace => 'external/api' };

    my $test = {};    # modified in each subtest for different scenarios

    get '/external/api/resource' => sub {
        my ($c) = @_;
        my $fields = $c->requested_fields();
        is_deeply($fields, $test, 'included fields for the resource');
        $c->render(status => 200, json => {});
    };

    get '/external/api/resource/relationships/author' => sub {
        my ($c) = @_;
        my $fields = $c->requested_fields();
        is_deeply($fields, $test, 'included fields for the resource for relationship route');
        $c->render(status => 200, json => {});
    };

    my $t = Test::Mojo->new();

    subtest 'no fields specified' => sub {
        $t->get_ok('/external/api/resource');
    };

    subtest 'main resources field and relation fields in long namespace' => sub {
        $test = {
            fields         => [qw/comments blogs/],
            related_fields => {
                author => [qw/name number/] } };
        $t->get_ok('/external/api/resource?fields[resource]=comments,blogs&fields[author]=name,number');
    };

    subtest 'can get main resource from related route in long namespace' => sub {
        $test = {
            fields         => [qw/comments blogs/],
            related_fields => {
                author => [qw/name/] } };
        $t->get_ok('/external/api/relationships/author?fields[resource]=comments,blogs&fields[author]=name');
    };

}
done_testing;
