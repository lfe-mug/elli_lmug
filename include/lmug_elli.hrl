-include_lib("elli/include/elli.hrl").

%% TODO: Consider possibly returning the atom, 'ignore'.
-type elli_response() :: {response_code(), [tuple()], binary()}
                       | {ok, [tuple()], binary()}.

-spec 'lmug-elli':handle(Req, Args) -> ignore | Res when
    Req  :: #req{},
    Args :: callback_args(),
    Res  :: elli_response().

-spec 'lmug-elli':handle_event(Event, Args, Config) -> ok when
    Event  :: elli_event(),
    Args   :: [term()],
    Config :: [tuple()].

-spec 'lmug-elli':'elli->request'(Req, Args) -> Request when
    Req     :: #req{},
    Args    :: callback_args(),
    Request :: #request{}.

-spec 'lmug-elli':'response->elli'(Response, Args) -> Res when
    Response :: #response{},
    Args     :: callback_args(),
    Res      :: elli_response().
