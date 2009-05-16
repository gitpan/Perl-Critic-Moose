#!/usr/bin/env perl

#      $URL: http://perlcritic.tigris.org/svn/perlcritic/trunk/distributions/Perl-Critic-Moose/xt/author/perlcritic-tests.t $
#     $Date: 2009-05-15 19:35:37 -0500 (Fri, 15 May 2009) $
#   $Author: clonezone $
# $Revision: 3336 $

use 5.008;  # Moose's minimum version.

use strict;
use warnings;

our $VERSION = '0.999_002';

use Test::Perl::Critic (
    -severity => 1,
    -profile => 'xt/author/perlcriticrc-tests'
);

all_critic_ok( qw< t xt > );

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
