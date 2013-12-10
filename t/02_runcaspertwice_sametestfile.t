use Test::More;
use FindBin qw/$Bin/;
use lib "$Bin/../lib";
use App::Duppy;
use IPC::Cmd qw/can_run/;
plan skip_all => 'Casperjs is not installed on your system'
  unless ( can_run('casperjs') );

my $duppy =
  App::Duppy->new_with_options(
    test => ["$Bin/../t/fixtures/casper_working_ex.json"] );
my $out1 =  $duppy->run_casper(1);
my $out2 =  $duppy->run_casper(1);
like $out1, qr/PASS 8 tests executed/,
  'Our casperjs tests pass';

is ($out1,$out2, 'and the two outputs we have are identical');
done_testing;

