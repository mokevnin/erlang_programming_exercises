-module(test).

-export([print/1, reverse_create/1, create/1, sum/1, sum/2]).

%% sum/1
sum(N) when N >= 0 -> isum(N, 0).

isum(0, Sum) -> Sum;
isum(N, Sum) -> isum(N - 1, Sum + N).

%% sum/2
sum(N, M) when N =< M -> isum(N, M, 0).

isum(N, N, Sum) -> Sum + N;
isum(N, M, Sum) -> isum(N, M - 1, Sum + M).

%% create/1
create(Num) -> create(Num, []).

create(0, List) -> List;
create(Num, List) -> create(Num - 1, [Num | List]).

%% reverse_create/1
reverse_create(Num) -> lists:reverse(create(Num)).

%% print/1
print(0) -> ok;
print(N) ->
  if 
    N > 0, N rem 2 == 0 -> io:format("Number: ~p~n", [N]);
    true -> ok
  end,
  print(N - 1).

