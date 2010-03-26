# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key    => '_scratch_pad_session',
  :secret => '9b3032671cbf4ac50fa11166c3929d8604d827b94556661e2cf0381a815cf47b609da359e35d9bb5008765fb6ad8815703f7743a5e63136dc0716ef52af0851f'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
