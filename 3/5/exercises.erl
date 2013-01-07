-module(exercises).

-export([flatten/1, concatenate/1, filter/2, reverse/1]).

filter(List, Max) ->
  [X || X <- List, X =< Max].

reverse(List) ->
  reverse(List, []).

reverse([Head | Tail], Result) ->
  reverse(Tail, [Head | Result]);
reverse([], Result) ->
  Result.

concatenate(List) ->
  concatenate(List, []).

concatenate([Head | Tail], Result) ->
  concatenate(Tail, Result ++ Head);
concatenate([], Result) ->
  Result.

flatten(List) ->
  flatten(List, []).

flatten([], Result) ->
  Result;
flatten([Head | Tail], Result) ->
  flatten(Head, Result) ++ flatten(Tail, Result);
flatten(Value, Result) ->
  [Value | Result].
