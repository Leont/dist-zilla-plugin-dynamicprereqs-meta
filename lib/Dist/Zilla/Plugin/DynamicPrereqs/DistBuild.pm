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
