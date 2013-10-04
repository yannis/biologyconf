require 'spec_helper'

def abstract_valid_params
  build(:abstract).attributes
end

def valid_params
  build(:registration).attributes
end


def invalid_params
  registration_invalid_attributes = build(:registration).attributes.delete_if{|k, v| k == "first_name"}
end

describe RegistrationsController do

  describe "GET 'confirm' with valid session registration_id" do
    let(:registration){create :registration}
    before {
      session[:registration_id] = registration.id_token
      get :confirm, id: registration.to_param
    }
    it {expect(response).to render_template "confirm"}
  end

  describe "GET 'confirm' with invalid session registration_id" do
    let(:registration){create :registration}
    before {
      session[:registration_id] = nil
      get :confirm, id: registration.to_param
    }
    it {expect(response).to redirect_to root_path}
    it {expect(flash[:error]).to eq "You can't access this registration"}
  end

  describe "GET 'edit' with valid session registration_id" do
    let(:registration){create :registration}
    before {
      session[:registration_id] = registration.id_token
      get :edit, id: registration.to_param
    }
    it {expect(response).to render_template "home/show"}
  end

  describe "GET 'confirm' with invalid session registration_id" do
    let(:registration){create :registration}
    before {
      session[:registration_id] = nil
      get :edit, id: registration.to_param
    }
    it {expect(response).to redirect_to root_path}
    it {expect(flash[:error]).to eq "You can't access this registration"}
  end


  describe "POST 'create with valid_params'" do
    let!(:registration_count){Registration.count}
    before {
      post :create, registration: valid_params
    }
    it {expect(response).to redirect_to confirm_registration_path(assigns(:registration))}
    it {expect(flash[:success]).to be_nil}
    it {expect(assigns(:registration)).to be_valid_verbose}
    it {expect(Registration.count).to eq registration_count+1}
  end

  describe "POST 'create with invalid_params'" do
    let!(:registration_count){Registration.count}
    before {
      post :create, registration: invalid_params
    }

    it {expect(response).to render_template "home/show"}
    it {expect(flash[:success]).to be_nil}
    it {expect(assigns(:registration)).to_not be_valid_verbose}
    it {expect(Registration.count).to eq registration_count}
    it {expect(assigns(:registration).errors.full_messages_for(:first_name).to_sentence).to eq "First name can't be blank"}
  end

  describe "PATCH 'update' with valid params" do
    let(:registration){create :registration, paid: false}
    before {
      session[:registration_id] = registration.id_token
      patch :update, id: registration.to_param, registration: {first_name: "new first_name"}
    }
    it {expect(response).to redirect_to confirm_registration_path(registration)}
    it {expect(flash[:success]).to be_nil}
    it {expect(assigns(:registration)).to be_valid_verbose}
    it {expect(assigns(:registration)).to eq registration}
    it {expect(registration.reload.first_name).to eq "new first_name"}
  end
  describe "PATCH 'update' with invalid params" do
    let(:registration){create :registration, paid: false}
    before {
      session[:registration_id] = registration.id_token
      patch :update, id: registration.to_param, registration: {first_name: ""}
    }
    it {expect(response).to render_template "home/show"}
    it {expect(flash[:success]).to be_nil}
    it {expect(assigns(:registration)).to_not be_valid_verbose}
    it {expect(assigns(:registration).errors.full_messages_for(:first_name).to_sentence).to eq "First name can't be blank"}
  end

  describe "POST 'callback' with valid params" do
    let(:registration){create :registration}
    before {
      post :callback, id: "#{registration.booking.form_id}-#{registration.id}", mhash: Digest::MD5.hexdigest(registration.booking.uni_id+ENV['BOOKING_SECRET_KEY'])
    }
    it {expect(registration.reload.paid).to be_true}
    it {expect(flash[:success]).to eq "Payment successfull! We are looking forward to see you in Geneva soon."}
    it {expect(response).to redirect_to root_path}
  end

  describe "POST 'callback' with bad hash" do
    let(:registration){create :registration}
    before {
      post :callback, id: "#{registration.booking.form_id}-#{registration.id}", mhash: "hjkdjgkfjfgjkgfghj"
    }
    it {expect(flash[:success]).to be_nil}
    it {expect(flash[:error]).to eq "A problem occurred with your payment. Please contact the organizers of the conference."}
    it {expect(response).to redirect_to root_path}
  end

end
