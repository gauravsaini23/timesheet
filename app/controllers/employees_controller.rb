class EmployeesController < ApplicationController

  def create
    @emp = Employee.new
    #if request is post create a new employee using the parameters  
#create an array which consists of all the projects
    pro = Project.find(:all)
    @projects =Array.new
    pro.each do |p|
      @projects << p.name
    end  
    if request.post?
      check_for_admin

      if params[:emp][:"date_of_joining(1i)"].blank?
        return flash.now[:msg] = "Please enter a date"
      end  
      #convert date to a valid format      
      @date = params[:emp][:"date_of_joining(1i)"]+ "-" +  params[:emp][:"date_of_joining(2i)"] + "-" + params[:emp][:"date_of_joining(3i)"]
        begin
          @emp=Employee.new(:first_name => params[:emp][:first_name], :last_name => params[:emp][:last_name],
                                      :email => params[:emp][:email], :date_of_joining => @date.to_date)       
        rescue => ex
          return flash.now[:msg] =  "#{ex.class}: #{ex.message}"
        end
      
      if @emp.save
        hash = rand(1111110000000000000000000).to_s
#add details to the user table
        @newuser=User.new(:confirm_creation_hash => hash, :username => @emp.email, 
                          :password => "password1", :employee_id => @emp.id)
        if @newuser.save
#send mail to the user for confirmation and change password
          email = Sendmail.deliver_confirm_creation(@newuser)
          flash[:msg]="Employee successfully created and added to users"
#if there are any projects to be allocated do them
          unless params[:projects].blank?
            params[:projects].each do |project|
              pro = Project.find_by_name(project)
              emp_pro = EmployeeProject.new(:employee_id => @emp.id, :project_id => pro.id, :employee_name =>
                               @emp.first_name + @emp.last_name,:project_name => pro.name, :allocated_at => Time.now)
              emp_pro.save
            end
          end
          redirect_to_home
        else
          flash.now[:msg]="Employee successfully created but not as user"
        end
      end  
    end
  end
  
#list action to show the list of employees  
  def list
#check if users is logged in and is a admin user   
    check_for_admin
    @employees = Employee.find(:all)
=begin
    if @employees.blank?
      flash[:msg]="There are no employees working right now"
      redirect_to_home
    end  
=end
  end
  
  def edit
    if Employee.find(:all).blank?
      flash[:msg]="There are no employees working right now"
      redirect_to_home
    end     
#check if request is post 
    if params[:id]
      @emp = Employee.find_by_id(params[:id])
      @emp_pro = @emp.projects
     #create an array which consists of all the projects
       pro = Project.find(:all)
      @projects =Array.new
      pro.each do |p|
        @projects << p.name
      end  
    end  
    if request.post?
      check_for_admin

      if params[:employee][:e_id]
        @emp = Employee.find(params[:employee][:e_id])
      end  
    #if date is not entered show error message and return
      if @emp
        @emp.first_name= params[:employee][:first_name]
        @emp.last_name= params[:employee][:last_name]      
        @emp.email= params[:employee][:email]
         #convert date to a valid format      
        @date = params[:employee][:"date_of_joining(1i)"]+ "-" +  params[:employee][:"date_of_joining(2i)"] + "-" + params[:employee][:"date_of_joining(3i)"]
        begin
          @emp.date_of_joining = @date.to_date
        rescue => ex
          return flash.now[:msg] =  "#{ex.class}: #{ex.message}"
        end
        
        #if user saved redirect to the home action of admin
        euser = User.find_by_employee_id(@emp.id)
        euser.username = @emp.email
        euser.password = "password1"
       #edit name of employee in all projects allocated to him
        @emp.employee_projects.each do |e|
          e.employee_name = @emp.first_name + @emp.last_name
          e.save
        end

        if @emp.save and euser.save
          flash[:msg]="Changes made to user"
        
          if params[:projects]
            params[:projects].each do |project|
              pro = Project.find_by_name(project)
                
              emp_pro = EmployeeProject.new(:employee_id => @emp.id, :project_id => pro.id, :employee_name =>
                               @emp.first_name + @emp.last_name,:project_name => pro.name, :allocated_at => Time.now)
              emp_pro.save
            end
          end
          redirect_to_home   
        else
          flash[:msg] = "Employee can not be created "
          redirect_to_home
        end
      end    
    end   
  end  
  def update_leaving_date
    check_for_admin
    if request.post?
      emp = Employee.find_by_id(params[:dol][:id])
#if no date is entered show an error message
      if  params[:date_of_leaving][:"date(1i)"].blank?
        flash[:msg] = "Enter Date of leaving its  a manadatory field"
        return redirect_to :id => emp.id, :action => "edit", :controller => "employees"
      else
#otherwise calculate date
        date = params[:date_of_leaving][:"date(1i)"]+ "-" +  params[:date_of_leaving][:"date(2i)"] + "-" +
                            params[:date_of_leaving][:"date(3i)"]
      end
      emp.date_of_leaving = date.to_date
      if emp.save
        flash[:msg] = "Employee's leaving date updated"
        redirect_to_home
      else
        flash[:msg] = "Date of leaving is invalid"
        return redirect_to :action => "edit", :id => emp.id
      end  
    end
  end  
  def ajax_action
    check_for_admin
    @emp = Employee.find_by_id(params[:eid])
    pro = Project.find_by_id(params[:pid])
    allo_deallo(@emp, pro)#allocate  if not allocated and deallocate if allocated
    render(:partial => "project_list", :locals => {:user => @user})
  end
end
