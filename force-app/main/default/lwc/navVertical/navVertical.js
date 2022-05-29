import { LightningElement,api,wire } from 'lwc';
import getMonExSpentAm from '@salesforce/apex/EmployeeController.getMonExSpentAm';
import getMonExIncome from '@salesforce/apex/EmployeeController.getMonExIncome';
import getMonthNameFromNum from '@salesforce/apex/EmployeeController.getMonthNameFromNum';
export default class NavVertical extends LightningElement {
  
  @api month;
  @api year;
  @api login;
  @api password;
  
  helper;
  monthlyExpenseSpentAmount = 0;
  monExBalance = 0;
  monExIncome = 0;
  monthName = 0;

  @wire(getMonExSpentAm,{year:'$year',month:'$month',login:'$login',password:'$password'})
  getMESA({ error, data }) {
    if (data) {
      if(data){
        this.monthlyExpenseSpentAmount = data[0];
      }
        this.error = undefined;
    } else if (error) {
        this.error = error;
        this.monthlyExpenseSpentAmount = undefined; 
        console.log('Something went wrong:', error);
        console.error('e.message => ' + e.message );
    }
  }
  
  @wire(getMonExIncome,{year:'$year',month:'$month',login:'$login',password:'$password'})
  getMEI({ error, data }) {
    if (data) {
      if(data){
        this.monExIncome = data[0];
      }
        this.error = undefined;
    } else if (error) {
        this.error = error;
        this.monExIncome = undefined; 
        console.log('Something went wrong:', error);
        console.error('e.message => ' + e.message );
    }
  }
  @wire(getMonthNameFromNum,{num:'$month'})
  getMNFM({ error, data }) {
    if (data) {
     if(data[0]){
        this.monthName = data[0];   
        this.error = undefined;
    } else if (error) {
        this.error = error;
        this.monthName = undefined; 
        console.log('Something went wrong:', error);
        console.error('e.message => ' + e.message );
    }
  }
 }
}