#!perl

#      $URL: http://perlcritic.tigris.org/svn/perlcritic/trunk/distributions/Perl-Critic-Moose/t/policies.t $
#     $Date: 2009-05-15 19:35:37 -0500 (Fri, 15 May 2009) $
#   $Author: clonezone $
# $Revision: 3336 $

use 5.008;  # Moose's minimum version.

use strict;
use warnings;

#-----------------------------------------------------------------------------

our $VERSION = '0.999_002';

#-----------------------------------------------------------------------------

use English qw< -no_match_vars >;
use Carp qw< confess >;

use Perl::Critic::Utils qw< :characters >;
use Perl::Critic::TestUtils qw<
    pcritique_with_violations
    fcritique_with_violations
    subtests_in_tree
>;
use Perl::Critic::Violation qw<>;

use Test::More;

Perl::Critic::TestUtils::block_perlcriticrc();

Perl::Critic::Violation::set_format(
    '%f: %m at line %l, column %c.  %e. (%r)\n' ## no critic (RequireInterpolationOfMetachars)
);

my $subtests = subtests_in_tree( 't' );

# Check for cmdline limit on policies.  Example:
#   perl -Ilib t/policies.t BuiltinFunctions::ProhibitLvalueSubstr
# or
#   perl -Ilib t/policies.t t/BuiltinFunctions/ProhibitLvalueSubstr.run
if (@ARGV) {
    my @policies = keys %{$subtests}; # get a list of all tests
    # This is inefficient, but who cares...
    for (@ARGV) {  ## no critic (Variables::RequireLexicalLoopIterators)
        next if m/::/xms;
        if (not s<\A t[\\/] (\w+) [\\/] (\w+) [.]run \z><$1\::$2>xms) {
            confess 'Unknown argument ' . $_;
        }
    }
    for my $p (@policies) {
        if (0 == grep {$_ eq $p} @ARGV) {
            delete $subtests->{$p};
        }
    }
}

# count how many tests there will be
my $nsubtests = 0;
for my $subtest ( values %{$subtests} ) {
    $nsubtests += @{$subtest}; # one [pf]critique() test per subtest
}
my $npolicies = scalar keys %{$subtests}; # one can() test per policy

plan tests => $nsubtests + $npolicies;

for my $policy ( sort keys %{$subtests} ) {
    can_ok( "Perl::Critic::Policy::$policy", 'violates' );
    for my $subtest ( @{$subtests->{$policy}} ) {
        local $TODO = $subtest->{TODO}; # Is NOT a TODO if it's not set

        my $description =
            join ' - ', $policy, "line $subtest->{lineno}", $subtest->{name};

        my ($error, @violations) = run_subtest($policy, $subtest);

        my $test_passed =
            evaluate_test_results(
                $subtest, $description, $error, \@violations,
            );

        if (not $test_passed) {
            foreach my $violation (@violations) {
                diag("Violation found: $violation");
            }
        }
    }
}

sub run_subtest {
    my ($policy, $subtest) = @_;

    my @violations;
    my $error;
    if ( $subtest->{filename} ) {
        eval {
            @violations =
                fcritique_with_violations(
                    $policy,
                    \$subtest->{code},
                    $subtest->{filename},
                    $subtest->{parms},
                );
            1;
        } or do {
            $error = $EVAL_ERROR || 'An unknown problem occurred.';
        };
    }
    else {
        eval {
            @violations =
                pcritique_with_violations(
                    $policy,
                    \$subtest->{code},
                    $subtest->{parms},
                );
            1;
        } or do {
            $error = $EVAL_ERROR || 'An unknown problem occurred.';
        };
    }

    return $error, @violations;
}

sub evaluate_test_results {
    my ($subtest, $description, $error, $violations) = @_;

    my $test_passed;
    if ($subtest->{error}) {
        if ( 'Regexp' eq ref $subtest->{error} ) {
            $test_passed = like($error, $subtest->{error}, $description);
        }
        else {
            $test_passed = ok($error, $description);
        }
    }
    elsif ($error) {
        if ($error =~ m/\A Unable [ ] to [ ] create [ ] policy [ ] [']/xms) {
            # We most likely hit a configuration that a parameter didn't like.
            fail($description);
            diag($error);
            $test_passed = 0;
        }
        else {
            confess $error;
        }
    }
    else {
        my $expected_failures = $subtest->{failures};

        # If any optional modules are NOT installed, then there should be no failures.
        if ($subtest->{optional_modules}) {
            MODULE:
            for my $module (split m/,\s*/xms, $subtest->{optional_modules}) {
                eval "require $module; 1;" ## no critic (ProhibitStringyEval)
                    or do {
                        $expected_failures = 0;
                        last MODULE;
                    };
            }
        }

        $test_passed =
            is(scalar @{$violations}, $expected_failures, $description);
    }

    return $test_passed;
}

# Local Variables:
#   mode: cperl
#   cperl-indent-level: 4
#   fill-column: 78
#   indent-tabs-mode: nil
#   c-indentation-style: bsd
# End:
# setup vim: set filetype=perl tabstop=4 softtabstop=4 expandtab :
# setup vim: set shiftwidth=4 shiftround textwidth=78 nowrap autoindent :
# setup vim: set foldmethod=indent foldlevel=0 :
