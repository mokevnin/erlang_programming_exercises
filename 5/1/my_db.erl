-module(my_db).

%% API
-export([start/0, stop/0, write/2, read/1, delete/1]).

-export([loop/1]).

start() ->
  Pid = spawn_link(?MODULE, loop, [[]]),
  register(my_db_loop, Pid),
  ok.

stop() -> 
  my_db_loop ! stop,
  ok.

write(Key, Value) ->
  my_db_loop ! {write, Key, Value},
  ok.

delete(Key) ->
  my_db_loop ! {delete, Key},
  ok.

read(Key) ->
  my_db_loop ! {read, self(), Key},
  receive
    Reply -> Reply
  end.

loop(Db) -> 
  receive
    stop -> 
      true;
    {write, Key, Value} ->
      Db2 = write(Key, Value, Db),
      loop(Db2);
    {read, Pid,  Key} ->
      Reply = read(Key, Db),
      Pid ! Reply,
      loop(Db);
    {delete, Key} ->
      Db2 = delete(Key, Db),
      loop(Db2)
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
  {ok, Value};
read(Key, [_ | Tail]) -> 
  read(Key, Tail).

%match(Value, Db) ->
  %[Key || {Key, Current} <- Db, Current == Value].
