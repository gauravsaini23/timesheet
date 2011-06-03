class EmployeeProject < ActiveRecord::Base
  belongs_to :employee
  belongs_to :project
end
