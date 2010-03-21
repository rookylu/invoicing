namespace :db do
  desc "Drop and recreate the dev. db from scratch, and copy its structure to the test db"
  task :rebuild => [ :drop, :create, :migrate, 'test:clone_structure' ] do
    # db:test:prepare changes the db connection to test, this resets it back to what it was.
    ActiveRecord::Base.establish_connection(RAILS_ENV.to_sym)
  end
end
