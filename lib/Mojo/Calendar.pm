package Mojo::Calendar;
use Mojo::Base -base;

our $VERSION = '0.0.1';

use Carp qw(croak);
use DateTime;
use DateTime::Format::Flexible;

has [qw(from)];

has 'datetime' => sub {
    my $self = shift;

    return $self->from if (ref($self->from) eq 'DateTime');

    if ($self->from) {
        if (my $datetime = DateTime::Format::Flexible->parse_datetime($self->from)) {
            return $datetime
                ->set_locale($self->locale)
                ->set_time_zone($self->time_zone);
        }
    }

    return DateTime->now
        ->set_locale($self->locale)
        ->set_time_zone($self->time_zone);
};

has 'locale' => 'en_gb';
has 'time_zone' => 'Europe/London';

sub new {
    my $self = shift;

    if (@_ > 1) {
        return $self->SUPER::new({@_});
    } elsif (ref $_[0] eq 'HASH') {
        return $self->SUPER::new(@_);
    }

    return $self->SUPER::new(from => $_[0]);
}

sub days_ago {
    return shift->datetime
        ->clone
        ->subtract(days => shift);
}

sub firt_day_of_next_month {
    return shift->datetime
        ->clone
        ->add(months => 1)
        ->set_day(1);
}

sub months_ago {
    return shift->datetime
        ->clone
        ->subtract(months => shift);
}

sub today {
    return shift;
}

sub tomorrow {
    return shift->datetime
        ->clone
        ->add(days => 1);
}

sub yesterday {
    return shift->days_ago(1);
}

sub AUTOLOAD {
    my $self   = shift;
    our $AUTOLOAD;
    my $method = $AUTOLOAD =~ /::(\w+)$/ ? $1 : undef;

    $method =~ s/.*:://;
    return unless $method =~ /[^A-Z]/; # skip DESTROY and all-cap methods

    return $self->datetime->$method if ($self->datetime && $self->datetime->can($method));

    croak "Undefined method $AUTOLOAD";
}

1;

=encoding utf8

=head1 NAME

Mojo::Calendar - Extended DateTime manipulator

=head1 SYNOPSIS

    use Mojo::Calendar;

    # Calendar with default date being now
    my $calendar = Mojo::Calendar->new;

    say $calendar->ymd;
    say $calendar->his;

    say $calendar->tomorrow->ymd;

    # Calendar with default date being now
    my $calendar = Mojo::Calendar->new;

    say $calendar->ymd;
    say $calendar->his;

    # Calendar with default date being 2019-03-28 15:29:00
    my $calendar = Mojo::Calendar->new('2019-03-28 15:29:00');

    say $calendar->ymd;
    say $calendar->his;

=head1 DESCRIPTION

L<Mojo::Asset::File> is a file storage backend for HTTP content.

=head1 EVENTS

L<Mojo::Asset::File> inherits all events from L<Mojo::Asset>.

=head1 ATTRIBUTES

L<Mojo::Calendar> inherits all attributes from L<DateTime> and implements
the following new ones.

=head2 locale

    my $locale = $file->locale;
    $locale    = $file->locale($locale);

Locale, defaults to the C<en_gb>.
See L<DateTime::Locale> for more details.

=head2 time_zone

    my $time_zone = $file->time_zone;
    $time_zone    = $file->time_zone($time_zone);

Timezone, defaults to the C<Europe/London>.
See L<DateTime::TimeZone> for more details.

=head1 METHODS

L<Mojo::Calendar> inherits all methods from L<DateTime> and implements
the following new ones.

=head2 days_ago

    my $datetime = $calendar->days_ago(2);

2 days ago datetime object.

=head2 firt_day_of_next_month

    my $datetime = $calendar->firt_day_of_next_month;

First day of next month datetime object.

=head2 months_ago

    my $datetime = $calendar->months_ago(3);

3 months ago datetime object.

=head2 today

    my $datetime = $calendar->today;

today datetime object.

=head2 tomorrow

    my $datetime = $calendar->tomorrow;

tomorrow datetime object.

=head2 yesterday

    my $datetime = $calendar->yesterday;

yesterday datetime object.

=head1 SEE ALSO

L<DateTime>, L<Mojolicious>, L<Mojolicious::Guides>, L<https://mojolicious.org>.

=cut
