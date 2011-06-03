require 'digest/sha1'
class User < ActiveRecord::Base
  has_one :employee
  validates_format_of :password , :with => /^(?=.*\d)(?=.*([a-z]|[A-Z]))([\x20-\x7E]){6,40}$/,
                               :message => "should contain atleast a character and a digit with a minimum length of 6 symbols"   
  validates_presence_of     :username
  validates_uniqueness_of   :username
  validate :password_non_blank
  attr_accessor :password_confirmation
  validates_confirmation_of :password

  
  def password
    @password
    
  end

  def password=(pwd)
    @password = pwd
    return if pwd.blank?
    create_new_salt
    self.hashed_password = User.encrypted_password(self.password, self.salt)
  end

  def self.authenticate(username, password)
    user = self.find_by_username(username)
    if user
      expected_password = encrypted_password(password, user.salt)
      if user.hashed_password != expected_password
         user = nil
      end
    end
    user
  end
  
    
  
  private
    def password_non_blank
      errors.add(:password, "Missing password" ) if hashed_password.blank?
    end
    def self.encrypted_password(password, salt)
      string_to_hash = password + "wibble" + salt
      Digest::SHA1.hexdigest(string_to_hash)
    end
    
    def create_new_salt
      self.salt = self.object_id.to_s + rand.to_s
    end  
  
end
