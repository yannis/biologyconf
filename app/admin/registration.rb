require 'acts_as_bookable'
ActiveAdmin.register Registration do

  controller do

    before_filter :only => :index do
      @per_page = 1000 if request.format == 'application/pdf'
    end


    def permitted_params
      params.permit(:registration => [:first_name, :last_name, :email, :category_name, :dinner_category_name, :dormitory, :institute, :address, :city, :zip_code, :country, :title, :authors, :body, :talk, :selected_as_talk, :vegetarian, :poster_agreement, :poster_number])
    end

    def index
      index! do |format|
        format.pdf do
          pdf = Admin::RegistrationsPdf.new(collection)
          send_data pdf.render, filename: "registrations_#{Date.current.to_s}",
                                type: "application/pdf",
                                disposition: "inline",
                                page_size: 'A4'
        end
      end
    end
  end

  filter :first_name
  filter :last_name
  filter :email
  filter :category_name, as: :select, multiple: true, collection: proc{ Registration.uniq.pluck :category_name }
  filter :institute
  filter :country
  filter :title
  filter :authors
  filter :body
  filter :paid
  filter :talk, as: :select, collection: [true,false]
  filter :selected_as_talk, label: "Selected as tak by admin"
  filter :poster_agreement
  filter :poster_number
  filter :dormitory
  filter :vegetarian
  filter :dinner_category_name, as: :select, multiple: true, collection: proc{ Registration.uniq.pluck :dinner_category_name }

  index download_links: [:csv, :xml, :json, :pdf] do
    column :full_name, sortable: :last_name
    column :email
    column :category_name
    column :institute
    column :talk
    column :selected_as_talk
    column :poster_agreement
    column "Abstract title", sortable: :title do |registration|
      registration.title
    end
    column :poster_number
    column :dinner_category_name, sortable: :dinner_category_name do |registration|
      registration.dinner_category.details if registration.dinner_category
    end
    column :vegetarian
    column :dormitory
    column :paid do |registration|
      registration.paid_fee if registration.paid
    end
    default_actions
  end

  show do |registration|
    attributes_table do
      row :first_name
      row :last_name
      row :email
      row :category_name do
        registration.category.details.html_safe if registration.category
      end
      row :institute
      row :address
      row :zip_code
      row :city
      row :country
      row :talk
      row :selected_as_talk
      row :poster_agreement
      row :poster_number
      row :dinner_category_name do
        registration.dinner_category.details if registration.dinner_category
      end
      row :vegetarian
      row :talk
      row :poster_agreement
      row :title do
        registration.title.html_safe if registration.title
      end
      row :authors
      row :body do
        registration.body.html_safe if registration.body
      end
      row :paid do
        registration.paid ? "#{registration.paid_fee} CHF" : "no"
      end
      row "Booking datatrans id" do
        "#{registration.uni_id} #{"(might not exist)" unless registration.paid}"
      end
    end
    active_admin_comments
  end

  form do |f|
    f.inputs "Details" do
      f.input :first_name
      f.input :last_name
      f.input :email
      f.input :category_name, as: :select, collection: Registration.categories.map{|c| [sanitize(c.details), c.name]}, include_blank: false
    end
    f.inputs "Affiliation" do
      f.input :institute
      f.input :address
      f.input :zip_code
      f.input :city
      f.input :country
    end
    f.inputs "Dinner" do
      f.input :dinner_category_name, as: :select, collection: Registration.dinner_categories.map{|c| [c.details, c.name]}, include_blank: true
    end

    f.inputs "Abstract" do
      f.input :talk
      f.input :selected_as_talk
      f.input :poster_agreement
      poster_numbers = (1..60).to_a-Registration.select(:poster_number).map(&:poster_number)
      poster_numbers << f.object.poster_number if f.object.poster_number
      f.input :poster_number, as: :select, collection: poster_numbers.sort.map{|i| [i,i]}, include_blank: true
      f.input :title
      f.input :authors
      f.input :body
    end

    f.inputs "Payment" do
      f.input :paid
      f.input :paid_fee
    end
    f.actions
  end
end
