
-module(test_map).
-compile(export_all).

elem([],NewList)->L=lists:sublist(lists:reverse(lists:keysort(2,NewList)),10),
{ok, P} = riakc_pb_socket:start_link("127.0.0.1",10027),
Y=tuple_to_list(erlang:date()),
Z=term_to_binary(Y),
Period = riakc_obj:new(<<"total2">>, Z, term_to_binary(L)),
riakc_pb_socket:put(P, Period);

elem([H|T],NewList)->

T2=NewList++get_elem(H,T,[]),
NewTail=delete_elem(H,T),
elem(NewTail,T2).

get_data(Z)-> {ok, P} = riakc_pb_socket:start_link("54.68.217.138",8087),
{ok,O}=riakc_pb_socket:get(P,<<"total2">>
,Z),
W=riakc_obj:get_value(O),
Obj=binary_to_term(W),
Obj.

get_data_daily(Y,M,D)->
W=tuple_to_list({Y,M,D}),
Z=term_to_binary(W), 
Data=get_data(Z),

GameList=lists:map(fun({X,A})-> {database:get_gamename(X),A} end, Data),

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

get_keys_list()->
{ok, P} = riakc_pb_socket:start("127.0.0.1",10027),
{ok,Lis}=riakc_pb_socket:list_keys(P, <<"hoursplayed">>),
%Lis.
generate_list(Lis).

generate_list([])->[];
generate_list([H|T])->
[{<<"hoursplayed">>,H}|generate_list(T)].


get_sum_riak()->
{ok, Pid} = riakc_pb_socket:start_link("127.0.0.1",10027),
{ok,List}=riakc_pb_socket:list_keys(Pid, <<"hoursplayed">>),
L=get_obj(List),
elem(L,[]).
 

get_obj([])->[];
get_obj([H|T])->
{ok, Pid} = riakc_pb_socket:start_link("127.0.0.1",10027),
{ok, Fetched1} = riakc_pb_socket:get(Pid, <<"hoursplayed">>, H),
lists:append(binary_to_term(riakc_obj:get_value(Fetched1)),get_obj(T)).


get_elem({A,B},[],L)->[{A,get_sum([{A,B}]++L,0)}];
get_elem({A,B},[H|T],NewList)->
case H of
	{A,C}->get_elem({A,B},T,NewList ++ [{A,C}]);
	_->get_elem({A,B},T,NewList)
end.

get_sum([],Acc)->Acc;
get_sum([H|T],Acc)->
case H of
	{_,B}->get_sum(T,B+Acc)
end.
delete_elem(_,[])->[];
delete_elem({A,B},[H|T])->
case H of
	{A,_}->delete_elem({A,B},T);
	_->[H|delete_elem({A,B},T)]

end.



