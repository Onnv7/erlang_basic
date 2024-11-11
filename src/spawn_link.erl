-module(spawn_link).
-author("Admin").

-export([start/0, child/0]).

start() ->
  % Bật trap exit cho tiến trình hiện tại
  process_flag(trap_exit, true),
  ChildPid = spawn_link(spawn_link, child, []),
  io:fwrite("Child ~w", [ChildPid]),
  receive
    {'EXIT', ChildPid, Reason} ->
      io:format("Received exit signal from child: ~p~n", [Reason])
  end.

child() ->
  gen_server:call(),
  io:format("Child process started ~w~n ", [self()]),
  exit(some_reason).  % Gây crash cho tiến trình

