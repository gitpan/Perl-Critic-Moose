#!perl

#      $URL: http://perlcritic.tigris.org/svn/perlcritic/trunk/Perl-Critic-Moose/Build.PL $
#     $Date: 2008-10-30 09:36:26 -0500 (Thu, 30 Oct 2008) $
#   $Author: clonezone $
# $Revision: 2845 $

use 5.008;  # Moose's minimum version.

use strict;
use warnings;

use English qw< -no_match_vars >;

use Module::Build;


my $class = Module::Build->subclass( code => <<'END_SUBCLASS' );

    sub ACTION_test {
        my ($self) = @_;

        $self->depends_on('manifest');

        return $self->SUPER::ACTION_test();
    }

    sub ACTION_authortest {
        my ($self) = @_;

        $self->depends_on('build');
        $self->depends_on('manifest');
        $self->depends_on('distmeta');

        $self->test_files( qw< t xt/author > );
        $self->recursive_test_files(1);

        $self->depends_on('test');

        return;
    } # end ACTION_authortest()

    sub ACTION_distdir {
        my ($self) = @_;

        $self->depends_on('authortest');

        return $self->SUPER::ACTION_distdir();
    } # end ACTION_distdir

END_SUBCLASS

my $builder = $class->new(
    module_name         => 'Perl::Critic::Moose',
    dist_author         => 'Elliot Shank <perl@galumph.com>',
    license             => 'perl',
    dynamic_config      => 0,
    create_readme       => 0,
    create_packlist     => 1,
    sign                => 0,

    requires            => {
        'Perl::Critic::Policy'      => '1.093_02',
        'Perl::Critic::Utils'       => '1.093_02',
        'Perl::Critic::Utils::PPI'  => '1.093_02',
        Readonly                    => 0,
        base                        => 0,
        strict                      => 0,
        version                     => 0,
        warnings                    => 0,
    },

    build_requires      => {
        Carp                        => 0,
        English                     => 0,
        'Perl::Critic::TestUtils'   => '1.093_02',
        strict                      => 0,
        warnings                    => 0,
    },

    recommends          => {
    },

    create_makefile_pl  => 'traditional',

    meta_merge          => {
        resources   => {
            homepage    => 'http://perlcritic.com',
            license     => 'http://dev.perl.org/licenses/',
            Repository  => 'http://perlcritic.tigris.org/svn/perlcritic/trunk/Perl-Critic-Moose/',
            MailingList => 'http://perlcritic.tigris.org/servlets/SummarizeList?listName=users',
        }
    },

    add_to_cleanup      => [
        qw<
            MANIFEST
            MANIFEST.bak
            META.yml
            Makefile
            Makefile.old
            Makefile.PL
            pod2htm?.tmp
            pm_to_blib
            Perl-Critic-Moose-*
        >,
    ],
);


$builder->create_build_script();

##############################################################################
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