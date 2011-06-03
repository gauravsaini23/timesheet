require 'test_helper'

class UserStoriesTest < ActionController::IntegrationTest
  fixtures :all
  
  test "start the application with login page" do
    get "users/login"
    assert_response :success
    assert_template "login"
  end
  
  
  

end
