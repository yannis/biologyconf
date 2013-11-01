ActiveAdmin.register Speaker do
  controller do
    def permitted_params
      params.permit(:speaker => [:first_name, :last_name, :title, :description, :url, :portrait])
    end
  end

  filter :first_name
  filter :last_name
  filter :description

  index do
    column :title
    column :first_name
    column :last_name
    column :description do |speaker|
      truncate(speaker.description, :length => 100)
    end
    column :url
    column "Portrait" do |speaker|
      image_tag(speaker.portrait.url(:thumb))
    end
    default_actions
  end

  show do |speaker|
    attributes_table do
      row :title
      row :first_name
      row :last_name
      row :description
      row :url
      row :portrait do
        image_tag(speaker.portrait.url(:thumb))
      end
    end
    active_admin_comments
  end

  form do |f|
    f.inputs "Headline Details" do
      f.input :first_name
      f.input :last_name
      f.input :title, as: :select, collection: Speaker::TITLE, include_blank: false
      f.input :description
      f.input :url
      f.input :portrait, :hint => f.template.image_tag(f.object.portrait.url(:thumb))
    end
    f.actions
  end

end
