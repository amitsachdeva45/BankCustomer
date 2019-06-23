-module(customer).
-export([customer/4]).
-import(money,[]).
customerRemaining(Leftover) ->
  if
    Leftover == 1->
      1;
    (Leftover < 50) and (Leftover >1) ->
      rand:uniform(Leftover);
    true ->
      rand:uniform(50)
  end.
customerBankList(Length, Bank_Temp_List) ->
  if
    Length > 0 ->
      lists:nth(rand:uniform(Length),Bank_Temp_List);
    true ->
      {"bye",0}
  end.
customer(Head,Tail,Bank_List,CounterOfCustomer) ->
  receive
    {Head,Tail,Main} ->
      timer:sleep(100),
      Unchanged=Tail,
      Actual_Amount=Tail,
      Customer_Name=Head,
      Random_Bank=lists:nth(rand:uniform(length(Bank_List)),Bank_List),
      {Temp_Head,Temp_Tail}=Random_Bank,
      RequiredAmount=rand:uniform(50),
      money:requestFunction(Head,RequiredAmount,Temp_Head),
      Temp_Head ! {self(),{RequiredAmount,Actual_Amount,Unchanged,Customer_Name,Bank_List,Main}},
      customer(Head,Tail,Bank_List,CounterOfCustomer);

    {Status,LeftOver,StaticData,CustomerName,Bank_Temp_List,Main} ->
      Length = length(Bank_Temp_List),
      Required_Amount = customerRemaining(LeftOver),
      {Header,Tailer} = customerBankList(Length, Bank_Temp_List),
      if
        (LeftOver > 0) and (Length >0) ->
          if
            Status==1 ->
                money:requestFunction(CustomerName,Required_Amount,Header),
                timer:sleep(10),
                Header ! {self(),{Required_Amount,LeftOver,StaticData,CustomerName,Bank_Temp_List,Main}},
                customer(Head,Tail,Bank_Temp_List,CounterOfCustomer);
            true ->
              money:requestFunction(CustomerName,Required_Amount,Header),
              timer:sleep(10),
              Header ! {self(),{Required_Amount,LeftOver,StaticData,CustomerName,Bank_Temp_List,Main}},
              customer(Head,Tail,Bank_Temp_List,CounterOfCustomer)
          end;
        true ->
          if
            LeftOver == 0 ->
              money:successFunction(CustomerName,StaticData);
            true ->
              money:failFunction(CustomerName,StaticData-LeftOver)
          end,
          Main ! {"Hello",1,Bank_List,2},
          exit(kill)
      end
  end.

