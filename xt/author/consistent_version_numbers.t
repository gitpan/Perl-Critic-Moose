#!/usr/bin/env perl

#      $URL: http://perlcritic.tigris.org/svn/perlcritic/trunk/distributions/Perl-Critic-Moose/xt/author/consistent_version_numbers.t $
#     $Date: 2009-05-15 19:35:37 -0500 (Fri, 15 May 2009) $
#   $Author: clonezone $
# $Revision: 3336 $

# Taken from
# http://www.chrisdolan.net/talk/index.php/2005/11/14/private-regression-tests/.

use 5.008;  # Moose's minimum version.

use strict;
use warnings;

our $VERSION = '0.999_002';

use File::Find;
use File::Slurp;

use Test::More qw(no_plan);


my $last_version = undef;
find({wanted => \&check_version, no_chdir => 1}, 'blib');
if (! defined $last_version) {
    ## no critic (RequireInterpolationOfMetachars)
    fail('Failed to find any files with $VERSION');
    ## use critic
} # end if


sub check_version {
    # $_ is the full path to the file
    return if ! m{blib/script/}xms && ! m{ [.] pm \z}xms;

    my $content = read_file($_);

    # only look at perl scripts, not sh scripts
    return if m{blib/script/}xms && $content !~ m/\A \#![^\r\n]+?perl/xms;

    my @version_lines = $content =~ m/ ( [^\n]* \$VERSION [^\n]* ) /gxms;
    if (@version_lines == 0) {
       fail($_);
    } # end if
    foreach my $line (@version_lines) {
        if (!defined $last_version) {
            $last_version = shift @version_lines;
            pass($_);
        } else {
            is($line, $last_version, $_);
        } # end if
    } # end foreach

    return;
} # end check_version()

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
