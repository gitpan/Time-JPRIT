#!./perl -w

use Test; BEGIN { plan test => 2 }

use Time;

my $code = sub {
    ok shift, 1.5;
};

Time::subscribe($code);
Time::broadcast_adjustment(1.5);
Time::unsubscribe($code);

Time::broadcast_adjustment(2.5);
ok 1;
