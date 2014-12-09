-module(map).
-compile(export_all).

put()->
{ok, Client} = riakc_pb_socket:start("127.0.0.1",10027),
Mine = riakc_obj:new(<<"test">>, <<"tet">>,
                        term_to_binary(["111", "222"])),
 Yours = riakc_obj:new(<<"test">>, <<"tett">>,
                         term_to_binary(["333", "111"])),
 riakc_pb_socket:put(Client, Yours, [{w, 1}]),
 riakc_pb_socket:put(Client, Mine, [{w, 1}]).

%%%lists:sublist(lists:reverse(lists:keysort(2,map:m())),3).

m()->
{ok, Client} = riakc_pb_socket:start("127.0.0.1",10027),
Count = fun(G, undefined, none) ->
             [dict:from_list([{I, 1}
              || I <- binary_to_term(riak_object:get_value(G))])]
           end,
 Merge = fun(Gcounts, none) ->
             [lists:foldl(fun(G, Acc) ->
                            dict:merge(fun(_, X, Y) -> X+Y end,
                                       G, Acc)
                          end,
                          dict:new(),
                          Gcounts)]
           end,
 {ok, [{1, [R]}]} = riakc_pb_socket:mapred(
                         Client,
                         [{<<"test">>, <<"tet">>},
                          {<<"test">>, <<"tett">>}],
                         [{map, {qfun, Count}, none, false},
                          {reduce, {qfun, Merge}, none, true}]),
 L = dict:to_list(R),
L.

ma()->{ok, P} = riakc_pb_socket:start_link("127.0.0.1",10027),




Count = fun(G, undefined, none) ->
             [dict:from_list([{I, 1}
              || I <- binary_to_term(riak_object:get_value(G))])]
           end,
 Merge = fun(Gcounts, none) ->
             [lists:foldl(fun(G, Acc) ->
                            dict:merge(fun(_, X, Y) -> X+Y end,
                                       G, Acc)
                          end,
                          dict:new(),
                          Gcounts)]
           end, 
List=get_keys_list(),

{ok, [{1, [R]}]} = riakc_pb_socket:mapred(
                         P,
                         List,
                         [{map, {qfun, Count}, none, false},
                          {reduce, {qfun, Merge}, none, true}]),
 
 L = dict:to_list(R),
%%%% top 10 values
X=lists:sublist(lists:reverse(lists:keysort(2,L)),10),


%% put in data base daily
Y=tuple_to_list(erlang:date()),
%Converted= io_lib:format("~p",[Y]),
%B=lists:flatten(Converted),
Z=term_to_binary(Y),
Period = riakc_obj:new(<<"total">>, Z, term_to_binary(X)),
riakc_pb_socket:put(P, Period).


get_data(Z)-> {ok, P} = riakc_pb_socket:start_link("54.68.217.138",8087),
{ok,O}=riakc_pb_socket:get(P,<<"total">>
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
%io:format("Values: ~p.", [BC1]),
{ok, P} = riakc_pb_socket:start_link("54.68.217.138",8087),
%B="12",
BinaryID=list_to_binary(BC1),
DataBin=list_to_binary(BC),
Object = riakc_obj:new(<<"mapgames1">>, BinaryID, DataBin),
riakc_pb_socket:put(P, Object).
%[database:get_gamename(A)|| A <-GameList].

test(Z)->
A=list_to_binary(Z),
{ok, P} = riakc_pb_socket:start_link("54.68.217.138",8087),
{ok,O}=riakc_pb_socket:get(P,<<"mapgames1">>,A),
W=riakc_obj:get_value(O),
Obj=binary_to_list(W),
Obj.


get_keys_list()->
{ok, P} = riakc_pb_socket:start("54.68.217.138",8087),
{ok,Lis}=riakc_pb_socket:list_keys(P, <<"mapgames1">>),
%Lis.
generate_list(Lis).

generate_list([])->[];
generate_list([H|T])->
[{<<"ownedgames">>,binary_to_term(H)}|generate_list(T)].

delete_bucket([])->done;
delete_bucket([H|T])->
{ok, P} = riakc_pb_socket:start("127.0.0.1",10027),
riakc_pb_socket:delete(P, <<"ownedgames">>, H),
delete_bucket(T).


