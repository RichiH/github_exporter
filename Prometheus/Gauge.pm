package Prometheus::Gauge;

use strict;
use warnings;
use diagnostics;

use Data::Dumper;


# TODO track internal errors

sub new {
	my $class = shift;
	my %options = @_;
	die "Prometheus::Gauge: \$name must not be empty\n" unless defined $options{name};

	my $self = {
#		help => 'No help provided',
		%options,
	};

	bless $self, $class;
	return $self;
}

sub set {
	my $self = shift;
	my %options = @_;

	die "Value '$options{value}' is empty\n" unless defined $options{value};
	die "Value '$options{value}' is not a float\n" unless $options{value} =~ /^  [+-]? ( (\d+ (\.\d*)?)  |  (\.\d+) ) $/x;

	$self->{metrics}{$options{labels}} = $options{value};
}

sub get_string {
	my $self = shift;

	my $output = "# TYPE $self->{name} gauge\n";
	$output   .= "# HELP $self->{name} $self->{help}\n" if defined $self->{help};
	foreach my $metric (sort(keys %{$self->{metrics}})) {
		$output   .= "$self->{name}\{$metric} " . $self->{metrics}{$metric} . "\n";
	}

	return $output;
}


1;
