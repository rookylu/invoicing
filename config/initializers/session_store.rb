# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_invoice_session',
  :secret      => 'c60019b71a8b9e4c9c50b822623a661657cb8d487be82b33094ad82fffd3fa65d91ab716a092709ab425a70847835509d9b20eceffeb49e07f89d92c4003c7d3'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
