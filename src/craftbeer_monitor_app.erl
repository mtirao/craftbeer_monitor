-module(craftbeer_monitor_app).
-behaviour(application).

-export([start/2]).
-export([stop/1]).

start(_Type, _Args) ->
	
	Dispatch = cowboy_router:compile([
		{'_', [ {"/api/v1/applications", monitor_handler, []} ] }
    ]),
    {ok, _} = cowboy:start_clear(my_http_listener,
        [{port, 8081}],
        #{env => #{dispatch => Dispatch}}
	),

	%spawn(fun() -> server(ConnPid, EventPid) end),

	craftbeer_monitor_sup:start_link().

stop(_State) ->
	ok.


	
	
