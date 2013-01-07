-module(db_tests).
-include_lib("eunit/include/eunit.hrl").

new_test() ->
  ?assertEqual([], db:new()).

destroy_test() ->
  Db = db:new(),
  ?assertEqual(ok, db:destroy(Db)).

write_test() ->
  Db = db:new(),
  Db2 = db:write(key1, el1, Db),
  ?assertEqual([{key1, el1}], Db2),

  Db3 = db:write(key2, el2, Db2),
  ?assertEqual([{key2, el2}, {key1, el1}], Db3),

  Db4 = db:write(key1, el3, Db3),
  ?assertEqual([{key1, el3}, {key2, el2}], Db4).

read_test() ->
  Db = db:new(),
  Db2 = db:write(key1, el1, Db),
  Db3 = db:write(key2, el2, Db2),

  ?assertEqual(el1, db:read(key1, Db3)),
  ?assertEqual(el2, db:read(key2, Db3)),
  ?assertEqual({error, instance}, db:read(unknown_key, Db3)).

delete_test() ->
  Db = db:new(),
  Db2 = db:write(key1, el1, Db),
  Db3 = db:write(key2, el2, Db2),
  
  Db4 = db:delete(key1, Db3),
  ?assertEqual([{key2, el2}], Db4).

match_test() ->
  Db = db:new(),
  Db2 = db:write(key1, el1, Db),
  Db3 = db:write(key2, el2, Db2),
  Db4 = db:write(key3, el2, Db3),

  ?assertEqual([key3, key2], db:match(el2, Db4)).
