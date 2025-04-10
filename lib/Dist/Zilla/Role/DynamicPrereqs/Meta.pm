package Dist::Zilla::Role::DynamicPrereqs::Meta;

use 5.020;
use Moose::Role;
use experimental qw/signatures postderef/;

with 'Dist::Zilla::Role::MetaProvider';

use Carp 'croak';
use Cpanel::JSON::XS;
use Dist::Zilla::File::InMemory;
use MooseX::Types::Moose qw/ArrayRef Str/;
use Text::ParseWords 'shellwords';

my $coder = Cpanel::JSON::XS->new->pretty;

my %aliases = (
	condition => 'conditions',
	prereq    => 'prereqs',
);

around 'mvp_multivalue_args', sub($orig, $self) {
	return ($self->$orig, values %aliases);
};

around 'mvp_aliases', sub($orig, $self) {
	return { $self->$orig->%*, %aliases };
};

has joiner => (
	is      => 'ro',
	isa     => Str,
	default => 'and',
);

has input_conditions => (
	init_arg => 'conditions',
	required => 1,
	isa      => ArrayRef[Str],
	traits   => ['Array'],
	handles  => {
		input_conditions => 'elements',
	},
);

has input_prereqs => (
	init_arg => 'prereqs',
	traits   => ['Array'],
	isa      => ArrayRef,
	handles  => {
		input_prereqs => 'elements',
	},
);

has error => (
	is  => 'ro',
	isa => Str,
);

has phase => (
	is      => 'ro',
	isa     => Str,
	default => 'runtime',
);

has relationship => (
	is      => 'ro',
	isa     => Str,
	default => 'requires',
);

sub metadata($self) {
	my @conditions = map { [ shellwords($_) ] } $self->input_conditions;
	my $condition = @conditions == 1 ? $conditions[0] : [ $self->joiner, @conditions ];
	my %entry = ( condition => $condition );
	$entry{phase} = $self->phase if $self->phase ne 'runtime';
	$entry{relationship} = $self->relationship if $self->relationship ne 'requires';
	if ($self->error) {
		$entry{error} = $self->error;
	} else {
		my %result;
		for my $line ($self->input_prereqs) {
			my ($module, $version) = split ' ', $line, 2;
			$result{$module} = $version // 0;
		}
		$entry{prereqs} = \%result;
	}

	return {
		dynamic_config    => 1,
		x_static_install  => 0,
		x_dynamic_prereqs => {
			version     => 1,
			expressions => [
				\%entry
			],
		},
	};
}

1;

# ABSTRACT: A role to add dynamic prereqs to to the metadata in your Dist::Zilla build

=head1 DESCRIPTION

This is a role for adding plugins that add L<dynamic prerequisites|CPAN::Requirements::Dynamic> to the metadata.

=attr conditions

One or more conditions, as defined by L<CPAN::Requirements::Dynamic>.

=attr joiner

The operator that is used when more than one condition is given. This must be either C<and> or C<or>.

=attr prereqs

One or more prerequisites that will be added to the requirements if the condition passes.

=attr phase

The phase of the prerequisites, this defaults to C<'runtime'>.

=attr relation

The relationship of the prerequisites, this defaults to C<'requires'>.

=attr error

Instead of prerequisites being added, an error will be outputted if the condition matches.
