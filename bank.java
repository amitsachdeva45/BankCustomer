import java.util.*;
public class bank implements Runnable {
    String bankValue;
    int totalAmount;

    bank(String name, int value) {
        this.bankValue = name;
        this.totalAmount = value;
    }
    public void run()
    {
        try {
            System.out.println(this.bankValue + ": " + this.totalAmount);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    synchronized public int removeApprovedAmount(int amount, String customerName) {

        if ((this.totalAmount - amount) >= 0) {
            money.approvedLoan(this.bankValue,amount,customerName);
            this.totalAmount = this.totalAmount - amount;
            return 1;
        } else {
            money.rejectLoan(this.bankValue,amount,customerName);
            return 0;
        }

    }
    public String getName() {
        return this.bankValue;
    }

    public void setName(String name) {
        this.bankValue = name;
    }

    public int getTotalAmount() {
        return this.totalAmount;
    }

    public void setTotalAmount(int amount) {
        this.totalAmount = amount;
    }


}