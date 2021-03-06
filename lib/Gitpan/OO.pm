package Gitpan::OO;

use Gitpan::perl5i;

require Moo;
use Import::Into;

sub import {
    my $class = shift;
    my $caller = caller;

    my $haz = func($name, %args) {
        $args{is} //= 'rw';

        if( defined $args{isa} and $args{isa}->isa("Type::Tiny") ) {
            $args{coerce} = $args{isa}->coercion;
        }
        elsif (exists($args{coerce}) and not $args{coerce}) {
            delete($args{coerce});
        }

        @_ = ($name, %args);
        goto "$caller"->can("has");
    };
    $haz->alias($caller.'::haz');

    Moo->import::into($caller, @_);
}
