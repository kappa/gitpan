#!/usr/bin/env perl

use lib 't/lib';
use perl5i::2;
use Gitpan::Test;

use Gitpan::Dist;

my $DistName = 'Acme-LookOfDisapproval';

note "Import $DistName"; {
    my $dist = Gitpan::Dist->new(
        name        => $DistName
    );
    $dist->delete_repo;

    isnt $dist->versions_to_import->size, 0;
    note "Importing ".$dist->versions_to_import->join(", ");

    $dist->import_new;

    cmp_deeply $dist->versions_to_import, [];
}

done_testing;
