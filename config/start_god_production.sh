#!/bin/sh
cd /Users/yannis/railsapps/biology14_production/current;
/Users/yannis/.rbenv/shims/god;
/Users/yannis/.rbenv/shims/god load config/unicorn_production.god && /Users/yannis/.rbenv/shims/god start biology14_production_unicorn;
