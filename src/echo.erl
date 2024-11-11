
-module(echo).
-export([db/0, client/0]).

read(Key) ->
  flush(),
  db ! {self(),{read, Key}},
  receive
    {read,R}        -> {ok, R};
    {error, Reason} -> {error, Reason}
  after 1000        -> {error, timeout}
  end.

flush() ->
  receive
    {read, _}  -> flush();
    {error, _} -> flush()
  after 0       -> ok
  end.

db() ->
  receive
    {Client, {read, Key}} ->
      case Key of
        "valid_key" ->
          Client ! {read, "some_data"};
        "error_key" ->
          Client ! {error, "not_found"};
        _ ->
          ok
      end
  end.
client() ->
  spawn(fun db/0),
  self() ! {error, "old_error"},
  self() ! {read, "old_data"},

  io:format("Starting read with flush~n"),
  Res1 = read("valid_key"),
  io:format("Result 1: ~p~n", [Res1]),

  io:format("Starting read without flush~n"),
  Res2 = read("error_key"),
  io:format("Result 2: ~p~n", [Res2]).
