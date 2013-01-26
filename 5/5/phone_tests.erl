-module(phone_tests).
-include_lib("eunit/include/eunit.hrl").

off_hook_test() ->
  {ok, Pid} = phone:start(),

  {Status, _} = phone:on_hook(Pid),
  ?assertEqual(error, Status),

  ?assertEqual({ok, deal}, phone:off_hook(Pid)),

  {Status, _} = phone:off_hook(Pid),
  ?assertEqual(error, Status),
  
  ?assertEqual({ok, idle}, phone:on_hook(Pid)),

  ?assertEqual(ok, phone:stop(Pid)),

  timer:sleep(1),
  ?assertEqual(undefined, process_info(Pid)).

call_number_test() ->
  {ok, P1} = phone:start(),
  {ok, P2} = phone:start(),

  phone:off_hook(P1),
  ?assertEqual({ok, connecting}, phone:call_number(P1, P2)),
  timer:sleep(1),
  ?assertEqual({ok, connected}, phone:off_hook(P2)).

  
