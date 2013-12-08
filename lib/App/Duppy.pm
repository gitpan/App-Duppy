package App::Duppy;

# ABSTRACT: a wrapper around casperjs to pass test configurations as json files
use strict;
use warnings;
use Moo;
use MooX::Options;
use IPC::Cmd qw/can_run run/;
use IO::All;
use JSON;
use DDP;
use Carp;
use Try::Tiny;

option 'test' => (
    is       => 'rw',
    required => 1,
    format   => 's@',
    doc =>
'Test option: one ore more json file(s) containing the casperjs tests to perform'
);

option 'casper_path' => (
    is      => 'rw',
    format  => 's',
    doc     => 'Path to casperjs, if not standard',
    predicate => 'has_casper_path',
);

has 'tests' => ( is => 'lazy', );

sub _build_tests {
    my $self = shift;
    my $ret  = {};
    foreach my $file ( @{ $self->test } ) {
        if ( io($file)->exists ) {
            my $content = io($file)->slurp;
            try {
                $ret->{$file} = decode_json($content);
            }
            catch {
                carp "'$file' is not valid: $_";
            };
        }
        else {
            carp "'$file' does not exist";
        }
    }
    return $ret;
}

sub run_casper {
    my $self      = shift;
    my $full_path;
    if ($self->has_casper_path) {
        if (-f $self->casper_path and -x $self->casper_path) {
            $full_path = $self->casper_path;
        } else {
            croak sprintf(q{'%s' is not an executable file},
                          $self->casper_path);
        }
    } else {
        $full_path = can_run( 'casperjs' )
            or croak 'Cannot find casperjs on your system. Please make sure it is installed or the path provided is ok';
    }
    my $silent_run = shift;
    foreach my $test ( keys %{ $self->tests } ) {
        my $param_spec = $self->transform_arg_spec( $self->tests->{$test} );
        unshift @{ $param_spec->{cmd} }, $full_path;
        push @{ $param_spec->{cmd} }, "test",
          join( " ", @{ $param_spec->{paths} } );
        my ( $ok, $err, $full_buff ) =
          run( command => \@{ $param_spec->{cmd} } );
        my $buff_return = join( "", @$full_buff );
        if ($silent_run) {
            return $buff_return;
        }
        else {
            print $buff_return;
            return;
        }
    }
}

sub transform_arg_spec {
    my $self   = shift;
    my $params = shift;
    my $ret    = {};
    $ret->{paths} = delete $params->{paths};
    while ( my ( $k, $v ) = each %{$params} ) {
        if ( ref($v) eq 'ARRAY' ) {
            $v = join( ',', @{$v} );
        }
        else {
            $v = "true"  if ( $v eq '1' );
            $v = "false" if ( $v eq '0' );
        }
        push @{ $ret->{cmd} }, "--$k=$v";
    }
    return $ret;
}



1;

__END__

=pod

=encoding UTF-8

=head1 NAME

App::Duppy - a wrapper around casperjs to pass test configurations as json files

=head1 VERSION

version 0.02

=head1 SYNOPSIS

  # will launch casperjs with the options mentionned in the file. See in
  # the fixture directory for an example 
  duppy --test mytestplan.json --test myothertestplan.json 

=head1 DESCRIPTION 

The original idea came from a discussion I had with Nicolas Perriault. I was searching a way to organise my casperjs tests, 
and he came out with this suggestion. 

So I decided to write a little wrapper around casperjs that would be able to launch tests using the format he suggested. 

See https://github.com/n1k0/casperjs/issues/745 for more information about it. 

=head1 AUTHORS

=over 4

=item *

Emmanuel "BHS_error" Peroumalnaik

=item *

Fabrice "pokki" Gabolde

=back

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by E. Peroumalnaik.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
