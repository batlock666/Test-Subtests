package Test::Subtests;

use base 'Test::Builder::Module';
our @EXPORT = qw(one_of);

use Test::Builder;

use 5.006;
use strict;
use warnings FATAL => 'all';

my $CLASS = __PACKAGE__;

=head1 NAME

Test::Subtests - The great new Test::Subtests!

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';


=head1 SYNOPSIS

Quick summary of what the module does.

Perhaps a little code snippet.

    use Test::Subtests;

    my $foo = Test::Subtests->new();
    ...

=head1 EXPORT

A list of functions that can be exported.  You can delete this section
if you don't export anything, such as for a purely object-oriented module.

=head1 SUBROUTINES/METHODS

=head2 _subtest NAME, CODE, CHECK

=cut

sub _subtest {
    # Process arguments.
    my ($name, $code, $check) = @_;

    # Get the caller's name.
    my $caller = (caller(1))[3];
    $caller =~ s/.*:://;

    # Get the test builder.
    my $builder = $CLASS->builder;

    # Check the arguments $code and $check.
    if ('CODE' ne ref $code) {
        $builder->croak("$caller()'s second argument must be a code ref");
    }
    if ($check) {
        if ('CODE' ne ref $check) {
            $builder->croak("$caller()'s third argument must be a code ref'");
        }
    }

    my $error;
    my $child;
    my $parent = {};
    {
        # Override the level.
        local $Test::Builder::Level = $Test::Builder::Level + 1;

        # Create a child test builder, and replace the parent by it.
        $child = $builder->child($name);
        Test::Builder::_copy($builder,  $parent);
        Test::Builder::_copy($child, $builder);

        # Run the subtests and catch the errors.
        my $run_subtests = sub {
            $builder->note("$caller: $name");
            $code->();
            $builder->done_testing unless $builder->_plan_handled;
            return 1;
        };
        if (!eval { $run_subtests->() }) {
            $error = $@;
        }
    }

    # Restore the child and parent test builders.
    Test::Builder::_copy($builder,   $child);
    Test::Builder::_copy($parent, $builder);

    # Restore the parent's TODO.
    $builder->find_TODO(undef, 1, $child->{Parent_TODO});

    # Die after the parent is restored.
    die $error if $error and !eval { $error->isa('Test::Builder::Exception') };

    # Override the level.
    local $Test::Builder::Level = $Test::Builder::Level + 1;

    # Check the results of the subtests.
    if ($check) {
        $child->no_ending(1);
        $child->is_passing(&$check($child));
    }

    # Finalize the child test builder.
    my $finalize = $child->finalize;

    # Bail out if the child test builder bailed out.
    $builder->BAIL_OUT($child->{Bailed_Out_Reason}) if $child->{Bailed_Out};

    return $finalize;
}

=head2 one_of NAME, CODE

=cut

sub one_of {
    # Process arguments.
    my ($name, $code) = @_;

    # Define the check: only one subtest must pass.
    my $check = sub {
        my ($child) = @_;
        my $count = 0;
        foreach my $result (@{$child->{Test_Results}}) {
            $count++ if $result->{ok};
        }
        return $count == 1;
    };

    # Run the subtests.
    return _subtest($name, $code, $check);
}

=head1 AUTHOR

Bert Vanderbauwhede, C<< <batlock666 at gmail.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-test-subtests at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Test-Subtests>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Test::Subtests


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Test-Subtests>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Test-Subtests>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Test-Subtests>

=item * Search CPAN

L<http://search.cpan.org/dist/Test-Subtests/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

Copyright 2014 Bert Vanderbauwhede.

This program is free software; you can redistribute it and/or modify it under
the terms of the GNU Lesser General Public License as published by the Free
Software Foundation, either version 3 of the License, or (at your option)
any later version.

See L<http://www.gnu.org/licenses/> for more information.

=cut

1; # End of Test::Subtests
