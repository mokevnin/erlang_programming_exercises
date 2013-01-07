-module(db).

%% api
-export([new/0, destroy/1, write/3, delete/2, read/2, match/2]).

new() -> [].

destroy(_Db) -> ok.

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
