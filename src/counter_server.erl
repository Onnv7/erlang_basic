-module(counter_server).
-behaviour(gen_server).

-export([start_link/0, increment/0, decrement/0, get_value/0, stop/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

start_link() ->
  gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init([]) ->
  {ok, 0}.

handle_call(get_value, _From, State) ->
  {reply, State, State}.

handle_cast(increment, State) ->
  {noreply, State + 1};

handle_cast(decrement, State) ->
  {noreply, State - 1}.

handle_info(_Info, State) ->
  {noreply, State}.

terminate(_Reason, _State) ->
  ok.

code_change(_OldVsn, State, _Extra) ->
  {ok, State}.

increment() ->
  gen_server:cast(?MODULE, increment).

decrement() ->
  gen_server:cast(?MODULE, decrement).

get_value() ->
  gen_server:call(?MODULE, get_value).

stop() ->
  gen_server:stop(?MODULE).
