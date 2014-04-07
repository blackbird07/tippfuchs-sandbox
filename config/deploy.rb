# for template, see https://raw.githubusercontent.com/TalkingQuickly/capistrano-3-rails-template/master/config/deploy.rb

# config valid only for Capistrano 3.1
lock '3.1.0'

set :application, 'tippfuchs'

# version control system
set :scm, :git
set :repo_url,    'git@github.com:blackbird07/tippfuchs-sandbox.git'

set :deploy_user, 'vagrant'

# setup rbenv
set :rbenv_type, :system
set :rbenv_ruby, '2.1.1'
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}


set :keep_releases, 5

# files we want symlinking to specific entries in shared
# note: added config/application.yml
set :linked_files, %w{config/database.yml config/application.yml}

# dirs we want symlinking to shared
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}


# what specs should be run before deployment is allowed to
# continue, see lib/capistrano/tasks/run_tests.cap
set :tests, ["spec"] # run "rspec spec" before being allowed to continue


# which config files should be copied by deploy:setup_config
# see documentation in lib/capistrano/tasks/setup_config.cap
# for details of operations
# !Important!: will first look in config/deploy/<application>_<rails_env> and then in config/deploy/shared
#              Use cap production deploy:setup_config to copy the config files to the server
set(:config_files, %w(
  nginx_vhost.conf
  application.yml
  log_rotation
  monit
  unicorn.rb
  unicorn_init.sh
  database.yml
))

# which config files should be made executable after copying
# by deploy:setup_config
set(:executable_config_files, %w(
  unicorn_init.sh
))


# files which need to be symlinked to other parts of the
# filesystem. For example nginx virtualhosts, log rotation
# init scripts etc. The full_app_name variable isn't
# available at this point so we use a custom template {{}}
# tag and then add it at run time.
set(:symlinks, [
  {
    source: "nginx.conf",
    link: "/etc/nginx/sites-enabled/{{full_app_name}}"
  },
  {
    source: "unicorn_init.sh",
    link: "/etc/init.d/unicorn_{{full_app_name}}"
  },
  {
    source: "log_rotation",
   link: "/etc/logrotate.d/{{full_app_name}}"
  },
  {
    source: "monit",
    link: "/etc/monit/conf.d/{{full_app_name}}.conf"
  }
])

# this:
# http://www.capistranorb.com/documentation/getting-started/flow/
# is worth reading for a quick overview of what tasks are called
# and when for 'cap stage deploy'

namespace :deploy do
  # make sure we're deploying what we think we're deploying
  before :deploy, "deploy:check_revision"
  # only allow a deploy with passing tests to deployed
  before :deploy, "deploy:run_tests"
  # compile assets locally then rsync
  after 'deploy:symlink:shared', 'deploy:compile_assets_locally'
  after :finishing, 'deploy:cleanup'
end



# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

# Default deploy_to directory is /var/www/my_app
# set :deploy_to, '/var/www/my_app'

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }
