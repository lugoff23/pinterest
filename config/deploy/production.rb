role :web, "173.192.207.107"                          # Your HTTP server, Apache/etc
role :app, "173.192.207.107"                          # This may be the same as your `Web` server
role :db,  "173.192.207.107", :primary => true # This is where Rails migrations will run
set :user, "osharek"
set :rails_env, 'production'
set :ssh_options, {:forward_agent => true}