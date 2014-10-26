#!/usr/bin/env perl

#      $URL: http://perlcritic.tigris.org/svn/perlcritic/trunk/distributions/Perl-Critic-Moose/xt/author/pod_coverage.t $
#     $Date: 2009-05-15 19:35:37 -0500 (Fri, 15 May 2009) $
#   $Author: clonezone $
# $Revision: 3336 $

use 5.008;  # Moose's minimum version.

use strict;
use warnings;

our $VERSION = '0.999_002';

use Test::More;
use Test::Pod::Coverage;

my @trusted_methods = qw<
    applies_to
    default_severity
    default_themes
    initialize_if_enabled
    prepare_to_scan_document
    supported_parameters
    violates
>;

my $method_string = join q< | >, @trusted_methods;
my $regex = qr< \A (?: $method_string ) \z >xms;
all_pod_coverage_ok( { trustme => [$regex] } );

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
