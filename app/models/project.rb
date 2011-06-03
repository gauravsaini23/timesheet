class Project < ActiveRecord::Base
    has_many :timesheets
    has_many :employee_projects
    has_many :employees, :through => :employee_projects
    
    validates_presence_of :name, :description
    validates_uniqueness_of :name
    
    
end
