class RegistrationsController < ApplicationController

  respond_to :html

  def create
    @registration = Registration.new registration_params

    respond_with @registration do |format|
      if @registration.save
        flash[:success] = "Registration successfull"
        format.html { redirect_to root_path }
      else
        @grouped_events = Event.order(:start).group_by{|e| e.start.to_date}
        @registration.abstract ||= Abstract.new()
        # flash.now[:danger] = "Registration failed. Please check for any errors in your submitted data."
        format.html { render "home/show"}
      end
    end
  end

  private
    def registration_params
      params.require(:registration).permit(:first_name, :last_name, :email, :institute, :address, :city, :zip_code, :country, abstract_attributes: [:title, :authors, :body, :talk, :registration_id])
    end
end
