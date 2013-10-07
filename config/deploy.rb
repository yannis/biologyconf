#!/usr/bin/env ruby-local-exec
set :stages, %w(production staging)
set :default_stage, "staging"
require 'capistrano/ext/multistage'
require "bundler/capistrano"
# require 'airbrake/capistrano'
# require 'new_relic/recipes'
default_run_options[:pty] = true  # Must be set for the password prompt
                                  # from git to work

set :domain,                        "129.194.57.242"
set :scm,                           :git
set :scm_verbose,                   true
# set :repository,                    "ssh://yannis@129.194.56.197/Users/yannis/gitrepos/biology14/.git"
set :repository,                    "git@github.com:yannis/biologyconf.git"
set :deploy_via,                    :remote_cache
set :migrate_target,                :current
set :ssh_options,                   { :forward_agent => true }
set :normalize_asset_timestamps,    false
set :rbenv_path,                    "/Users/yannis/.rbenv"
set :bundle_flags,                  "--deployment --quiet --binstubs --shebang ruby-local-exec"
set :default_environment,           {
  "PATH" => "/usr/local/bin:/usr/local/sbin:#{rbenv_path}/shims:#{rbenv_path}/bin:$PATH"
}
set :user,            "yannis"
set :use_sudo,        false
set :rake,            "#{rake} --trace"
role :web,            domain
role :app,            domain
role :db,             domain, :primary => true

def run_rake(cmd)
  run "cd #{current_path}; #{rake} #{cmd}"
end

before 'deploy:assets:precompile' do
  run "ln -s #{shared_path}/config/application.yml #{release_path}/config/application.yml"
  run "ln -s #{shared_path}/config/database.yml #{release_path}/config/database.yml"
end
after 'deploy', 'deploy:migrate'
after "deploy:migrate", "deploy:cleanup"
after "deploy:cleanup", "deploy:stop_reload_start"

