class RegistrationsController < ApplicationController

  respond_to :html
  protect_from_forgery :except => [:callback]
  before_filter :check_session_var, only: [:edit, :update, :confirm]

  def create
    @registration = Registration.new RegistrationParams.permit(params)
    if @registration.save
      @registration.reload
      session[:registration_id_token] = @registration.id_token
      respond_with @registration do |format|
        format.html { redirect_to confirm_registration_path(@registration)}
      end
    else
      @speakers = Speaker.order(:last_name, :first_name)
      @grouped_events = Event.order(:start).group_by{|e| e.start.to_date}
      @countries = (Country.find_all_countries_by_subregion('Northern America')+Country.find_all_countries_by_region('Europe')).uniq.sort_by(&:name)
      respond_with @registration do |format|
        format.html { render "home/show"}
      end
    end
  end

  def edit
    # check_session_var before_filter
    @speakers = Speaker.order(:last_name, :first_name)
    @grouped_events = Event.order(:start).group_by{|e| e.start.to_date}
    @countries = (Country.find_all_countries_by_subregion('Northern America')+Country.find_all_countries_by_region('Europe')).uniq.sort_by(&:name)

    respond_with @registration do |f|
      f.html {render "home/show"}
    end
  end

  def update
    if @registration.update RegistrationParams.permit(params)
      respond_with @registration do |format|
        format.html { redirect_to confirm_registration_path(@registration) }
      end
    else
      @speakers = Speaker.order(:last_name, :first_name)
      @grouped_events = Event.order(:start).group_by{|e| e.start.to_date}
      @countries = (Country.find_all_countries_by_subregion('Northern America')+Country.find_all_countries_by_region('Europe')).uniq.sort_by(&:name)
      respond_with @registration do |format|
        format.html { render "home/show"}
      end
    end
  end

  def confirm
    respond_with @registration do |f|
      f.html {render layout: false}
    end
  end

  def callback
    @callback = Registration.booking_callback request
    if @callback.valid?
      session.delete(:registration_id_token)
      @callback.bookable.mark_as_paid
      flash[:success] = "Payment successfull! We are looking forward to see you in Geneva soon."
    else
      flash[:error] = "A problem occurred with your payment. Please contact the organizers of the conference."
    end
    respond_to do |format|
      format.html {redirect_to root_path}
    end
  end

  def callback_test
    @registration = Registration.find params[:id]
    @uni_id = "226-#{@registration.timestamp_id}"
    @mhash = BookingCallback.hashize(@registration.timestamp_id)
  end

  private
    def check_session_var
      @registration = Registration.find params[:id]
      if @registration.paid || (session[:registration_id_token].to_s != @registration.reload.id_token.to_s)
        flash[:error] = "You can't access this registration"
        respond_with @registration do |f|
          f.html {redirect_to root_path}
        end
      end
    end


  class RegistrationParams
    def self.permit(params)
      if Time.now < Registration::POSTER_DEADLINE
        params.require(:registration).permit(:first_name, :last_name, :email, :category_name, :dinner_category_name, :dormitory, :institute, :address, :city, :zip_code, :country, :title, :authors, :body, :talk, :vegetarian, :poster_agreement)
      elsif Time.now < Registration::REGISTRATION_DEADLINE
        params.require(:registration).permit(:first_name, :last_name, :email, :category_name, :dinner_category_name, :dormitory, :institute, :address, :city, :zip_code, :country, :vegetarian)
      else
        {}
      end
    end
  end
end
