-module(phone).

%% API
-export([start/0, stop/1, off_hook/1, on_hook/1, call_number/2]).

-export([idle/0]).

start() ->
  Pid = spawn_link(?MODULE, idle, []),
  {ok, Pid}.

stop(Pid) ->
  Pid ! stop,
  ok.
  
on_hook(Pid) ->
  Pid ! {on_hook, self()},
  receive
    Reply -> Reply
  end.

off_hook(Pid) ->
  Pid ! {off_hook, self()},
  receive
    Reply -> Reply
  end.

call_number(Pid, ClientPid) ->
  Pid ! {call_number, self(), ClientPid},
  receive
    Reply -> Reply
  end.

idle() ->
  io:format("State idle ~w ~n", [self()]),
  receive
    stop ->
      ok;
    {off_hook, Pid} ->
      Pid ! {ok, deal},
      deal();
    {connect, ClientPid} ->
      ring(ClientPid);
    {_, Pid} -> 
      Pid ! {error, "can not"},
      idle()
  end.

deal() ->
  io:format("State deal ~w ~n", [self()]),
  receive
    stop ->
      ok;
    {on_hook, Pid} ->
      Pid ! {ok, idle},
      idle();
    {call_number, Pid, ClientPid} ->
      ClientPid ! {connect, self()},
      Pid ! {ok, connecting},
      connecting(ClientPid);
    {_, Pid} -> 
      Pid ! {error, "can not"},
      deal() 
  end.

ring(ClientPid) ->
  io:format("State ring ~w ~n", [self()]),
  receive
    stop ->
      ok;
    {off_hook, Pid} ->
      Pid ! {ok, connected},
      ClientPid ! ok, 
      connected(ClientPid);
    {_, Pid} -> 
      Pid ! {error, "can not"},
      ring(ClientPid)
  after 
    5000 -> 
      ClientPid ! {timeout, "timeout error"},
      idle() 
  end.

connecting(ClientPid) -> 
  io:format("State connecting ~w ~n", [self()]),
  receive
    stop ->
      ok;
    {error, _} ->
      busy();
    ok -> 
      connected(ClientPid); 
    {on_hook, Pid} ->
      Pid ! {ok, idle},
      idle();
    {timeout, _} ->
      busy();
    {_, Pid} ->
      Pid ! {error, "can not"},
      connecting(ClientPid)
   end.

connected(ClientPid) ->
  io:format("State connected ~w ~n", [self()]),
  receive
    stop ->
      ok;
    {on_hook, Pid} ->
      Pid ! {ok, idle},
      idle();
    {send_message, Message} ->
      ClientPid ! {message, Message},
      connected(ClientPid);
    {_, Pid} ->
      Pid ! {error, "can not in connected"},
      connected(ClientPid)
   end.
 
busy() ->
  io:format("State busy ~w ~n", [self()]),
  receive
    stop ->
      ok;
    {on_hook, Pid} ->
      Pid ! {ok, idle},
      idle();
    {_, Pid} ->
      Pid ! {error, "can not"},
      busy()
   end.
   
