-module(my_db).

-export([start/0, stop/0]).

-export([loop/0]).

start() ->
  Pid = spawn_link(?MODULE, loop, []),
  register(my_db, Pid),
  ok.

stop() -> 
  my_db ! stop.

loop() -> 
  receive
    stop -> 
      true
  end.
