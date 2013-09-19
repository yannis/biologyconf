#!/bin/sh
cd /Users/yannis/railsapps/biology14_staging/current;
/Users/yannis/.rbenv/shims/god;
/Users/yannis/.rbenv/shims/god load config/unicorn.god && /Users/yannis/.rbenv/shims/god start biology14_staging_unicorn;
