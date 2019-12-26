package Locale::TextDomain::UTF8::IfEnv;

# AUTHORITY
# DATE
# DIST
# VERSION

#use strict 'subs', 'vars';
#use warnings;

sub import {
    my $class = shift;
    local $Locale::TextDomain::IfEnv::textdomain = shift;
    local @Locale::TextDomain::IfEnv::search_dirs = @_;

    my $caller = caller;

    if ($ENV{PERL_LOCALE_TEXTDOMAIN_IFENV}) {
        require Locale::TextDomain::UTF8;
        eval "package $caller; use Locale::TextDomain::UTF8 \$Locale::TextDomain::IfEnv::textdomain, \@Locale::TextDomain::IfEnv::search_dirs;";
        die if $@;
    } else {
        require Locale::TextDomain::Mock;
        eval "package $caller; use Locale::TextDomain::Mock;";
    }
}

1;
# ABSTRACT: Enable translation + UTF-8 encoding only when environment variable flag is true

=for Pod::Coverage ^(.+)$

=head1 SYNOPSIS

Use like you would use L<Locale::TextDomain::UTF8> (but see L</Caveats>):

 use Locale::TextDomain::UTF8::IfEnv 'Some-TextDomain';

 print __ "Hello, world!\n";


=head1 DESCRIPTION

When imported, Locale::TextDomain::UTF8::IfEnv will check the
C<PERL_LOCALE_TEXTDOMAIN_IFENV> environment variable. If the environment
variable has a true value, the module will load L<Locale::TextDomain::UTF8> and
pass the import arguments to it. If the environment variable is false, the
module will install a mock version of C<__>, et al. Thus, all strings will
translate to themselves.

This module can be used to avoid the startup (and runtime) cost of translation
unless when you want to enable translation.

=head2 Caveats

For simplicity, currently the tied hash (C<%__>) and its hashref (C<$__>) are
not provided. Contact me if you use and need this.


=head1 ENVIRONMENT


=head1 SEE ALSO

L<Locale::TextDomain>

L<Locale::TextDomain::IfEnv>

L<Bencher::Scenarios::LocaleTextDomainIfEnv>

=cut
