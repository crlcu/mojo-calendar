use Mojo::Base -strict;
use Test::More;
use Mojo::Calendar;

my $date = Mojo::Calendar->new(from => '2019-03-20');

is($date->yesterday->ymd, '2019-03-19');
is($date->today->ymd, '2019-03-20');
is($date->tomorrow->ymd, '2019-03-21');
is($date->firt_day_of_next_month->ymd, '2019-04-01');
is($date->days_ago(6)->ymd, '2019-03-14');
is($date->months_ago(6)->ymd, '2018-09-20');

done_testing;
