public with sharing class EmployeeController {
    public EmployeeController() {
    }
    @AuraEnabled
    public static  List<ExpenseCard__c> getCardList(Date cardDay,String login){
        try {
          List<Contact> con_List=[Select Id,Email,Password__c,Admin__c from Contact where Email =: login Limit 1];
     
          List<ExpenseCard__c> expCard_List=[Select Id,Description__c,Amount__c,CardDate__c from ExpenseCard__c where CardKeeper__r.Password__c =: con_List[0].Password__c Limit 1];
      
          return expCard_List;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    @AuraEnabled(cacheable=true)
    public static List<Table__c> getTables(){
        try {
           List <Table__c> tabList = [select Month__c,Income__c,Amount__c from Table__c];
            return tabList;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    @AuraEnabled(cacheable=true)
    public static List<MonthlyExpense__c> getMonthlyExpense(Integer year){
        try {
            Integer firstMonth = 1;
            Integer firstDay = 1;
            Integer lastMonth = 12;
            Integer lastDay = 31;

            Date previousYear = Date.newInstance(year, firstMonth, firstDay) - 1;
            Date nextYear = Date.newInstance(year, lastMonth, lastDay) + 1;
           List <MonthlyExpense__c> me = [select Balance__c,Keeper__r.Email,monthDate__c,Name from MonthlyExpense__c
            where monthDate__c > :previousYear AND monthDate__c < :nextYear ];
            return me;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    

    @AuraEnabled(cacheable=true)
    public static  List<Date> getDates(){
        try {
            List<Date> allDays = new list<Date>(); 
            Date dToday = system.today();

            date currentDay  = dToday.toStartOfMonth(); 
             
            date lastDay = dToday.toStartOfMonth().addMonths(1).addDays(-1);  
         

            while (currentDay < lastday) {
                allDays.add(currentDay);
                currentDay = currentDay.addDays(1);
            } 
            return allDays; 
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    private static String lookupMonthName(Date d) {
        Map<Integer,String> monthNames = new Map<Integer,String>{
            1 => 'January',
            2 => 'February',
            3 => 'March',
            4 => 'April',
            5 => 'May',
            6 => 'June',
            7 => 'July',
            8 => 'August',
            9 => 'September',
            10 => 'October',
            11 => 'November',
            12 => 'December'
        };
        try {
            return monthNames.get(d.month());
        } catch(NullPointerException e) {
            return NULL;
        }
    }
    @AuraEnabled
    public static List<Table__c> getListForTab(){
        List<string>months = new List<String>();
        try {
        Integer quantityOfMonthsInYear = 12;
        Integer randomYear = 2030;
        Integer randomDay = 1;
        for(Integer i = 1;i <= quantityOfMonthsInYear;i ++){
        date myDate = date.newInstance(randomYear, i, randomDay); 
        String monthName = lookupMonthName(myDate);
        months.add(monthName);
            }    
        List<Table__c>listForTable = new List<Table__c>();
        for(String mo : months){
        Table__c tab = new Table__c(Month__c = mo);  
        listForTable.add(tab);
        }
        upsert listForTable;
               return listForTable;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    @AuraEnabled
    public static List<Table__c>  populateMonths(Integer year){
        try {
            List <MonthlyExpense__c> monExList = getMonthlyExpense(year);
            
          
          
            List<Table__c>listForTable = new List<Table__c>();
           
            List<String>monthList = new List<String>{'January ','February ','March    ','April         ','May      ',
            'June     ','July     ','August   ','September','October  ','November ','December '};
            
               for(String month : monthList){
                Table__c tab = new Table__c(Month__c = month,Year__c = Decimal.valueOf(year));
                listForTable.add(tab);   
            }

            Map<Integer,String> monthNames = new Map<Integer,String>{
                1 => 'January  ',
                2 => 'February ',
                3 => 'March    ',
                4 => 'April         ',
                5 => 'May      ',
                6 => 'June     ',
                7 => 'July     ',
                8 => 'August   ',
                9 => 'September',
                10 => 'October ',
                11 => 'November',
                12 => 'December'
            };
          for(MonthlyExpense__c mon : monExList){
              for(Table__c tab : listForTable){
  
   if(tab.Month__c == monthNames.get(mon.MonthDate__c.month())){
    tab.Amount__c =  mon.Balance__c;
    tab.Income__c = mon.Balance__c;
   }
               /*  String monthName = lookupMonthName(mon.MonthDate__c);
                  if(monthName == tab.Month__c){
                    tab.Amount__c =  mon.Balance__c;
                    tab.Income__c = mon.Balance__c;*/
          

                }
             }
          List<Table__c> oldList = [select Id from Table__c];
          delete oldList;
          insert listForTable;
          return listForTable;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    @AuraEnabled(cacheable=true)
    public static Integer getYear(){
        try {
           List <Table__c> listForTable = [select Id,Year__c from Table__c];
           Integer year = Integer.valueOf(listForTable[0].Year__c);
           return year;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    @AuraEnabled(cacheable=true)
    public static List<Integer> getYearForTab(){
        try {
            Date now = date.today();
            Integer yearNow = now.Year();
            Integer firstYear = yearNow - 2;
            Integer secondYear = yearNow - 1;
            Integer fourthYear = yearNow + 1;
            List<Integer> years = new List<Integer>{firstYear,secondYear,yearNow,fourthYear}; 
            return years;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    @AuraEnabled(cacheable=true)
    public static List<Date> populateDates(Integer year,Integer month){
        try {

        List<Date>dateList = new List<Date>();
    
        Date monthBeginning = Date.newInstance(year, month, 1);
        Date monthEnd = Date.newInstance(year, month+1, 1) - 1;
        while(monthBeginning <= monthEnd) {
            dateList.add(monthBeginning);
            monthBeginning = monthBeginning.addDays(1);
        }
        
      
      return dateList;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
/*@AuraEnabled(cacheable=true)
public static List<Accord__c> getAccords(Integer year,Integer month){
    try {
        Date monthBeginning = Date.newInstance(year, month, 1);
        Date monthEnd = Date.newInstance(year, month + 1, 1) - 1;
        List<Accord__c> acdList = [select CardDate__c,ExpenseCard__c,Name from Accord__c
        where CardDate__c >= :monthBeginning AND CardDate__c <= :monthEnd];
        return acdList;
    } catch (Exception e) {
        throw new AuraHandledException(e.getMessage());
    }
}*/












@AuraEnabled(cacheable=true)
public static List<Accord__c> getAccords(){
    try {
        Integer maxDaysInAMonth = 31;
        List<Accord__c> acdList = [select CardDate__c,ExpenseCard__c,Name from Accord__c
        Limit :maxDaysInAMonth];
        return acdList;
    } catch (Exception e) {
        throw new AuraHandledException(e.getMessage());
    }
}
   @AuraEnabled
   public static List<Accord__c> getAccordWithExCards(Integer month){
       try {
      List<Table__c> tabList = [select Year__c from Table__c];   
      Integer year = Integer.valueOf(tabList[0].Year__c);
      List<Accord__c> acdList = new List<Accord__c>();
      List<Date> dates = populateDates(year,month + 1);
      for(Date dt : dates){
          Accord__c acd = new Accord__c(CardDate__c = dt);
          acdList.add(acd);
      }
      List <ExpenseCard__c> exCards = [select CardDate__c,Description__c,Amount__c from ExpenseCard__c];
      for(Accord__c acd : acdList){
          for(ExpenseCard__c exc : exCards){
              if(exc.CardDate__c == acd.CardDate__c){
                acd.ExpenseCard__c = exc.Id;
              }
          }
      }
    List<Accord__c> oldAccords = [select Id from Accord__c];
    delete oldAccords;
    insert acdList; 
    return acdList;
       } catch (Exception e) {
           throw new AuraHandledException(e.getMessage());
       }
    }
}