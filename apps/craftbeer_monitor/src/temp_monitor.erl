-module(temp_monitor).

-export([start_link/0]).


start_link() ->
    application:ensure_all_started(gun),
	{ok, ConnPid} = gun:open("192.168.0.250", 80),
    {ok, EventPid} = gun:open("localhost", 8080),
    server(ConnPid, EventPid).


server(ConnPid, EventPid) ->
    StreamRef = gun:get(ConnPid, "/api/temperature/?sensor=28-00000bfc2432"),
    case gun:await(ConnPid, StreamRef) of
        {response, fin, _, _} ->
                no_data;
        {response, nofin, _, _} ->
            {ok, Body} = gun:await_body(ConnPid, StreamRef),
            Temperature = jiffy_v:decode(Body, [return_maps]),
            event(EventPid, Temperature),
            io:format("~s~n", [Body]),
            no_data;
        {error, _} ->
            no_data
    end,
    timer:sleep(600000),
    server(ConnPid, EventPid).

event(EventPid, Temperature) ->
    DateTime = erlang:localtime(),
    DateString = qdate:to_string(<<"Y-m-d h:ia">>, DateTime),
    Value = lists:flatten(io_lib:format("~p", [maps:get(<<"value">>,Temperature)])),
    Body = jiffy:encode(#{app_id => <<"craftbeer">>, event_id => <<"event_id">>, value => list_to_binary(Value) , client_id=><<"craftbeer_monitor">>, datetime => DateString}),
    gun:post(EventPid, "/api/v1/event", [
        {<<"content-type">>, "application/json"}
    ], Body),
    io:format("~s~n", [Body]).