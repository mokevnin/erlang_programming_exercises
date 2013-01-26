-module(my_db_tests).
-include_lib("eunit/include/eunit.hrl").

start_stop_test_() ->
  {setup,
    fun start/0,
    fun stop/1,
    [fun write_read_success/0,
     fun read_error/0,
     fun delete_success/0]}.


start() ->
  my_db:start().

stop(_) -> 
  my_db:stop().

write_read_success() -> 
  ?assertEqual(ok, my_db:write(key, el)),
  ?assertEqual({ok, el}, my_db:read(key)).

read_error() ->
  ?assertEqual({error, instance}, my_db:read(undefined_key)).

delete_success() ->
  ?assertEqual(ok, my_db:write(key, el)),
  ?assertEqual(ok, my_db:delete(key)),
  ?assertEqual({error, instance}, my_db:read(key)).


