-module(phone_tests).
-include_lib("eunit/include/eunit.hrl").

off_hook_test() ->
  {ok, Pid} = phone:start(),
  {Status, _} = phone:on_hook(Pid),
  ?assertEqual(error, Status),
  ?assertEqual({ok, deal}, phone:off_hook(Pid)).
