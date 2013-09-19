require 'spec_helper'

def abstract_valid_params
  build(:abstract).attributes
end

def valid_params
  build(:registration).attributes.merge({abstract_attributes: abstract_valid_params})
end

describe RegistrationsController do

  describe "POST 'create'" do
    let!(:abstract_count){Abstract.count}
    let!(:registration_count){Registration.count}
    before {
      post :create, registration: valid_params
    }

    it {expect(response).to redirect_to root_path}
    it {expect(flash[:success]).to eq "Registration successfull"}
    it {expect(assigns(:registration)).to be_valid_verbose}
    it {expect(Abstract.count).to eq abstract_count+1}
    it {expect(Registration.count).to eq registration_count+1}
  end

end
