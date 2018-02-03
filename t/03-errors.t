#! perl -w

use Test::Most;

use Mojolicious::Lite;
use Test::Mojo;

use Data::Dumper;

plugin 'JSONAPI';

get '/' => sub {
    my $c = shift;

    return $c->render_error(
        400,
        [{ title => '' }]
    );
};

my $t = Test::Mojo->new;

$t->get_ok('/')->status_is(400)->json_has('/errors/0/title');

done_testing;
