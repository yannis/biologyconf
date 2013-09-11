require 'spec_helper'

describe 'home routing' do
  specify {{:get => '/'}.should route_to(:controller => 'home', :action => 'show')}
end
