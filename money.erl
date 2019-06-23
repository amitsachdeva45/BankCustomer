-module(money).
-export([start/0,masterThread/3,requestFunction/3,failFunction/2,successFunction/2,approvalBank/3,denialBank/3,finalBankAmount/2]).

start() ->
  {_,Customer}= file:consult("customers.txt"),
  io:format("** Customers and loan objectives **~n"),
  startCustomerBank(Customer),
  Counter = customerCounter(Customer,0),

  {_,Bank}= file:consult("banks.txt"),
  io:format("~n~n** Banks and financial resources **~n"),
  startCustomerBank(Bank),

  register(list_to_atom("master"),spawn(money,masterThread,[0,Counter,Bank])),
  lists:map(fun(ListBank) -> master ! {ListBank} end, Bank),
  lists:map(fun(ListCustomer) -> master ! {ListCustomer,Bank,Counter} end, Customer).


masterThread(Value,CustomerCounter,BankDataList) ->
  receive
    {ElementCustomer,Bank,Counter} ->
      {Head1,Tail1} = ElementCustomer,
      register(Head1,spawn(customer,customer,[Head1,Tail1,Bank,Counter])),
      Head1 ! {Head1,Tail1,self()},
      masterThread(Value,CustomerCounter,BankDataList);
    {ElementBank} ->
      {Head1,Tail1} = ElementBank,
      register(Head1,spawn(bank,bank,[Head1,Tail1])),
      masterThread(Value,CustomerCounter,BankDataList);
    {Message, Value1, Bank_Temp_List,Temp} ->
      Value2 = Value + Value1,
      TempData = CustomerCounter,
      if
        (Value2 == TempData)->
          printBankList(self(),BankDataList);
        true ->
          io:fwrite("")
      end,
      masterThread(Value2,CustomerCounter,BankDataList)
  end.


approvalBank(Bank_name,Loan_Amount,Customer_Name)->
  io:fwrite("~p approves a loan ~p dollars from ~p~n",[Bank_name,Loan_Amount,Customer_Name]).

denialBank(Bank_name,Loan_Amount,Customer_Name)->
  io:fwrite("~p denies a loan ~p dollars from ~p~n",[Bank_name,Loan_Amount,Customer_Name]).

successFunction(CustomerName,Data)->
  io:fwrite("     ~n   ~p has reached the objective of ~p dollar(s). Woo Hoo!~n~n",[CustomerName,Data]).

failFunction(CustomerName,Data)->
  io:fwrite("     ~n   ~p was only able to borrow ~p dollar(s).Boo Hoo!~n~n",[CustomerName,Data]).

requestFunction(CustomerName, RequiredAmount, BankName) ->
  io:fwrite("~p requests a loan of ~p dollar(s) from ~p ~n",[CustomerName,RequiredAmount,BankName]).

finalBankAmount(Bank_name,Amount)->
  io:fwrite("  ~p has ~p dollar(s) remaining~n",[Bank_name,Amount]).

printBankList(Sender,[]) ->
  timer:sleep(1);

printBankList(Sender, [Head|Tail]) ->
  {Head_Temp,Tail_Temp} = Head,
  Head_Temp ! {"print",Sender,1},
  unregister(Head_Temp),
  printBankList(Sender,Tail).


customerCounter([],Counter)->
  Counter;

customerCounter([Head|Tail],Counter)->
  Temp_Counter = Counter + 1,
  customerCounter(Tail,Temp_Counter).

startCustomerBank([]) ->
  timer:sleep(1);

startCustomerBank([Head|Tail]) ->
  {Head1,Tail1} = Head,
  io:format(" ~p: ~p~n",[Head1,Tail1]),
  timer:sleep(500),
  startCustomerBank(Tail).

