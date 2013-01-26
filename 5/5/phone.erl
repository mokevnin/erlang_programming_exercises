-module(phone).

%% API
-export([start/0, stop/1, off_hook/1, on_hook/1]).

-export([idle/0]).

start() ->
  Pid = spawn_link(?MODULE, idle, []),
  {ok, Pid}.

stop(Pid) ->
  Pid ! stop.
  
on_hook(Pid) ->
  Pid ! {on_hook, self()},
  receive
    {ok, State} -> {ok, State};
    {error, Reason} -> {error, Reason}
  end.

off_hook(Pid) ->
  Pid ! {off_hook, self()},
  receive
    {ok, State} -> {ok, State};
    {error, Reason} -> {error, Reason}
  end.

idle() ->
  receive
    {off_hook, Pid} ->
      Pid ! {ok, deal},
      deal();
    {_, Pid} -> 
      Pid ! {error, "can not"},
      idle()
  end.

deal() ->
  receive
    _ -> true
  end.
