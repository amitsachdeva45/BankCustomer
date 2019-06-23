import java.util.*;

public class customer implements Runnable {
    String customerName;
    int amount;
    ArrayList<bank> bankList;
    int requiredAmount;
    int flag;
    customer(String cusName, int amo) {
        this.customerName = cusName;
        this.amount = amo;
        this.requiredAmount = amo;
        this.flag = 0;
        System.out.println(this.customerName+": "+this.amount);
    }
    public int getFlag()
    {
        return this.flag;
    }
    public void setFlag(int flg)
    {
        this.flag = flg;
    }

    public void run()
    {
        this.setFlag(0);
        try{
            this.bankList = money.banks;
            Thread.sleep(100);
            while(this.amount > 0 && this.bankList.size()> 0)
            {
                bank bankObj = this.bankList.get(new Random().nextInt(this.bankList.size()));
                int loanAmount = new Random().nextInt(50 - 1) + 1;
                if (amount<50) {
                    if(amount-1>0) {
                        loanAmount = new Random().nextInt(amount - 1) + 1;
                    }
                    else
                    {
                        loanAmount = amount;
                    }
                }
                money.requestLoan(this.customerName,loanAmount,bankObj.getName());
                int response = bankObj.removeApprovedAmount(loanAmount, this.customerName);
                if (response == 1) {
                    amount = amount - loanAmount;

                } else if (response == 0) {
                    if(bankObj.getTotalAmount()<=0){
                        this.bankList.remove(bankObj);
                        money.ListOfBank(bankObj);
                    }

                }
                Thread.sleep(4);
            }
            if (amount == 0) {
                money.reachedObjective(this.customerName,this.requiredAmount);
            } else {
                money.failedObjective(this.customerName,this.requiredAmount - amount);
            }
        }
        catch (Exception e)
        {
            System.out.println(e);
        }
        this.setFlag(1);
    }

}