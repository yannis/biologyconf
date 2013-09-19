#!/bin/sh
cd /Users/yannis/railsapps/genev2/current;
/Users/yannis/.rbenv/shims/god;
/Users/yannis/.rbenv/shims/god load config/unicorn.god && /Users/yannis/.rbenv/shims/god start genev2_unicorn;
/Users/yannis/.rbenv/shims/god load config/sidekiq.god && /Users/yannis/.rbenv/shims/god start genev2_sidekiq;

# /Users/yannis/.rbenv/shims/god; #starts god
# /Users/yannis/.rbenv/shims/god load /Users/yannis/railsapps/genev2/current/config/unicorn.god && /Users/yannis/.rbenv/shims/god start genev2_unicorn;
# /Users/yannis/.rbenv/shims/god load /Users/yannis/railsapps/genev2/current/config/sidekiq.god;