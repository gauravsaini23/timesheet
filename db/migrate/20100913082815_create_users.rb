class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
       t.string  :username
       t.string  :hashed_password
       t.string  :salt
       t.boolean :is_admin
       t.boolean :is_active   ,:default => 0
       t.integer :employee_id
       t.string  :forgot_password_hash
       t.string  :confirm_creation_hash       
       t.timestamps
    end
    
    create_table :employees do |t|
       t.string :first_name
       t.string :last_name
       t.string :email
       t.datetime :date_of_joining
       t.datetime :date_of_leaving

       t.timestamps
    end

    create_table :projects do |t|
      t.string :name
      t.string :deactivated_at
      t.string :description
      t.timestamps
    end
  
    create_table :employee_projects do |t|
      t.integer :employee_id
      t.integer :project_id      
      t.string :employee_name
      t.string :project_name
      t.time :allocated_at
      t.time :deallocated_at
      
      t.timestamps
    end  
    create_table :timesheets do |t|
      t.integer :employee_id
      t.integer :project_id
      t.string :employee_name
      t.string :project_name
      t.string :description
      t.time :duration 
      t.date :date

      t.timestamps
    end
    
  end
  def self.down
    drop_table :projects
    drop_table :users
    drop_table :employees
    drop_table :timesheets
    drop_table :employees_projects
  end
end
