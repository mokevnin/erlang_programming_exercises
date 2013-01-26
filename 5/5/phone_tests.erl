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

%call_number_test() ->
  %{ok, Pid} = phone:start(),

  %phone:off_hook_test
