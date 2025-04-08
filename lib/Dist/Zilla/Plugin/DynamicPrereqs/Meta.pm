package Dist::Zilla::Plugin::DynamicPrereqs::Meta;

use Moose;

with 'Dist::Zilla::Role::DynamicPrereqs::Meta';

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
