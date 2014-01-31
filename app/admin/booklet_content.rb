ActiveAdmin.register BookletContent do

  controller do

    def permitted_params
      params.permit(:booklet_content => [:identifier, :title, :title_size, :text])
    end
  end

  filter :identifier

  index do
    column :identifier
    column :title
    column :title_size
    default_actions
  end

  show do |registration|
    attributes_table do
      row :identifier
      row :title
      row :title_size
      row :text
    end
    active_admin_comments
  end

end
