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

  describe "POST 'callback' with valid params" do
    let(:registration){create :registration}
    before {
      post :callback, id: "#{registration.booking.form_id}-#{registration.id}", hash: Digest::SHA256.hexdigest(Booking::SECRET_KEY+registration.booking.uni_id)
    }
    it {expect(flash[:success]).to eq "Payment successfull! We are looking forward to see you in Geneva soon."}
    it {expect(response).to redirect_to root_path}
  end

  describe "POST 'callback' with bad hash" do
    let(:registration){create :registration}
    it {
      expect {
        get :callback, id: "#{registration.booking.form_id}-#{registration.id}", hash: Digest::SHA256.hexdigest(Booking::SECRET_KEY+"2222222222222222")
      }.to raise_error RuntimeError, 'BookingCallbackError: HASH INCORRECT! {:uri=>"http://test.host/registrations/callback?hash=964c8ad4e8f776ee99ae351b629da7e6e173b99932a784c090912465b40af860&id=226-1", :my=>nil, :test=>nil, :uni_id=>"226-1", :hash=>"964c8ad4e8f776ee99ae351b629da7e6e173b99932a784c090912465b40af860", :mhash=>nil, :remote_addr=>"0.0.0.0", :cle=>"zrL$Rp5ImNsFWO,jv4THJ=@+Qn;t:(*|]!!2jf#.t226-1", :controle_SHA256=>"8240e4fd27017247bf9ef5cd5344960f578d3571181c5d701cfc69118f73f682"}'
    }
  end
end
