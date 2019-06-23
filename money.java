import java.io.*;
import java.util.*;

public class money {

    static ArrayList<bank> banks = new ArrayList<bank>();
    static ArrayList<customer> cus = new ArrayList<customer>();
    static ArrayList<bank> mybankObjects = new ArrayList<bank>();
    public static ArrayList<bank> getBankList()
    {
        return banks;
    }
    public static void ListOfBank(bank bankObject)
    {
        int check = 0;
        for(int i=0;i<mybankObjects.size();i++)
        {
            if(bankObject.getName().equals(mybankObjects.get(i).getName()))
            {
                check = 1;
            }
        }
        if(check == 0) {
            mybankObjects.add(bankObject);
        }
    }
    public void startReadingFile()
    {
        try {
            File file = new File("banks.txt");
            Scanner scanner = new Scanner(file);
            System.out.println("** Banks and financial resources **");
            while (scanner.hasNext()) {
                String data = scanner.next();
                String array[] = data.substring(1,data.length()-2).split("[,]");
                bank newBank = new bank(array[0],Integer.parseInt(array[1]));
                this.banks.add(newBank);
                Thread newThread = new Thread(newBank);
                newThread.start();
                newThread.sleep(1000);

            }
            scanner.close();

            file = new File("customers.txt");
            scanner = new Scanner(file);
            System.out.println("\n\n** Customers and loan objectives **");
            while (scanner.hasNext()) {
                String data = scanner.next();
                String array[] = data.substring(1,data.length()-2).split("[,]");
                customer newCustomer = new customer(array[0],Integer.parseInt(array[1]));
                this.cus.add(newCustomer);
                Thread.sleep(1000);
            }
            System.out.println("\n\n");
            for (customer j : this.cus) {
                Thread newThread = new Thread(j);
                newThread.start();

            }
            scanner.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    public static void rejectLoan(String bankValue, int amount, String customerName)
    {
        System.out.println(bankValue + " denies a loan of " + amount + " from " + customerName);
    }
    public static void approvedLoan(String bankValue, int amount, String customerName)
    {
        System.out.println(bankValue + " approves a loan of " + amount + " dollars from " + customerName);
    }
    public static void reachedObjective(String customerName, int requiredAmount){
        System.out.println(customerName + " has reached the objective of " + requiredAmount + " dollar(s). Woo Hoo!");
    }
    public static void failedObjective(String customerName, int requiredAmount){
        System.out.println(customerName + " was only able to borrow " + requiredAmount + " dollar(s) Boo Hoo!");
    }
    public static void requestLoan(String customerName, int loanAmount, String Name)
    {
        System.out.println(customerName + " requests a loan of " + loanAmount + " dollars from " + Name);
    }
    public void startRunning()
    {
        while(true)
        {
            int counter = 0;
            for(int i=0;i<this.cus.size();i++)
            {
                if(this.cus.get(i).getFlag() == 1)
                {
                    counter++;
                }
            }
            if(counter == this.cus.size())
            {
                for (bank temp : this.banks) {
                    System.out.println(temp.getName() + " has " + temp.getTotalAmount() + " dollar(s) remaining.");
                }
                for (bank temp : this.mybankObjects) {
                    System.out.println(temp.getName() + " has " + temp.getTotalAmount() + " dollar(s) remaining.");
                }
                break;
            }
        }
    }
    public static void main(String args[])
    {
        money mo = new money();
        mo.startReadingFile();
        mo.startRunning();

    }
}
