# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_das_session',
  :secret      => '2d1f726b647286e32cd7be73a833cf97c5c28352f29cc7479ea2ddb537264bf35a0ebac5a1842f157962cdf6d724e98326733f23a89be956e985bf35fdb2fc98'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
