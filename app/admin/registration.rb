ActiveAdmin.register Registration do
  controller do
    def permitted_params
      params.permit(:registration => [:first_name, :last_name, :email, :category_name, :institute, :address, :city, :zip_code, :country, :title, :authors, :body, :talk])
    end
  end

  filter :first_name
  filter :last_name
  filter :email
  filter :category_name
  filter :institute
  filter :address
  filter :city
  filter :zip_code
  filter :country

  index do
    column :first_name
    column :last_name
    column :email
    column :category_name
    column :institute
    column :address
    column :city
    column :zip_code
    column :country
    column :paid
    default_actions
  end

  show do |registration|
    attributes_table do
      row :first_name
      row :last_name
      row :email
      row :category_name
      row :institute
      row :address
      row :zip_code
      row :city
      row :country
      row :talk
      row :title
      row :authors
      row :body
    end
    active_admin_comments
  end

  form do |f|
    f.inputs "Details" do
      f.input :first_name
      f.input :last_name
      f.input :email
      f.input :category_name, as: :select, collection: Registration.categories.map(&:name), include_blank: false
    end
    f.inputs "Affiliation" do
      f.input :institute
      f.input :address
      f.input :zip_code
      f.input :city
      f.input :country
    end
    f.inputs "Abstract" do |f|
      f.input :talk
      f.input :title
      f.input :authors
      f.input :body
    end
    f.actions
  end
end
