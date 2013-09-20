require 'spec_helper'

def abstract_valid_params
  build(:abstract).attributes
end

def valid_params
  build(:registration).attributes.merge({abstract_attributes: abstract_valid_params})
end


def invalid_params
  registration_invalid_attributes = build(:registration).attributes.delete_if{|k, v| k == "first_name"}
  registration_invalid_attributes.merge({abstract_attributes: abstract_valid_params})
end

describe RegistrationsController do

  describe "POST 'create with valid_params'" do
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

  describe "POST 'create with invalid_params'" do
    let!(:abstract_count){Abstract.count}
    let!(:registration_count){Registration.count}
    before {
      post :create, registration: invalid_params
    }

    it {expect(response).to render_template "home/show"}
    it {expect(flash[:success]).to be_nil}
    it {expect(assigns(:registration)).to_not be_valid_verbose}
    it {expect(Abstract.count).to eq abstract_count}
    it {expect(Registration.count).to eq registration_count}
    it {expect(assigns(:registration).errors.full_messages_for(:first_name).to_sentence).to eq "First name can't be blank"}
  end

end
