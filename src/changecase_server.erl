-module(changecase_server).
-export([start/0, loop/0]).

loop() ->
  receive
    {Client, {Str, uppercase}} ->
      Client ! {self(), string:to_upper(Str), upper};

    {Client, {Str, lowercase}} ->
      Client ! {self(), string:to_lower(Str), lower}
  end.

start() ->
  spawn(changecase_server, loop, []).