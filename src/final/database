-module(database).

-export([connect/0,  store_friends/2, get_friendslist/1,  store_appID/2, store_app/1, get_ownedgames/1, store_gameName/1, get_gamename/1, store_hours/2, get_hours/1]).



%54.68.217.138


connect()->

case whereis(server) of
undefined ->

{ok, Pid} = riakc_pb_socket:start_link("54.68.217.138",8087), 
register(server, Pid),
{ok,Pid};
Pid -> {ok, Pid} 
end.



 


store_friends(ID, B) ->



BinaryID=term_to_binary(ID),

Object = riakc_obj:new(<<"friendslist">>, BinaryID, B),
riakc_pb_socket:put(server, Object).
%io:format("Values: ~p.", [ID]).



store_app(FriendID) ->


riakc_pb_socket:ping(server),
FriendList=get_friendslist(FriendID),
[store_appID(N, appID:findApp(N)) || N <- FriendList].


store_appID(ID, B) ->

BinaryID=term_to_binary(ID),
Object = riakc_obj:new(<<"ownedgames">>, BinaryID, B),
riakc_pb_socket:put(server, Object).
%io:format("Values: ~p.", [ID]).



store_gameName({ID, Game}) ->

BinaryID=term_to_binary(ID),
BinaryGame=term_to_binary(Game),
Object = riakc_obj:new(<<"gamenames">>, BinaryID, BinaryGame),
riakc_pb_socket:put(server, Object).
%io:format("Values: ~p.", [Game]).

store_hours (SteamID, Games) ->

BinaryID=term_to_binary(SteamID),
Object = riakc_obj:new(<<"hoursplayed">>, BinaryID, Games),
riakc_pb_socket:put(server, Object),
io:format("~p.", [SteamID]).









get_friendslist(ID)->

BinaryID=term_to_binary(ID),
{ok, Data} = riakc_pb_socket:get(server, <<"friendslist">>, BinaryID),
FriendList=riakc_obj:get_value(Data),
Vasya=binary_to_term(FriendList),
Vasya.


get_ownedgames(ID)->

BinaryID=term_to_binary(ID),
{ok, Data} = riakc_pb_socket:get(server, <<"ownedgames">>, BinaryID),
OwnedGamesList=riakc_obj:get_value(Data),
binary_to_term(OwnedGamesList).

%To get ID type get_gamename(20) and not get_gamename("20") since it stores it directly from the tuple

get_gamename(ID)->

database:connect(),

BinaryID=term_to_binary(ID),

{ok, Data} = riakc_pb_socket:get(server, <<"gamenames">>, BinaryID),
GameName=riakc_obj:get_value(Data),
binary_to_term(GameName).

get_hours(ID) ->

BinaryID=term_to_binary(ID),
{ok, Data} = riakc_pb_socket:get(server, <<"bacon">>, BinaryID),
HoursPlayedList=riakc_obj:get_value(Data),
binary_to_term(HoursPlayedList).



