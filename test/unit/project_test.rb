require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "for presence of name and description" do
    project = Project.new
    assert !project.save
  end
  
  test "for absence of name only" do
     project = Project.new(:name => "", :description => "i am giving description only for this project")
     assert !project.save
  end
  
  test "for absence of description " do
     project = Project.new(:name => "my project", :description => "")
     assert !project.save
  end
  test "for uniqueness of name " do
     project = Project.new(:name => "my_name", :description => "i am giving description only for this project")
     assert !project.save
  end  
end
