class RegistrationsController < ApplicationController

  respond_to :html
  protect_from_forgery :except => [:callback]
  before_filter :check_session_var, only: [:edit, :update, :confirm]

  def create
    @registration = Registration.new registration_params
    if @registration.save
      session[:registration_id_token] = @registration.id_token
      respond_with @registration do |format|
        format.html { redirect_to confirm_registration_path(@registration)}
      end
    else
      @speakers = Speaker.order(:last_name, :first_name)
      @grouped_events = Event.order(:start).group_by{|e| e.start.to_date}
      respond_with @registration do |format|
        format.html { render "home/show"}
      end
    end
  end

  def edit
    # check_session_var before_filter
    @speakers = Speaker.order(:last_name, :first_name)
    @grouped_events = Event.order(:start).group_by{|e| e.start.to_date}
    respond_with @registration do |f|
      f.html {render "home/show"}
    end
  end

  def update
    if @registration.update registration_params
      respond_with @registration do |format|
        format.html { redirect_to confirm_registration_path(@registration) }
      end
    else
      @speakers = Speaker.order(:last_name, :first_name)
      @grouped_events = Event.order(:start).group_by{|e| e.start.to_date}
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
    @callback = BookingCallback.new request
    if @callback.valid?
      session.delete(:registration_id_token)
      @callback.registration.mark_as_paid
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
    @uni_id = "226-#{@registration.id_token}"
    @mhash = BookingCallback.hashize(@registration.id_token)
  end

  private
    def registration_params
      params.require(:registration).permit(:first_name, :last_name, :email, :category_name, :dinner_category_name, :dormitory, :institute, :address, :city, :zip_code, :country, :title, :authors, :body, :talk)
    end

    def check_session_var
      @registration = Registration.find params[:id]
      if @registration.paid || session[:registration_id_token] != @registration.id_token
        flash[:error] = "You can't access this registration"
        respond_with @registration do |f|
          f.html {redirect_to root_path}
        end
      end
    end
end
