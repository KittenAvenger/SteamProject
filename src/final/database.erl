-module(database).

-compile(export_all).



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
{ok, Data} = riakc_pb_socket:get(server, <<"hoursplayed">>, BinaryID),
HoursPlayedList=riakc_obj:get_value(Data),
binary_to_term(HoursPlayedList).


get_mapgames(Z)-> {ok, P} = riakc_pb_socket:start_link("54.68.217.138",8087),
{ok,O}=riakc_pb_socket:get(P,<<"total">>
,Z),
W=riakc_obj:get_value(O),
Obj=binary_to_term(W),
Obj.


store_mapgames(Date)->
W=tuple_to_list(Date),
Z=term_to_binary(W),
Data=get_mapgames(Z),
GameList=lists:map(fun({X,A})-> {database:get_gamename(X),A} end, Data),
Converted= io_lib:format("~p",[GameList]),
BC=lists:flatten(Converted),
Converted1= io_lib:format("~p",[W]),
BC1=lists:flatten(Converted1),
{ok, P} = riakc_pb_socket:start_link("54.68.217.138",8087),
BinaryID=list_to_binary(BC1),
DataBin=list_to_binary(BC),
Object = riakc_obj:new(<<"mapgames1">>, BinaryID, DataBin),
riakc_pb_socket:put(P, Object).



get_maphours(Z)-> {ok, P} = riakc_pb_socket:start_link("54.68.217.138",8087),
{ok,O}=riakc_pb_socket:get(P,<<"total2">>
,Z),
W=riakc_obj:get_value(O),
Obj=binary_to_term(W),
Obj.


store_maphours(Date)->
W=tuple_to_list(Date),
Z=term_to_binary(W),
Data=get_maphours(Z),
GameList=lists:map(fun({X,A})-> {get_gamename(X),A} end, Data),
Converted= io_lib:format("~p",[GameList]),
BC=lists:flatten(Converted),
Converted1= io_lib:format("~p",[W]),
BC1=lists:flatten(Converted1),
{ok, P} = riakc_pb_socket:start_link("54.68.217.138",8087),
BinaryID=list_to_binary(BC1),
DataBin=list_to_binary(BC),
Object = riakc_obj:new(<<"maphours">>, BinaryID, DataBin),
riakc_pb_socket:put(P, Object).



test(Z)->
A=list_to_binary(Z),
{ok, P} = riakc_pb_socket:start_link("54.68.217.138",8087),
{ok,O}=riakc_pb_socket:get(P,<<"maphours">>,A),
W=riakc_obj:get_value(O),
Obj=binary_to_list(W),
Obj.


store_map () ->
store_mapgames(erlang:date()),
store_maphours(erlang:date()).
