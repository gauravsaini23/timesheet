# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  layout 'users'
  before_filter :check_for_login, :except => [:login, :forgot_password]
  
  def check_for_login
    unless session[:user_id]
      #otherwise display an error message to the user
      flash[:msg]="Login Please"
      return redirect_to :action=> "login", :controller=> "users"
    end 
  end
  def if_hashes_are_nil(object)
    return true if object.confirm_creation_hash==nil and object.forgot_password_hash == nil
  end  

    
#Check if user is admin if not redirect to home page
 def check_for_admin
    
    user = User.find_by_id(session[:user_id])
    unless user.is_admin
      flash[:msg]="You are not adminstrator ?? ,  Are You ? Login as administrator .... to access it"
      redirect_to_home
    end 
  end  
#return redirects to home page of user
  def redirect_to_home
    return redirect_to :action => "home", :controller => "users"
  end  
     
#if project is allocated it deallocates and if deallocated it allocates
  def allo_deallo(emp, pro)
    emp_pro = EmployeeProject.find(:first, :conditions => {:employee_id => emp.id,:project_id => pro.id })
    if emp_pro
      emp_pro.delete
    else
      emp_pro = EmployeeProject.new(:employee_id => emp.id, :project_id => pro.id, :employee_name =>
                                emp.first_name + emp.last_name,:project_name => pro.name, :allocated_at => Time.now)
      emp_pro.save
    end  
  end
  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
end
