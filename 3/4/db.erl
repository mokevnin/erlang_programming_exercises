-module(db).

%% api
-export([new/0, destroy/1, write/3, delete/2, read/2, match/2]).

new() -> [].

destroy(_Db) -> ok.

write(Key, Element, Db) ->
  write(Key, Element, Db, []).

write(Key, Element, [], ResultDb) ->
  [{Key, Element} | ResultDb];
write(Key, Element, [{Key, _} | Tail], ResultDb) ->
  [{Key, Element} | ResultDb] ++ Tail;
write(Key, Element, [Head | Tail], ResultDb) ->
  write(Key, Element, Tail, [Head | ResultDb]).

delete(Key, SourceDb) ->
  delete(Key, SourceDb, []).

delete(_, [], ResultDb) ->
  ResultDb;
delete(Key, [{Key, _} | Tail], ResultDb) ->
  ResultDb ++ Tail;
delete(Key, [Head | Tail], ResultDb) ->
  delete(Key, Tail, [Head | ResultDb]).

read(_, []) ->
  {error, instance};
read(Key, [{Key, Value} | _]) ->
  Value;
read(Key, [_ | Tail]) -> 
  read(Key, Tail).

match(Element, Db) ->
  match(Element, Db, []).

match(_, [], Keys) ->
  Keys;
match(Element, [{Key, Element} | Tail], Keys) ->
  match(Element, Tail, [Key | Keys]);
match(Element, [_ | Tail], Keys) ->
  match(Element, Tail, Keys).

