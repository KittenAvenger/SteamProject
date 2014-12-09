-module(gamename).

-export([retrieve/0, start/0, findgames/0]).




start() ->

ssl:start(),
application:start(inets),
findgames().

retrieve () ->

{ok,{_,_,JSON}}=httpc:request(get, {"http://api.steampowered.com/ISteamUser/GetFriendList/v0001/?key=80C9F831FD044A94E0A0FE0792624CD4&steamid=76561197960435530&relationship=friend", []},[], []),

Struct=mochijson:decode(JSON),

{struct, JsonData} = Struct,
{struct, Job} = proplists:get_value("game",JsonData),
{array, Data} = proplists:get_value("gameName",Job),
[parse(N) || N <- Data].
%Playlist=[findgames(X) || X <- A],
%Games=[mochijson:decode(C) || C <- Playlist],


%io:format("Games: ~p.", [Games]).



parse(A)->
{struct, Data} = A,
C=proplists:get_value("appid", Data),
D=proplists:get_value("name", Data),
io:format("Games: ~p.", [Data]),
{C,D}.


findgames() ->
ssl:start(),
application:start(inets),

{ok,{_,_,JSON}}=httpc:request(get, {"http://api.steampowered.com/ISteamApps/GetAppList/v0001/", []},[], []),

Struct=mochijson:decode(JSON),

{struct, JsonData} = Struct,

{struct, List} = proplists:get_value("applist",JsonData),
{struct, Data} = proplists:get_value("apps",List),
{array, GameNames} = proplists:get_value("app",Data),

A=[parse(N) || N <- GameNames],

[database:store_gameName(C) || C <- A].


