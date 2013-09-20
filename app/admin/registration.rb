ActiveAdmin.register Registration do
  controller do
    def permitted_params
      params.permit(:registration => [:first_name, :last_name, :email, :category, :institute, :address, :city, :zip_code, :country, abstract_attributes: [:title, :authors, :body, :talk, :registration_id]])
    end
  end

  filter :first_name
  filter :last_name
  filter :email
  filter :category
  filter :institute
  filter :address
  filter :city
  filter :zip_code
  filter :country

  index do
    column :first_name
    column :last_name
    column :email
    column :category
    column :institute
    column :address
    column :city
    column :zip_code
    column :country
    default_actions
  end

  show do |speaker|
    attributes_table do
      row :first_name
      row :last_name
      row :email
      row :category
      row :institute
      row :address
      row :zip_code
      row :city
      row :country
    end
    attributes_table_for speaker.abstract do
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
      f.input :category, as: :select, collection: Registration.categories.map(&:name), include_blank: false
    end
    f.inputs "Affiliation" do
      f.input :institute
      f.input :address
      f.input :zip_code
      f.input :city
      f.input :country
    end
    f.inputs "Abstract", :for => [:abstract, f.object.abstract || Abstract.new] do |af|
      af.input :talk
      af.input :title
      af.input :authors
      af.input :body
    end
    f.actions
  end
end
