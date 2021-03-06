package Gitpan::Role::HasConfig;

use Gitpan::perl5i;

use Moo::Role;
use Gitpan::Types;

use Gitpan::Config;

method config() {
    return Gitpan::Config->default;
}


=head1 NAME

Gitpan::Role::HasConfig - Per object access to the config

=head1 SYNOPSIS

    {
        package Some::Class;
        use Gitpan::OO;
        with 'Gitpan::Role::HasConfig';
    }

    my $obj = Some::Class->new;
    my $config = $obj->config;

=head1 DESCRIPTION

With this role your object will have access to the Gitpan configuration.

The configuration is shared by all.

=head2 Methods

=head3 config

Returns the shared L<Gitpan::Config> object.

This can be called as a class or object method.

=head1 SEE ALSO

L<Gitpan::ConfigFile>

=cut
