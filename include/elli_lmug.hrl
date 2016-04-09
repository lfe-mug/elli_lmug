-include_lib("elli/include/elli.hrl").

%% TODO: Consider possibly returning the atom, 'ignore'.
-type elli_response() :: {response_code(), [tuple()], binary()}
                       | {ok, [tuple()], binary()}.

-spec elli_lmug:handle(Req, Args) -> Res when
    Req  :: #req{},
    Args :: callback_args(),
    Res  :: elli_response().

-spec elli_lmug:handle_event(Event, Args, Config) -> ok when
    Event  :: elli_event(),
    Args   :: [term()],
    Config :: [tuple()].

-spec elli_lmug:'elli->request'(Req, Args) -> Request when
    Req     :: #req{},
    Args    :: callback_args(),
    Request :: #request{}.

-spec elli_lmug:'response->elli'(Response, Args) -> Res when
    Response :: #response{},
    Args     :: callback_args(),
    Res      :: elli_response().
