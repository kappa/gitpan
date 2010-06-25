use MooseX::Declare;

class Gitpan::Github extends Net::GitHub::V2 with Gitpan::Github::ResponseReader {
    use perl5i::2;
    use Path::Class;

    # Net::GitHub requires a repo to initialize {which is kind of silly
    has "+repo" =>
      default   => "bogus";

    has "+owner" =>
      default   => 'gitpan';

    has "+login" =>
      default   => 'gitpan';

    has "+network" =>
      default   => method {
          return Gitpan::GitHub::Network->new( $self->args_to_pass );
      };

    method do_with_backoff(Int :$times=6, CodeRef :$code!, CodeRef :$check) {
        $check //= \&default_success_check;

        for my $time (1..$times) {
            my $return = $code->();
            return $return if $check->($self, $return);

            sleep 2**$time;
        }

        return;
    }

    method default_success_check($response) {
        return 0 unless $response;
        return 0 if $self->is_too_many_requests($response);
        return 1;
    }

    method exists_on_github(Str :$repo, Str :$owner) {
        my $info = $self->do_with_backoff( code => sub {
            return $self->repos->show( $owner, $repo );
        });

        return $self->get_response_errors($info)->size ? 0 : 1;
    }
}