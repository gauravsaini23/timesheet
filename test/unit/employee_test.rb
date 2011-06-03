require 'test_helper'

class EmployeeTest < ActiveSupport::TestCase

  test "for presence of attribute" do
    employee = Employee.new
    assert !employee.save
  end
  
  test "for empty email" do
    employee = Employee.new(:first_name => "Gaurav", :last_name => "Saini", :email => "",:date_of_joining => "2010-08-12".to_date)
    assert !employee.save
  end
  
  test "for not valid format of email" do
    employee = Employee.new(:first_name => "Gaurav", :last_name => "Saini", :email => "dsadsadsad",
                            :date_of_joining => "2010-08-12".to_date)
    assert !employee.save
  end
  test "for valid format of email" do
    employee = Employee.new(:first_name => "Gaurav", :last_name => "Saini", :email => "gauravsaini2@gmail.com",
                            :date_of_joining => "2010-08-12".to_date)
    assert employee.save  
  end  
  
  test "for firstname not empty" do
    employee = Employee.new(:first_name => "", :last_name => "Saini", :email => "gauravsaini2@gmail.com",
                            :date_of_joining => "2010-08-12".to_date)
    assert !employee.save
  end
   
  test "for date of joining not empty" do
    employee = Employee.new(:first_name => "", :last_name => "Saini", :email => "gauravsaini2@gmail.com",
                            :date_of_joining => "")
    assert !employee.save
  end
  
  test "for date of joining not greater than today" do
    employee = Employee.new(:first_name => "", :last_name => "Saini", :email => "gauravsaini2@gmail.com",
                            :date_of_joining => "2011-08-12".to_date)
    assert !employee.save
  end
  
  test "for duplication of email" do
    employee = Employee.new(:first_name => "Gaurav", :last_name => "Saini", :email => "gauravsaini4@gmail.com",
                            :date_of_joining => "2010-08-12".to_date)
    assert !employee.save  
  end  
    

end
