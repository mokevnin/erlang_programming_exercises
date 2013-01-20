-module(echo_tests).
-include_lib("eunit/include/eunit.hrl").

start_test() ->
  {ok, _} = echo:start(),
  ok = echo:stop().

