require 'spec_helper'

describe HomeController do

  describe "GET 'show'" do
    before {get :show}
    it {expect(response).to be_success}
    it {expect(assigns(:registration)).to be_a Registration}
    it {expect(assigns(:grouped_events)).to be_a Hash}
  end

end
