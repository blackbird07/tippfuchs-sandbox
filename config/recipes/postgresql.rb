# https://github.com/pferdefleisch/capistrano-recipes/blob/master/postgresql.rb

set_default(:postgresql_host, "localhost")
set_default(:postgresql_user) { fetch(:application) }
set_default(:postgresql_password) { Capistrano::CLI.password_prompt "PostgreSQL Password: " }
set_default(:postgresql_database) { "#{fetch(:application)}_#{fetch(:stage)}" }

namespace :postgresql do
  task :setup, roles: :db do
    invoke 'postgresql:create_db_user'
    invoke 'postgresql:create_database'
  end
  after 'deploy:started', 'postgresql:setup'
  
  desc "Create a database user for this application"
  task :create_db_user, roles: :db, only: {primary: true} do
    as 'postgres' do
      execute %{psql -tAc "SELECT 1 FROM pg_user WHERE usename='#{postgresql_user}'" | grep -q 1 || psql -U postgres -c "create user #{postgresql_user} with password '#{postgresql_password}';"}
    end
  end
  
  desc "Create a database for this application."
  task :create_database, roles: :db, only: {primary: true} do
    as 'postgres' do
      execute %{psql -tAc "SELECT 1 FROM pg_database WHERE datname='#{postgresql_database}'" | grep -q 1 || psql -U postgres -c "create database #{postgresql_database} owner #{postgresql_user};"}
    end
  end
end