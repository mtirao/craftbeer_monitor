-module(craftbeer_monitor_sup).
-behaviour(supervisor).

-export([start_link/0]).
-export([init/1]).

start_link() ->
	supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([]) ->
	Child =#{id => temp_monitor,
			start => {temp_monitor, start_link, []}},
	Procs = [Child],
	{ok, {{one_for_one, 1, 5}, Procs}}.
