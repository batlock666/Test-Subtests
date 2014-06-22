#!perl -T

use 5.006;
use strict;
use warnings FATAL => 'all';

use Test::Builder::Tester tests => 20;
use Test::More;
use Test::Subtests;

my $line_fail = line_num(+11);

sub tests {
    my ($total, $passes) = @_;

    for (my $i = 1; $i <= $total; $i++) {
        my $name = "test $i";
        if ($i <= $passes) {
            pass($name);
        }
        else {
            fail($name);
        }
    }
}

sub tests_out {
    my ($total, $passes) = @_;

    for (my $i = 1; $i <= $total; $i++) {
        my $name ="test $i";
        if ($i <= $passes) {
            test_out("    ok $i - $name");
        }
        else {
            test_out("    not ok $i - $name");
            test_err("    #   Failed test '$name'");
            test_err("    #   at t/subtests.t line $line_fail.");
        }
    }

    test_out("    1..$total");
}

sub pass_out {
    my ($description) = @_;
    test_out("ok 1 - $description");
}

sub fail_out {
    my ($description, $line_num) = @_;
    test_out("not ok 1 - $description");
    test_err("#   Failed test '$description'");
    test_err("#   at t/subtests.t line $line_num.");
}

my $description;

# one_of, pass=0
$description = 'one_of, pass=0';
test_out("    # one_of: $description");
tests_out(3, 0);
fail_out($description, line_num(+1));
one_of $description => sub { tests(3, 0) };
test_test($description);

# one_of, pass=1
$description = 'one_of, pass=1';
test_out("    # one_of: $description");
tests_out(3, 1);
pass_out($description, line_num(+1));
one_of $description => sub { tests(3, 1) };
test_test($description);

# one_of, pass=2
$description = 'one_of, pass=2';
test_out("    # one_of: $description");
tests_out(3, 2);
fail_out($description, line_num(+1));
one_of $description => sub { tests(3, 2) };
test_test($description);

# one_of, pass=3
$description = 'one_of, pass=3';
test_out("    # one_of: $description");
tests_out(3, 3);
fail_out($description, line_num(+1));
one_of $description => sub { tests(3, 3) };
test_test($description);

# some_of, pass=0
$description = 'some_of, pass=0';
test_out("    # some_of: $description");
tests_out(3, 0);
fail_out($description, line_num(+1));
some_of $description => sub { tests(3, 0) };
test_test($description);

# some_of, pass=1
$description = 'some_of, pass=1';
test_out("    # some_of: $description");
tests_out(3, 1);
pass_out($description);
some_of $description => sub { tests(3, 1) };
test_test($description);

# some_of, pass=2
$description = 'some_of, pass=2';
test_out("    # some_of: $description");
tests_out(3, 2);
pass_out($description);
some_of $description => sub { tests(3, 2) };
test_test($description);

# some_of, pass=3
$description = 'some_of, pass=3';
test_out("    # some_of: $description");
tests_out(3, 3);
pass_out($description);
some_of $description => sub { tests(3, 3) };
test_test($description);

# none_of, pass=0
$description = 'none_of, pass=0';
test_out("    # none_of: $description");
tests_out(3, 0);
pass_out($description);
none_of $description => sub { tests(3, 0) };
test_test($description);

# none_of, pass=1
$description = 'none_of, pass=1';
test_out("    # none_of: $description");
tests_out(3, 1);
fail_out($description, line_num(+1));
none_of $description => sub { tests(3, 1) };
test_test($description);

# none_of, pass=2
$description = 'none_of, pass=2';
test_out("    # none_of: $description");
tests_out(3, 2);
fail_out($description, line_num(+1));
none_of $description => sub { tests(3, 2) };
test_test($description);

# none_of, pass=3
$description = 'none_of, pass=3';
test_out("    # none_of: $description");
tests_out(3, 3);
fail_out($description, line_num(+1));
none_of $description => sub { tests(3, 3) };
test_test($description);

# all_of, pass=0
$description = 'all_of, pass=0';
test_out("    # all_of: $description");
tests_out(3, 0);
fail_out($description, line_num(+1));
all_of $description => sub { tests(3, 0) };
test_test($description);

# all_of, pass=1
$description = 'all_of, pass=1';
test_out("    # all_of: $description");
tests_out(3, 1);
fail_out($description, line_num(+1));
all_of $description => sub { tests(3, 1) };
test_test($description);

# all_of, pass=2
$description = 'all_of, pass=2';
test_out("    # all_of: $description");
tests_out(3, 2);
fail_out($description, line_num(+1));
all_of $description => sub { tests(3, 2) };
test_test($description);

# all_of, pass=3
$description = 'all_of, pass=3';
test_out("    # all_of: $description");
tests_out(3, 3);
pass_out($description);
all_of $description => sub { tests(3, 3) };
test_test($description);

# ignore, pass=0
$description = 'ignore, pass=0';
test_out("    # ignore: $description");
tests_out(3, 0);
pass_out($description);
ignore $description => sub { tests(3, 0) };
test_test($description);

# ignore, pass=1
$description = 'ignore, pass=1';
test_out("    # ignore: $description");
tests_out(3, 1);
pass_out($description);
ignore $description => sub { tests(3, 1) };
test_test($description);

# ignore, pass=2
$description = 'ignore, pass=2';
test_out("    # ignore: $description");
tests_out(3, 2);
pass_out($description);
ignore $description => sub { tests(3, 2) };
test_test($description);

# ignore, pass=3
$description = 'ignore, pass=3';
test_out("    # ignore: $description");
tests_out(3, 3);
pass_out($description);
ignore $description => sub { tests(3, 3) };
test_test($description);
