package Dist::Zilla::Plugin::DynamicPrereqs::ModuleBuildTiny;

use 5.020;
use Moose;
use experimental qw/signatures/;
use namespace::autoclean;

with 'Dist::Zilla::Role::PrereqSource', 'Dist::Zilla::Role::DynamicPrereqs::Meta';

sub register_prereqs($self) {
	$self->zilla->register_prereqs({ phase => 'configure' }, 'Module::Build::Tiny' => '0.048');
	$self->zilla->register_prereqs({ phase => 'configure' }, 'CPAN::Requirements::Dynamic' => '0.002');
	return;
}

__PACKAGE__->meta->make_immutable;

1;

# ABSTRACT: Add dynamic prereqs to the metadata for Module::Build::Tiny

=head1 SYNOPSIS

 [ModuleBuildTiny]
 [DynamicPrereqs::ModuleBuildTiny]
 condition = is_os linux
 condition = not has_perl 5.036
 joiner = and
 prereq = Foo::Bar 1.2

=head1 DESCRIPTION

This module adds L<dynamic prerequisites|CPAN::Requirements::Dynamic> to the metafile of a L<Module::Build::Tiny> using dist.

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
