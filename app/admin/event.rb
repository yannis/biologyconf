ActiveAdmin.register Event do

  controller do
    def permitted_params
      params.permit(:event => [:title, :speaker_name, :speaker_affiliation, :start, :end, :classes, :kind])
    end
  end

  filter :title
  filter :speaker_name
  filter :speaker_affiliation
  filter :start
  filter :end
  filter :kind

  index do
    column :title
    column :speaker_name
    column :speaker_affiliation
    column :start
    column :end
    column :classes
    column :kind
    default_actions
  end

  form :partial => "form"
end
