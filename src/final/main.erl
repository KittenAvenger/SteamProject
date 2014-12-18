-module(main).

-compile(export_all).


start()->
Game="afsfsdf it works",
io:format("Values: ~p.", [Game]).


ownedgames() ->

database:connect(),

List=["76561197960435530","76561197965032141","76561198088291210"],
%[friendslist:retrieve(ID) || ID <-List],

[database:store_app(ID)|| ID <-List].


gamenames() ->

database:connect(),
gamename:findgames().




hoursplayed() ->

database:connect(),
A=database:get_friendslist("76561197960435530"),
B=database:get_friendslist("76561197965032141"),
C=database:get_friendslist("76561198088291210"),
[hoursplayed:findHours(N) || N <- A],
[hoursplayed:findHours(N) || N <- B],
[hoursplayed:findHours(N) || N <- C].


friendslist()->

database:connect(),

List=["76561197960435530","76561197965032141","76561198088291210"],

[friendslist:retrieve(ID)|| ID <-List].

countfriends()->

A=database:get_friendslist("76561197960435530"),
B=database:get_friendslist("76561197965032141"),
C=database:get_friendslist("76561198088291210"),
FullList=lists:append([A, B, C]),
ListSize=len(FullList),
ListSize.


len([]) -> 0;
len([_|T]) -> 1 + len(T).












