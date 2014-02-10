require 'spec_helper'

def abstract_valid_params
  build(:abstract).attributes
end

def valid_params
  build(:registration,
    :abstract).attributes
end


def invalid_params
  registration_invalid_attributes = build(:registration).attributes.delete_if{|k,
    v| k == "first_name"}
end

describe RegistrationsController do

  context "before reaching deadlines" do
    before {
      Timecop.travel(Registration::POSTER_DEADLINE.-10.minutes)
      visit root_path(anchor: 'registration')
    }
    after {
      Timecop.return
    }

    describe "GET 'confirm' with valid session registration_id" do

      let(:registration){create :registration}
      before {
        session[:registration_id_token] = registration.id_token
        get :confirm,
        id: registration.to_param
      }
      it {expect(registration.id_token).to eq session[:registration_id_token]}
      # it {expect(response).to redirect_to root_path}
      it {
        expect(response).to render_template "confirm"
      }
    end

    describe "GET 'confirm' with invalid session registration_id" do
      let(:registration){create :registration}
      before {
        session[:registration_id_token] = nil
        get :confirm,
        id: registration.to_param
      }
      it {expect(response).to redirect_to root_path}
      it {expect(flash[:error]).to eq "You can't access this registration"}
    end

    describe "GET 'edit' with valid session registration_id" do
      let(:registration){create :registration}
      before {
        session[:registration_id_token] = registration.id_token
        get :edit,
        id: registration.to_param
      }
      it {expect(response).to render_template "home/show"}
    end

    describe "GET 'confirm' with invalid session registration_id" do
      let(:registration){create :registration}
      before {
        session[:registration_id_token] = nil
        get :edit,
        id: registration.to_param
      }
      it {expect(response).to redirect_to root_path}
      it {expect(flash[:error]).to eq "You can't access this registration"}
    end


    describe "POST 'create with valid_params'" do
      let!(:registration_count){Registration.count}
      before {
        post :create,
        registration: valid_params
      }
      it {expect(response).to redirect_to confirm_registration_path(assigns(:registration))}
      it {expect(flash[:success]).to be_nil}
      it {expect(assigns(:registration)).to be_valid_verbose}
      it {expect(Registration.count).to eq registration_count+1}
      it {expect(session[:registration_id_token]).to eq Digest::SHA1.hexdigest(Time.now.to_s + assigns(:registration).id.to_s)}
    end

    describe "POST 'create with invalid_params'" do
      let!(:registration_count){Registration.count}
      before {
        post :create,
        registration: invalid_params
      }

      it {expect(response).to render_template "home/show"}
      it {expect(flash[:success]).to be_nil}
      it {expect(assigns(:registration)).to_not be_valid_verbose}
      it {expect(Registration.count).to eq registration_count}
      it {expect(assigns(:registration).errors.full_messages_for(:first_name).to_sentence).to eq "First name can't be blank"}
    end

    describe "PATCH 'update' with valid params" do
      let(:registration){create :registration,
        paid: false}
      before {
        session[:registration_id_token] = registration.id_token
        patch :update,
        id: registration.to_param,
        registration: {first_name: "new first_name"}
      }
      it {expect(response).to redirect_to confirm_registration_path(registration)}
      it {expect(flash[:success]).to be_nil}
      it {expect(assigns(:registration)).to be_valid_verbose}
      it {expect(assigns(:registration)).to eq registration}
      it {expect(registration.reload.first_name).to eq "new first_name"}
    end
    describe "PATCH 'update' with invalid params" do
      let(:registration){create :registration,
        paid: false}
      before {
        session[:registration_id_token] = registration.id_token
        patch :update,
        id: registration.to_param,
        registration: {first_name: ""}
      }
      it {expect(response).to render_template "home/show"}
      it {expect(flash[:success]).to be_nil}
      it {expect(assigns(:registration)).to_not be_valid_verbose}
      it {expect(assigns(:registration).errors.full_messages_for(:first_name).to_sentence).to eq "First name can't be blank"}
    end

    describe "POST 'callback' with valid params" do
      let(:registration){create :registration}
      describe "registration is modified" do
        before {
          session[:registration_id_token] = registration.id_token
          post :callback,
            id: "#{registration.form_id}-#{registration.timestamp_id}",
            mhash: Digest::MD5.hexdigest(registration.uni_id+ENV['BOOKING_SECRET_KEY'])
        }
        it {expect(registration.reload.paid).to be_true}
        it {expect(flash[:success]).to eq "Payment successfull! We are looking forward to see you in Geneva soon."}
        it {expect(response).to redirect_to root_path}
        it {expect(session[:registration_id_token]).to be_nil}
      end
    end


    describe "POST 'callback' with bad hash" do
      let(:registration){create :registration}
      before {
        session[:registration_id_token] = registration.id_token
        post :callback,
        id: "#{registration.form_id}-#{registration.timestamp_id}",
        mhash: "hjkdjgkfjfgjkgfghj"
      }
      it {expect(flash[:success]).to be_nil}
      it {expect(flash[:error]).to eq "A problem occurred with your payment. Please contact the organizers of the conference."}
      it {expect(response).to redirect_to root_path}
      it {expect(session[:registration_id_token]).to eq registration.id_token}
    end
  end

  context "After reaching deadline" do
    before {
      Timecop.travel(Registration::POSTER_DEADLINE.+10.minutes)
      visit root_path(anchor: 'registration')
    }
    after {
      Timecop.return
    }
  end



  describe RegistrationsController::RegistrationParams do
    let(:registration_full_params) {
      {
        first_name: "Melyna",
        last_name: "Hilpert",
        email: "art.hilll@wisoky.info",
        institute: "Prohaska Inc",
        address: "38653 Effie Parkway",
        city: "Vanessaport",
        zip_code: "67688-9118",
        country: "Switzerland",
        title: "Sit autem autem enim et earum laboriosam.",
        authors: "Flo Ondricka",
        body: "Lorem ipsum dolor sit amet,
        consectetur adipisicing elit,
        sed do eiusmod tempor",
        talk: true,
        category_name:  "non_member",
        dinner_category_name: "student",
        dormitory: true,
        vegetarian: true,
        poster_agreement: true
      }
    }
    context "before reaching poster deadline" do
      before {
        Timecop.travel(Registration::POSTER_DEADLINE-10.minutes)
      }
      after {
        Timecop.return
      }
      it "returns the full params" do
        params = ActionController::Parameters.new registration: {}.merge(registration_full_params)
        permitted_params = RegistrationsController::RegistrationParams.permit(params)
        expect(permitted_params).to eq registration_full_params.with_indifferent_access
      end
    end

    context "after reaching poster deadline" do
      before {
        Timecop.travel(Registration::POSTER_DEADLINE+10.minutes)
      }
      after {
        Timecop.return
      }
      it "returns the full params" do
        params = ActionController::Parameters.new registration: {}.merge(registration_full_params)
        permitted_params = RegistrationsController::RegistrationParams.permit(params)
        expect(permitted_params).to eq registration_full_params.delete_if{|key, value| [:authors, :body, :poster_agreement, :talk, :title].include?key }.with_indifferent_access
      end
    end

    context "after reaching registration deadline" do
      before {
        Timecop.travel(Registration::REGISTRATION_DEADLINE+10.minutes)
      }
      after {
        Timecop.return
      }
      it "returns empty params" do
        params = ActionController::Parameters.new registration: {}.merge(registration_full_params)
        permitted_params = RegistrationsController::RegistrationParams.permit(params)
        expect(permitted_params).to be_empty
      end
    end

    context "after reaching dormitory limit" do
      before {
        Timecop.travel(Registration::POSTER_DEADLINE-10.minutes)
        50.times {create :registration, paid: true, dormitory: true}
      }
      after {
        Timecop.return
      }
      it "returns the full params" do
        params = ActionController::Parameters.new registration: {}.merge(registration_full_params)
        permitted_params = RegistrationsController::RegistrationParams.permit(params)
        expect(permitted_params).to eq registration_full_params.delete_if{|key, value| [:dormitory].include?(key) }.with_indifferent_access
      end
    end

    context "after reaching dinner limit" do
      before {
        Timecop.travel(Registration::POSTER_DEADLINE-10.minutes)
        Registration::DINNER_CAPACITY.times {create :registration, paid: true, dinner_category_name: 'student'}
      }
      after {
        Timecop.return
      }
      it "returns the full params" do
        params = ActionController::Parameters.new registration: {}.merge(registration_full_params)
        permitted_params = RegistrationsController::RegistrationParams.permit(params)
        expect(permitted_params).to eq registration_full_params.delete_if{|key, value| [:dinner_category_name, :vegetarian].include?(key) }.with_indifferent_access
      end
    end
  end
end
