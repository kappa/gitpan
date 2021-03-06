package Gitpan::CPAN::Authors;

use Gitpan::perl5i;
use Gitpan::OO;
use Gitpan::Types;

use Gitpan::CPAN::Author;
use Encode;
use Email::Valid;

haz __authors =>
  is            => 'ro',
  isa           => HashRef[InstanceOf['Gitpan::CPAN::Author']],
  lazy          => 1,
  builder       => '_build_authors';

haz file =>
  is            => 'ro',
  isa           => Path,
  required      => 1;

method _build_authors {
    require IO::Zlib;
    my $fh = IO::Zlib->new;
    $fh->open( $self->file.'', 'rb' )
      or croak "IO::Zlib can't open @{[$self->file]}: $!";

    my $authors = {};

    while( <$fh> ) {
        chomp;
        my($cpanid, $email, $name, $url) = split /\t/, Encode::decode_utf8($_);

        # Fall back to the author's cpan.org email if none is provided.
        $email   = lc($cpanid).'@cpan.org' unless $self->is_valid_email($email);
        $url   //= '';

        $authors->{$cpanid} = Gitpan::CPAN::Author->new(
            cpanid      => $cpanid,
            name        => $name,
            url         => $url,
            email       => $email
        );
    }

    return $authors;
}


method author(Str $cpanid) {
    return $self->__authors->{$cpanid};
}


method is_valid_email(Str $email) {
    return 0 if !Email::Valid->address($email);
    return 0 if $email =~ /[<>]/;  # git does not like angle brackets
    return 1;
}
