
guard 'livereload', :api_version => '2.3' do
  watch(%r{app/.+.(erb|haml)})
  watch(%r{app/helpers/.+.rb})
  watch(%r{app/admin/.+.rb})
  watch(%r{(public/|app/assets).+.(css|js|html)})
  watch(%r{(app/assets).+.(css|js|html)})
  watch(%r{(app/assets/.+.css).s[ac]ss}) { |m| m[1] }
  watch(%r{(app/assets/.+.js).coffee}) { |m| m[1] }
  watch(%r{config/locales/.+.yml})
  watch(%r{^app/assets/.+$})
  watch(%r{^app/presenters/.+$})
  watch(%r{^app/controllers/.+$})
end


guard 'rspec', zeus: true, bundler: false,  cli: "--profile --color -r rspec/instafail -f RSpec::Instafail", all_after_pass: false, all_on_start: false, keep_failed: false, notification: false do
  watch('spec/spec_helper.rb')                                               { "spec" }
  watch('app/controllers/application_controller.rb')                         { "spec/controllers" }
  watch('config/routes.rb')                                                  { "spec/routing" }
  watch(%r{^spec/support/(requests|controllers|mailers|models)_helpers\.rb}) { |m| "spec/#{m[1]}" }
  watch(%r{^spec/.+_spec\.rb})
  watch(%r{^spec/routing/.+_spec\.rb})
  watch(%r{^app/controllers/(.+)_(controller)\.rb})                          { |m| ["spec/routing/#{m[1]}_routing_spec.rb", "spec/#{m[2]}s/#{m[1]}_#{m[2]}_spec.rb", "spec/requests/#{m[1]}_spec.rb"] }

  watch(%r{^app/(.+)\.rb})                                                   { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^lib/(.+)\.rb})                                                   { |m| "spec/lib/#{m[1]}_spec.rb" }
end


guard 'bundler' do
  watch('Gemfile')
  # Uncomment next line if Gemfile contain `gemspec' command
  # watch(/^.+\.gemspec/)
end

# guard 'zeus' do
#   # uses the .rspec file
#   # --colour --fail-fast --format documentation --tag ~slow
#   watch(%r{^spec/.+_spec\.rb$})
#   watch(%r{^app/(.+)\.rb$})                           { |m| "spec/#{m[1]}_spec.rb" }
#   watch(%r{^app/(.+)\.haml$})                         { |m| "spec/#{m[1]}.haml_spec.rb" }
#   watch(%r{^lib/(.+)\.rb$})                           { |m| "spec/lib/#{m[1]}_spec.rb" }
#   watch(%r{^app/controllers/(.+)_(controller)\.rb$})  { |m| ["spec/routing/#{m[1]}_routing_spec.rb", "spec/#{m[2]}s/#{m[1]}_#{m[2]}_spec.rb", "spec/requests/#{m[1]}_spec.rb"] }

#   # TestUnit
#   # watch(%r|^test/(.*)_test\.rb$|)
#   # watch(%r|^lib/(.*)([^/]+)\.rb$|)     { |m| "test/#{m[1]}test_#{m[2]}.rb" }
#   # watch(%r|^test/test_helper\.rb$|)    { "test" }
#   # watch(%r|^app/controllers/(.*)\.rb$|) { |m| "test/functional/#{m[1]}_test.rb" }
#   # watch(%r|^app/models/(.*)\.rb$|)      { |m| "test/unit/#{m[1]}_test.rb" }
# end
