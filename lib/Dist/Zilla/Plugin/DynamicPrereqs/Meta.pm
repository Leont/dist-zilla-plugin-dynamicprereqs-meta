package Dist::Zilla::Plugin::DynamicPrereqs::Meta;

use Moose;
use namespace::autoclean;

with 'Dist::Zilla::Role::DynamicPrereqs::Meta';

__PACKAGE__->meta->make_immutable;

1;

# ABSTRACT: Add dynamic prereqs to the metadata

=head1 SYNOPSIS

 [DynamicPrereqs::Meta]
 condition = is_os linux
 condition = not has_perl 5.036
 joiner = and
 prereq = Foo::Bar 1.2

=head1 DESCRIPTION

This plugin is adds dynamic prereqs to the metadata. Note that for most uses it's recommended to use the various plugins for your install tool, that will enable support for dynamic prereqs metadata for that tool. So far the following have been implemented.

=over 4

=item * L<Dist::Zilla::Plugin::ModuleBuildTiny::DynamicPrereqs>

This will add all the necessary prereqs to enable dynamic prerequisites in L<Module::Build::Tiny>.

=item * L<Dist::Zilla::Plugin::DistBuild::DynamicPrereqs>

This will add everything needed to enable dynamic prerequisites in L<Dist::Build>.

=back

More plugins are planned for the future.

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
