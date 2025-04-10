package Dist::Zilla::Plugin::DynamicPrereqs::DistBuild;

use 5.020;
use Moose;
use experimental qw/signatures/;

with 'Dist::Zilla::Role::PrereqSource', 'Dist::Zilla::Role::DynamicPrereqs::Meta', 'Dist::Zilla::Role::FileGatherer';

sub register_prereqs($self) {
	$self->zilla->register_prereqs({ phase => 'configure' }, 'Dist::Build::DynamicPrereqs' => '0.019');
	return;
};

my $content = <<EOF;
load_extension('Dist::Build::DynamicPrereqs', 0.019);
evaluate_dynamic_prereqs();
EOF

sub gather_files($self) {
	require Dist::Zilla::File::InMemory;
	my $file = Dist::Zilla::File::InMemory->new({
		name    => 'planner/dynamic_prereqs.pl',
		content => $content,
	});

	return;
};

1;

# ABSTRACT: Add dynamic prereqs to the metadata for Dist::Build

=head1 SYNOPSIS

 [DistBuild]
 [DynamicPrereqs::DistBuild]
 condition = is_os linux
 condition = not has_perl 5.036
 joiner = and
 prereq = Foo::Bar 1.2

=head1 DESCRIPTION

This module adds L<dynamic prerequisites|CPAN::Requirements::Dynamic> to the metafile of a L<Dist::Build> using dist.

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
