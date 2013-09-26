require 'spec_helper'

describe 'registration routing' do
  specify {{post: '/registrations'}.should route_to(controller: 'registrations', action: 'create')}
  specify {{get: '/registrations/1/confirm'}.should route_to(controller: 'registrations', action: 'confirm', id: "1")}
end
