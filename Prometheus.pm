package Prometheus;

use strict;
use warnings;
use diagnostics;

use Data::Dumper;

use Prometheus::Gauge;

# TODO track internal errors

sub new {
	my $class = shift;
	my %options = @_;

	my $self = {
		%options,
	};

	bless $self, $class;
	return $self;
}

sub register_metric {
	my ($self, $metric) = @_;
	push @{$self->{metrics}}, $metric;
}

sub content {
	my $self = shift;

	my $content;
	foreach my $metric (@{$self->{metrics}}) {
		$content .= $metric->get_string();
	}
	return $content;
}

sub Prometheus::gauge {
	my $self = shift;
	my $gauge = Prometheus::Gauge->new(@_);
	$self->register_metric($gauge);
	return $gauge;
}


1;
