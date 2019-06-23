-module(bank).
-import(money,[]).
-export([bank/2]).
bank(Bank_name, Amount)->
  receive
    {Sender,{Loan_Amount,Amount_Pending,Customer_Total_Amount,Customer_Name,Bank_List,Main}} ->
      if
        (Amount-Loan_Amount >= 0) ->
          money:approvalBank(Bank_name,Loan_Amount,Customer_Name),
          Sender ! {1,(Amount_Pending-Loan_Amount),Customer_Total_Amount,Customer_Name,Bank_List,Main},
          bank(Bank_name,Amount-Loan_Amount);
        true ->
          money:denialBank(Bank_name,Loan_Amount,Customer_Name),
          Sender ! {0,Amount_Pending,Customer_Total_Amount,Customer_Name,lists:keydelete(Bank_name,1,Bank_List),Main},
          bank(Bank_name,Amount)
      end;
    {Message, Sender, Value} ->
      money:finalBankAmount(Bank_name,Amount),
      bank(Bank_name,Amount)
  end.
