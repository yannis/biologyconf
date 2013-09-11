require 'spec_helper'

describe 'events routing' do
  specify {{get: '/events.pdf'}.should route_to(controller: 'events', action: 'index', format: 'pdf')}
end
