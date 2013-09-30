class RegistrationsController < ApplicationController

  respond_to :html
  protect_from_forgery :except => [:callback]

  def create
    @registration = Registration.new registration_params
    if @registration.save
      session[:registration_id] = @registration.id_token
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

  def confirm
    @registration = Registration.find params[:id]
    if !@registration.paid && session[:registration_id] == @registration.id_token
      respond_with @registration do |f|
        f.html {render layout: false}
      end
    else
      flash[:error] = "You can't access this registration"
      respond_with @registration do |f|
        f.html {redirect_to root_path}
      end
    end
  end

  def callback
    @registration = Booking.check_callback request
    if @registration
      @registration.mark_as_paid
      flash[:success] = "Payment successfull! We are looking forward to see you in Geneva soon."
    else
      flash[:error] = "A problem occurred with your payment. Please contact the organizers of the conference."
    end
    respond_with @registration do |f|
      f.html {redirect_to root_path}
    end
  end

  def edit
    @registration = Registration.find params[:id]
    if !@registration.paid && session[:registration_id] == @registration.id_token
      @speakers = Speaker.order(:last_name, :first_name)
      @grouped_events = Event.order(:start).group_by{|e| e.start.to_date}
      respond_with @registration do |f|
        f.html {render "home/show"}
      end
    else
      flash[:error] = "You can't access this registration"
      respond_with @registration do |f|
        f.html {redirect_to root_path}
      end
    end
  end

  def update
    @registration = Registration.find params[:id]
    redirect_to(root_path, warning: "You don't have access to this registration") && return if session[:registration_id] != @registration.id_token
    if @registration.update registration_params
      flash[:success] = "Please confirm your data"
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

  private
    def registration_params
      params.require(:registration).permit(:first_name, :last_name, :email, :category_name, :institute, :address, :city, :zip_code, :country, :title, :authors, :body, :talk)
    end
end
