class UsersController < ApplicationController

#for the login functionality 
  def login
#if session is already created redirect to home     
    if session[:user_id]
      user = User.find_by_id(session[:user_id])
#redirect only if user is not having password hashes
      if if_hashes_are_nil(user)
        redirect_to_home
      else
        session[:user_id] = nil
        return flash.now[:msg]="Please change your password through the link provided in your email inbox"
      end
    end
#if request is post check for username and password using authenticate    
    if request.post?
      if user = User.authenticate(params[:username],params[:password])
#if user is logging in first time it should change password first through link provided by email
        if if_hashes_are_nil(user)
          session[:user_id] = user.id
          redirect_to_home
        else
          return flash.now[:msg]="Please change your password through the link provided in your email inbox"
        end  
#if not found tell him/her that he/she is not authorized to login and redirect to login page
      else
        return flash.now[:msg]="Username password does not match"
      end  
    end  
  end
  
  def home
#if hashes are nil for the user show home page
    @user=User.find_by_id(session[:user_id])
    unless if_hashes_are_nil(@user)
      flash.now[:msg]="Please change your password through the link provided in your email inbox"
      return redirect_to :action => "login", :controller => "users"
    end  
  end  

  def logout
#- delete the session
    session[:user_id]=nil
    flash[:msg]="logged out"
#- show the login page -> redirect to action => login
    return redirect_to :action => "login"    
 
  end
  
  def change_password
#if user is logged in  create a user object
    @user=User.find_by_id(session[:user_id])
    if @user
      if request.post?
#if there is a forgot password hash then old password is to be checked for correctness
        if ( !@user.confirm_creation_hash && !@user.forgot_password_hash )
          if User.authenticate(@user.username, params[:change][:old_password]) == nil
# if old password field is missing show the error message
            if params[:change][:old_password].blank?
              return flash.now[:msg] = "Please enter old password"
            end
            flash.now[:msg]="old password does not match"
          end
        end  
# update the password
        @user.password=(params[:change][:password])
#if forgot_password_hash then update it to null
        @user.password_confirmation = params[:change][:password_confirmation]

#save the new password
        if @user.save  
          @user.update_attributes(:forgot_password_hash => nil, :confirm_creation_hash => nil )
          flash.now[:msg]="Password Changed"
          return redirect_to :action => "home"          
        end
      end 
    end
  end
  
  def forgot_password
#if logged in, show the error message    
    if session[:user_id]  
      flash[:msg]="You are already logged in"
      return redirect_to :action=>"home"
    end
#get request
#  find the forgot_password_hash for the id if parameters are coming
    if params[:id]
     @user=User.find(:first,:conditions=>["forgot_password_hash=? or confirm_creation_hash =?",params[:id],params[:id]])
      if @user
# if found, redirect to change_password without old_password
        session[:user_id] = @user.id
        return redirect_to :action => "change_password" 
#if not found, show the error message        
      else
        return flash.now[:msg]="Sorry your link is crashed you can get another link to change"
      end
    end 
# Post request
    if request.post?
      user=User.find(:first, :conditions => ["username = ?",params[:login][:email]])       
#if found, create a random unique number, update the field in the db, create a onetime link and  send it as mail to user
      if user
        user.forgot_password_hash =  rand(1111110000000000000000000).to_s
        user.password = "password1"
        if user.save
#send an email to the user
           @email = Sendmail.deliver_forgot_password(user)
           flash[:msg] = "Link to create new password is sent to Your email address"
           return redirect_to :action => "login"
        end  
      else
#if not found show an error  message      
        flash.now[:msg]="User email can not be found"  
      end  
    end    
  end
  def change_employee_password
    check_for_admin
    if Employee.find(:all).blank?
      return flash.now[:msg] = "There are no employees which can be allocated to this project"
    end  
    if request.post?
      @user = User.find_by_username(params[:email])
      @user.password = params[:change][:password]
      @user.password_confirmation = params[:change][:password_confirmation]
      if @user.save
        flash[:msg] = "Password of '#{@user.username}' changed"
        redirect_to_home
      end
    end  
  end  
end
