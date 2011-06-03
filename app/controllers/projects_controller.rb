  class ProjectsController < ApplicationController
    
    def create
  #show form to add details of project  
      
      #if its a admin user create a new project object on post request
      check_for_admin
      if request.post?

         @project = Project.new(params[:project])#put parameters coming in post request in it
         if @project.save      #make changes in database
           unless params[:employees].blank?
             params[:employees].each do |employee|
               emp = Employee.find_by_email(employee)
               emp_pro = EmployeeProject.new(:employee_id => emp.id, :project_id => @project.id, :employee_name =>
                               emp.first_name + emp.last_name,:project_name => @project.name, :allocated_at => Time.now)
               emp_pro.save
             end
              
           end
           flash[:msg] = "Project created successfully"        #show confirmation message if saved successfully
           redirect_to_home #and redirect user to his home
         end
      end
      
    end
    
    def list
      #check if user is not admin user redirect to home with error message
      check_for_admin
          #get all the projects from database to a object of project
          @projects = Project.find(:all)
#          if @projects.blank?     #if no projects found show error message
#            flash[:msg] = "There is not any project left now"
#            redirect_to_home
#          end  
    end
    
    def edit
      check_for_admin    
      if params[:id]
        @project = Project.find_by_id(params[:id])
      end
      if request.post?
        #if request is post change name and description    
        @project.name=params[:change][:name]
        @project.description=params[:change][:description]
        #also change the name of the project from the employees assigned
        a = @project.employee_projects.find_by_project_name(params[:change][:name])
        if a
          if a.save
            if @project.save
              flash.now[:msg]="Project successfully Edited"
              redirect_to_home
            else
              flash.now[:msg]="Project not saved"
            end  
          end  
        else
          redirect_to_home
        end  
      end  
    end    
    def deallocate
      check_for_admin
      if params[:id]
        entry = EmployeeProject.find_by_id(params[:id])
        entry.destroy
        if entry.save
          flash.now[:msg] = "Employee deallocated from project"
          return redirect_to :action => "list"
        end  
      end  
    end  
    def deactivate
      check_for_admin
      pro = Project.find_by_id(params[:id])
      pro.deactivated_at = DateTime.now
      if pro.save
        flash.now[:msg] = "Project Deactivated"
        return redirect_to :id => pro.id, :action => "edit", :controller => "projects"
      else
        flash[:msg] = "Project can not be deactivated"
        return redirect_to :action => "list", :controller => "projects"
      end  
    end
    def activate
      
      check_for_admin
      pro = Project.find_by_id(params[:id])
      pro.deactivated_at = nil
      if pro.save
        flash[:msg] = "Project activated"
        return redirect_to :id => pro.id, :action => "edit", :controller => "projects"
      else
        flash[:msg] = "Project can not be activated"
        return redirect_to :action => "list", :controller => "projects"
      end  
    end    
    
    def ajax_action
      check_for_admin
      emp = Employee.find_by_id(params[:eid])
      @project = Project.find_by_id(params[:pid])
      allo_deallo(emp, @project)#allocate  if not allocated and deallocate if allocated
      render(:partial => "employee_list")
    end
    def ajax_in_list
      check_for_admin
      emp = Employee.find_by_id(params[:eid])
      @project = Project.find_by_id(params[:pid])
      allo_deallo(emp,@project) 
      render(:partial => "employee_working")
    end  
    def projects_allocated_to_employee
      @projects = []
      EmployeeProject.find(:all, :conditions => {:employee_id => params[:id]}).each do |e|
        @projects << Project.find_by_id(e.project_id)
      end
    end
  end
