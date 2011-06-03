require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  # Replace this with your real tests.
  test "login" do
    get :login
    assert_response :success
  end
  
  test "before filter for home" do
    get :home
    assert_redirected_to :action => "login", :controller => "users"
    assert_equal "Please login to access this function of the application" , flash[:msg]
  end  
  
  test "home" do
    gaurav = users(:gaurav)
    session[:user_id] = gaurav.id
    get :home
    assert_response :success
  end  

  test "home with confirmation password hash" do
    gaurav = users(:gaurav1)
    
    session[:user_id] = gaurav.id
    get :home
    
    assert_equal "Please change your password through the link provided in your email inbox" , flash[:msg]
  end  
  
  
end
