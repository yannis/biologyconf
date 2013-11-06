require 'acts_as_bookable'
ActiveAdmin.register Registration do
  controller do
    def permitted_params
      params.permit(:registration => [:first_name, :last_name, :email, :category_name, :dinner_category_name, :dormitory, :institute, :address, :city, :zip_code, :country, :title, :authors, :body, :talk, :vegetarian, :poster_agreement])
    end
  end

  filter :first_name
  filter :last_name
  filter :email
  filter :category_name
  filter :institute
  # filter :address
  # filter :city
  # filter :zip_code
  filter :country
  filter :talk
  filter :poster_agreement
  filter :paid

  index do
    column :full_name, sortable: :last_name
    column :email
    column :category_name
    column :institute
    # column :address
    # column :city
    # column :zip_code
    # column :country
    column :talk
    column :poster_agreement
    column "Abstract title", sortable: :title do |registration|
      registration.title
    end
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
      row :poster_agreement
      row :dinner_category_name do
        registration.dinner_category.details if registration.dinner_category
      end
      row :vegetarian
      row :talk
      row :poster_agreement
      row :title
      row :authors
      row :body do
        registration.body.html_safe
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
      f.input :poster_agreement
      f.input :title
      f.input :authors
      f.input :body
    end
    f.actions
  end
end
