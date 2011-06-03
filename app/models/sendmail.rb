class Sendmail < ActionMailer::Base

  def forgot_password(user)
    subject    'Password Recovery'
    recipients  user.username
    from       "qc.testing@qualtech-consultants.com"
    sent_on    Time.now
    string = "http://localhost:3000/users/forgot_password/" + user.forgot_password_hash
    body       :string => string,:user => user
  end
  
  def confirm_creation(user)
    subject    'Create Password'
    recipients  user.username
    from       "qc.testing@qualtech-consultants.com"
    sent_on    Time.now
    string = "http://localhost:3000/users/forgot_password/" + user.confirm_creation_hash
    
    body       :string => string,:user => user
    

  end

  def confirm_editing(user,emp)
    subject    'Account Edited'
    recipients  user.username
    from       "qc.testing@qualtech-consultants.com"
    sent_on    Time.now
    
    body       :emp => emp,:user => user
  end  
end
