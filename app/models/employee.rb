class Employee < ActiveRecord::Base
  has_one :user
  has_many :timesheets
  has_many :employee_projects
  has_many :projects , :through => :employee_projects

  validates_presence_of   :email,:first_name,:last_name
  validates_uniqueness_of :email,
                          :message => " address already exists"
  validates_format_of     :email,
                          :with => /^([^\s]+)((?:[-a-z0-9]\.)[a-z]{2,})$/i

  validate :doj
  validate :dol  
 
  
  private
  def dol
    if date_of_leaving
      errors.add(:date_of_leaving , "can not be earlier to date of leaving" ) if date_of_leaving < date_of_joining
      errors.add(:date_of_leaving , "can not be in future" ) if date_of_leaving > Date.today
    end
  end    
  def doj
    if date_of_joining.blank? or date_of_joining.nil?
      errors.add(:please, "enter date of joining" ) 
    elsif date_of_joining > DateTime.now
      errors.add(:not, "valid date of joining" ) 
    end  
  end
  

end
