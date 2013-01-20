-module(ring).

-export([start/3, proc/1, master_proc/1]).

start(M, ProcessCount, Message) ->
  Pid = spawn_link(ring, master_proc, [ProcessCount]),
  Pid ! {M, Message},
  {ok, Pid}.

master_proc(ProcessCount) ->
  Pid = spawn_link(ring, proc, [self()]),
  master_proc(ProcessCount - 1, Pid).
master_proc(1, ChildPid) ->
  proc(ChildPid);
master_proc(ProcessCount, ChildPid) ->
  Pid = spawn_link(ring, proc, [ChildPid]),
  master_proc(ProcessCount - 1, Pid).

proc(ChildPid) ->
  receive
    stop -> 
      ChildPid ! stop,
      io:format("die ~w ~n", [self()]);
    {0, _} -> ChildPid ! stop,
      io:format("first die ~w ~n", [self()]);
    {M, Message} -> 
      io:format("~w ~w ~n", [Message, self()]),
      ChildPid ! {M - 1, Message},
      proc(ChildPid)
  end.
