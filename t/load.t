#!./perl -w

use Test; BEGIN { plan test => 2 }

use Time;
ok 1;

ok abs($Time::Now - time) < 1;
