# for template, see https://raw.githubusercontent.com/TalkingQuickly/capistrano-3-rails-template/master/config/deploy.rb

# config valid only for Capistrano 3.1
lock '3.1.0'

set :application, 'tippfuchs'
set :deploy_user, 'vagrant'
# full_app_name is only known at runtime - use custom substituion in
# lib/capistrano/substitute_strings.rb

# version control system
set :scm,         :git
set :repo_url,    'git@github.com:emrass/tippfuchs-sandbox.git'

# setup rbenv
set :rbenv_type,     :system
set :rbenv_ruby,     '2.1.1'
set :rbenv_prefix,   "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}


set :keep_releases, 5

# files in /shared we want to symlink into the deployed app dir
set :linked_files, %w{config/database.yml config/application.yml}

# dirs in /shared we want to symlink into the deployed app dir
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}


# what specs should be run before deployment is allowed to
# continue, see lib/capistrano/tasks/run_tests.cap
set :tests, ["spec"] # run "rspec spec" before being allowed to continue, requires rspec!


# Which config files should be copied by deploy:setup_config
# See documentation in lib/capistrano/tasks/setup_config.cap for details
# !Important!: Will first look in config/deploy/<application>_<rails_env> and then in config/deploy/shared
#              Use cap production deploy:setup_config to copy the config files to the server
set(:config_files, %w(
  application.yml
  database.yml
  nginx_vhost.conf
  ssl_cert.crt
  ssl_cert.key
  unicorn_init.sh
  unicorn.rb
  log_rotation
  monit
))

# which config files should be made executable after copying by deploy:setup_config
set(:executable_config_files, %w(
  unicorn_init.sh
))


# files which need to be symlinked to other parts of the filesystem. For example
# nginx virtualhosts, log rotation init scripts etc. Again, infer full_app_name
# at runtime.
set(:symlinks, [
  {
    source: "nginx_vhost.conf",
    link:   "/etc/nginx/sites-enabled/{{full_app_name}}"
  },
  {
    source: "unicorn_init.sh",
    link:   "/etc/init.d/unicorn_{{full_app_name}}"
  },
  {
    source: "log_rotation",
   link:    "/etc/logrotate.d/{{full_app_name}}"
  }#,
  #{
  #  source: "monit",
  #  link:   "/etc/monit/conf.d/{{full_app_name}}.conf"
  #}
])

namespace :deploy do
  before :deploy, 'deploy:check_revision' # make sure we know what we're deploying
  #before :deploy, 'deploy:run_tests'      # only allow a deploy when tests pass
  after 'deploy:symlink:shared', 'deploy:compile_assets_locally'
  after :finishing, 'deploy:cleanup'
end

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }
