# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_timesheet_session',
  :secret      => '86bcc310c8d636c17e6312286aa3d634acbd105a23c82ae89f501c4bf5a4c67330cee435e49fdecb557c5c0774c928262712f7f7c459e4e1c6df39ce11e4e47d'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
