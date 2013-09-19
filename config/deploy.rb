#!/usr/bin/env ruby-local-exec
set :stages, %w(production staging)
set :default_stage, "staging"
require 'capistrano/ext/multistage'
require "bundler/capistrano"
# require 'airbrake/capistrano'
# require 'new_relic/recipes'

set :domain,                        "129.194.57.242"
set :scm,                           :git
set :scm_verbose,                   true
set :repository,                    "ssh://yannis@129.194.56.197/Users/yannis/gitrepos/biology14/.git"
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

after 'deploy:update_code', 'deploy:migrate'
after "deploy", "deploy:cleanup"
after "deploy:cleanup", "deploy:stop_reload_start"
