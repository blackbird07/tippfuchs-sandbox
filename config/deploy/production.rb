server '192.168.2.10', user: fetch(:deploy_user), roles: %w{web app db}, primary: true

set :stage,     :production
set :rails_env, :production  # Always set environment explicitly!
set :branch,    'master'

# Allows to deploy multiple versions of the same app side by side.
# Also provides quick sanity checks when looking at filepaths.
set :full_app_name, "#{fetch(:application)}_#{fetch(:stage)}"

set :deploy_to,     "/home/#{fetch(:deploy_user)}/apps/#{fetch(:full_app_name)}"

# Nginx
set :enable_ssl, true
set :nginx_server_name, 'tippfuchs.de tippfuchs.com bet-fox.com'
set :nginx_enable_spdy, true

# Unicorn (+ Monit)
set :unicorn_worker_count, 2