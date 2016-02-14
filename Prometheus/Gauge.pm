package Prometheus::Gauge;

use strict;
use warnings;

use Data::Dumper;
#use parent 'Prometheus';

# TODO track internal errors

sub new {
	my $class = shift;
	my %options = @_;
	die "\$name must not be empty\n" unless defined $options{name};

	my $self = {
#		help => 'No help provided',
		%options,
	};

	bless $self, $class;
	return $self;
}

sub add {
	my $self = shift;
	my %options = @_;

	die "Value '$options{value}' is empty\n" unless defined $options{value};
	die "Value '$options{value}' is not a float\n" unless $options{value} =~ /^[+-]?(?=\.?\d)\d*\.?\d*(?:e[+-]?\d+)?\z/i;

	$self->{text} .= $self->{name}. "{". $options{labels}. "} $options{value}\n";
}

sub print {
	my $self = shift;

	print "# TYPE $self->{name} gauge\n";
	print "# HELP $self->{name} $self->{help}\n" if defined $self->{help};
	print $self->{text};
}


1;
