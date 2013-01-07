-module(exercises_tests).
-include_lib("eunit/include/eunit.hrl").

filter_test() ->
  ?assertEqual([1,2,3], exercises:filter([1,2,3,4,5], 3)),
  ?assertEqual([], exercises:filter([3,4,5], 2)).

reverse_test() ->
  ?assertEqual([3,2,1], exercises:reverse([1,2,3])).

concatenate_test() ->
  L = [[1,2,3], [], [4,five]],
  ?assertEqual([1,2,3,4,five], exercises:concatenate(L)).

flatten_test() ->
  L = [[1,[2,[3],[]]], [[[4]]], [5,6]],
  
  ?assertEqual([1,2,3,4,5,6], exercises:flatten(L)).
