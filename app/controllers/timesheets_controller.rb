class TimesheetsController < ApplicationController
  def create
    user = User.find_by_id(session[:user_id])
    emp = Employee.find_by_id(user.employee_id)
    @projects = []
    emp.projects.each do |p|
      @projects << p.name
    end   
    if request.post?
      pro = Project.find_by_name(params[:project_name])
      if pro
        user = User.find_by_id(session[:user_id])
        time = Time.mktime(Date.today.strftime("%Y"),Date.today.strftime("%m"),Date.today.strftime("%d"), 
                            params[:timesheet][:"start(4i)"].to_i,
                            params[:timesheet][:"start(5i)"].to_i ,0,0)
        return flash.now[:msg] = "Hey, You didn't filled duration." if time.hour == 0 and time.min == 0
        date = Date.civil(params[:timesheet][:"date(1i)"].to_i,params[:timesheet][:"date(2i)"].to_i,
                      params[:timesheet][:"date(3i)"].to_i)

        new_sheet = Timesheet.new(:employee_id => user.employee_id, :project_id => pro.id,
                                    :project_name => params[:project_name],
                                    :employee_name => Employee.find_by_id(user.employee_id).first_name,
                                    :description => params[:timesheet][:description],
                                    :duration =>  time,
                                    :date => date.to_date)
        if new_sheet.save
          flash[:msg] = "Timesheet filled"
          redirect_to_home
        end     
      else
        flash.now[:msg]= "Project not found"
      end  
    end  
  end    
  
  def view
    @user=User.find_by_id(session[:user_id])
    if @user
#When user logs in show the timesheets for today      
      if @user.is_admin
#if user is admin show all timesheets of today
        date =Date.today
        @timesheets = Timesheet.find(:all, :conditions => {:date => date})
      else
#otherwise show timesheets of current user only
        @timesheets = Timesheet.find(:all, :conditions => {:date => Date.today,:employee_id => @user.employee_id})
      end
#if request is post show timesheets accordingly
      if request.post? 
#get date_from if date_from is present
        @date_from = Date.civil(params[:timesheet_of][:"date_from(1i)"].to_i,
                               params[:timesheet_of][:"date_from(2i)"].to_i,
                               params[:timesheet_of][:"date_from(3i)"].to_i)
#get date_to if date_to is present
        @date_to = Date.civil(params[:timesheet_of][:"date_to(1i)"].to_i,
                             params[:timesheet_of][:"date_to(2i)"].to_i,
                             params[:timesheet_of][:"date_to(3i)"].to_i)
#get project_id if params[:project_id] > 0
        project_id = params[:timesheet_of][:project_id].to_i if params[:timesheet_of][:project_id].to_i > 0 
#get employee_id if params[:employee_id] > 0
        employee_id = params[:timesheet_of][:employee_id].to_i if params[:timesheet_of][:employee_id].to_i > 0
#if normal employee is logged in
        employee_id = @user.employee_id if !@user.is_admin
#make conditions
        conditions = []
        conditions[0] = "date >= ? and date <= ?"
        conditions << @date_from
        conditions << @date_to
        if employee_id
          conditions[0] += " and employee_id = ?"
          conditions << employee_id
        end
        if project_id
          conditions[0] += " and project_id = ?"
          conditions << project_id
        end
        conditions.join(", ")
        @timesheets = Timesheet.find(:all, :conditions => conditions)
        flash.now[:msg] = "No timesheet for this data" if @timesheets.blank?
      end 
    end   
  end  
  
  def sort_it
    @user = User.find_by_id(session[:user_id])
    @timesheets = []
    params[:array].each do |i|
      @timesheets << Timesheet.find_by_id(i)
    end
    conditions = []
    if params[:id] == "e"
      if params[:eorder] == "⇩"
        @timesheets.sort! {|a,b| a.employee_name.downcase <=> b.employee_name.downcase }
         @eorder = "⇧"
      else
        @timesheets.sort! {|a,b| b.employee_name.downcase <=> a.employee_name.downcase }
        @eorder = "⇩"
      end
    elsif params[:id] == "p"
      if params[:porder] == "⇩"
        @timesheets.sort! {|a,b| a.project_name.downcase <=> b.project_name.downcase }
        @porder = "⇧"
      else
        @timesheets.sort! {|a,b| b.project_name.downcase <=> a.project_name.downcase }
        @porder = "⇩"
      end
    elsif params[:id] == "d"
      if params[:dorder] == "⇩"
        @timesheets.sort! {|a,b|   b.date <=> a.date }
        @dorder = "⇧"
      else
        @timesheets.sort! {|a,b|   a.date <=> b.date }
        @dorder = "⇩"
      end
    elsif params[:id] == "du"
      if params[:duorder] == "⇩"
        @timesheets.sort! {|a,b|   b.duration <=> a.duration }
         @duorder = "⇧"
      else
        @timesheets.sort! {|a,b|   a.duration <=> b.duration }
        @duorder = "⇩"
      end
    end
    render(:partial => "sheet")    
  end
  
  def update_projects
    @projects = []
    user = User.find_by_id(session[:user_id])
    emp = Employee.find_by_id(user.employee_id)
    emp.projects.each do |p|
      @projects << p.name
    end   

    render(:partial => "project_list",:locals =>{:projects => @projects})    
    
  end
end
