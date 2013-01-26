-module(my_db).

-export([start/0, stop/0]).

-export([loop/1]).

start() ->
  Pid = spawn_link(?MODULE, loop, [[]]),
  register(my_db_loop, Pid),
  ok.

stop() -> 
  my_db_loop ! stop,
  ok.

loop(Db) -> 
  receive
    stop -> 
      true
  end.

write(Key, Value, Db) ->
  write(Key, Value, Db, []).

write(Key, Value, [], ResultDb) ->
  [{Key, Value} | ResultDb];
write(Key, Value, [{Key, _} | Tail], ResultDb) ->
  [{Key, Value} | ResultDb] ++ Tail;
write(Key, Value, [Head | Tail], ResultDb) ->
  write(Key, Value, Tail, [Head | ResultDb]).

delete(KeyForRemove, Db) ->
  [{Key, Value} || {Key, Value} <- Db, KeyForRemove /= Key].

read(_, []) ->
  {error, instance};
read(Key, [{Key, Value} | _]) ->
  Value;
read(Key, [_ | Tail]) -> 
  read(Key, Tail).

match(Value, Db) ->
  [Key || {Key, Current} <- Db, Current == Value].
