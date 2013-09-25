class RegistrationsController < ApplicationController

  respond_to :html

  def create
    @registration = Registration.new registration_params
    respond_with @registration do |format|
      if @registration.save
        session[:registration_id] = @registration.id
        flash[:success] = "Please confirm your data"
        @booking = @registration.booking
        format.html { redirect_to confirm_registration_path(@registration) }
        # flash[:success] = "Registration successfull"
        # format.html { redirect_to root_path }
      else
        @speakers = Speaker.order(:last_name, :first_name)
        @grouped_events = Event.order(:start).group_by{|e| e.start.to_date}
        # flash.now[:danger] = "Registration failed. Please check for any errors in your submitted data."
        format.html { render "home/show"}
      end
    end
  end

  def confirm
    @registration = Registration.find params[:id]
    if !@registration.paid && session[:registration_id] == @registration.id
      respond_with @registration do |f|
        f.html {render layout: false}
      end
    else
      respond_with @registration do |f|
        flash[:error] = "You can't access this registration"
        f.html {redirect_to root_path}
      end
    end
  end

  def edit
    @registration = Registration.find params[:id]
    if !@registration.paid && session[:registration_id] == @registration.id
      @speakers = Speaker.order(:last_name, :first_name)
      @grouped_events = Event.order(:start).group_by{|e| e.start.to_date}
      respond_with @registration do |f|
        f.html {render "home/show"}
      end
    else
      respond_with @registration do |f|
        flash[:error] = "You can't access this registration"
        f.html {redirect_to root_path}
      end
    end
  end

  private
    def registration_params
      params.require(:registration).permit(:first_name, :last_name, :email, :category_name, :institute, :address, :city, :zip_code, :country, :title, :authors, :body, :talk)
    end
end
