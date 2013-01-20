-module(echo).

-export([start/0, stop/0, print/1, loop/0]).

start() ->
  Pid = spawn_link(echo, loop, []),
  register(loop, Pid),
  {ok, Pid}.

stop() ->
  loop ! stop,
  io:format("server has been stoped~n"),
  ok.

print(Message) ->
  loop ! {request, self(), Message},
  receive
    {response, Message} ->
      io:format("~w~n", [Message])
  end.

loop() ->
  receive
    stop ->
      true;
    {request, Pid, Message} ->
      Pid ! {response, Message},
      loop()
  end.
