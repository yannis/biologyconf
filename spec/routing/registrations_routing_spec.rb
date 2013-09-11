require 'spec_helper'

describe 'registration routing' do
  specify {{post: '/registrations'}.should route_to(:controller => 'registrations', :action => 'create')}
end
