use strict;
package Time;
require DynaLoader;
use base ('Exporter','DynaLoader');
use vars qw($VERSION @EXPORT_OK %AdjustCB $Now $API);
$VERSION = '0.01';
@EXPORT_OK = qw($Now);

__PACKAGE__->bootstrap($VERSION);

*CORE::GLOBAL::time = \&time;
*CORE::GLOBAL::sleep = \&sleep;

sub broadcast_adjustment {
    my ($adj) = @_;
    for my $x (values %AdjustCB) { $x->($adj) }
}

sub subscribe {
    my ($code) = @_;
    $AdjustCB{$code} = $code;
}

sub unsubscribe {
    my ($code) = @_;
    delete $AdjustCB{$code};
}

1;
=head1 NAME

Time - Pluggable time API

=head1 SYNOPSIS

  use Time;   # installs CORE::GLOBAL time & sleep

=head1 DESCRIPTION

This module insert a level of indirection between the actually
hardware-level time and the time as seen by the current process.

An attempt is made to avoid any assumptions about how time is
represented and what is its available precision.

New functions are installed into both C<CORE::GLOBAL::time> and
C<CORE::GLOBAL::sleep>.  This causes any perl module that makes use of
C<time> or C<sleep> to get the definitions installed by L<Time>
instead of C<CORE::time> or C<CORE::sleep>.

There is also a C-API available for customizing the passage of time.

=head1 SUPPORT

This extension is discussed on the perl-loop@perl.org mailing list.

=head1 ALSO SEE

L<Time::HiRes> and L<Event>

=head1 AUTHOR

Joshua Pritikin E<lt>F<bitset@mindspring.com>E<gt>

=head1 COPYRIGHT

Copyright © 1998 Joshua Nathaniel Pritikin.  All rights reserved.
This program is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
