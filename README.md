# Expense

An application to control the expenses of imployees.

Employees should be able to log in to the SF and create/edit/delete their expense cards.Each employee should be able to see 
only their own expense cards.System Administrator should be able to see all records,to filter it by date/employee/location/etc.
This must be done using LWC.

Data model:Contact.Description:Contact will be used for storing employees in the system.Also,Contact will include a password 
of each employee.Thanks to Contact the employee will be able to login with their Email and Password.Contact for administrator 
will be checked as Admin.

Mockups:The first page for the employee should be a login page.Contact record should be created for each of the employees by 
the System Administrator.Login - it's an email of the employees contact.Password - generated by the System Administrator.

Expenses Page:after the successful login the employee should see the Expenses page where their own expense cards grouped by 
month and date are listed.Also,the Employee should be able to create a new card by clicking on the "New Expense" button
and top up the balance for the selected month.In the expanded accordion item should be a table where all of the cards for the
date defined in the header of an accordion item are listed.The user should be able to edit records by clicking on the table cell.
Year buttons value should be dynamic(we should not change values of the year buttons every year).Should look like this:
https://github.com/AndreiKapranov-cloud/Expense/blob/master/force-app/main/default/staticresources/employee.png



New Card Wizard:
When clicking on the "New Expense" button in the Card table employees need to see a New Card Wizard.Here you may find
their need to enter an amount,description and date for the new Expense Card.Card keeper must be defined automatically.
It should look like this:
https://github.com/AndreiKapranov-cloud/Expense/blob/master/force-app/main/default/staticresources/newexpcard.png


Trigger:
for the Expense card object,we need to create a trigger.The trigger will automatically assign Expense card to the Monthly Expense,
but if there is no Monthly Expense card it should be created.

Admin page:
After the successful login the administrator should see the Admin page.The administrator should have the statistics for all
offices for the selected year.Also,the administrator should be able to view the costs of any office.
The current balance of the office must take into account the balance of the previous year.The name of every office should
be clickable and it should work as a link to each office UI.The column count should be dynamic(not hardcoded 3 columns).
Should look like this:
https://github.com/AndreiKapranov-cloud/Expense/blob/master/force-app/main/default/staticresources/admin.png












