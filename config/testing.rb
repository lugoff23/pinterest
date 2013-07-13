role :web, "78.47.48.233"                          # Your HTTP server, Apache/etc
role :app, "78.47.48.233"                          # This may be the same as your `Web` server
role :db,  "78.47.48.233", :primary => true # This is where Rails migrations will run
set :rails_env, 'testing'