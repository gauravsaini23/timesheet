require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "password can not be only characters" do
    user = User.new(:username => "gaurav",
                    :password => "password" )
    assert !user.save
  end  

  test "password should contain characters and integers" do
    user = User.new(:username => "gaurav",
                    :password => "daslkdjlk990" )
    assert user.save
  end      
   test "invalid with empty attributes" do
    user = User.new()
    assert !user.save
  end    
  
  test "username can not be empty" do
    user = User.new(:password => "password1")
    assert !user.save
  end    
  
  
  test " password validations password cannot be more than 40" do
    user = User.new(:username => "v",
                    :password => "1234567891012345678901234567890-123456789aksldj" )
    assert !user.save
  end      
    test " username can not be blank" do
    user = User.new(:username => "",
                    :password => "daslkdjlk990" )
    assert !user.save
  end      
  test " username can not be duplicated" do
    user = User.new(:username => "rohit",
                    :password => "daslkdjlk990" )
    assert !user.save
  end
  test "password should be of atleast 6 length" do
    user = User.new(:username => "gaurav",
                    :password => "das1" )
    assert !user.save
  end      
end
