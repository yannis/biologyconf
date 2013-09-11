ActiveAdmin.register Event do

  controller do
    #...
    def permitted_params
      params.permit(:event => [:title, :start, :end, :classes, :kind])
    end
  end

  index do
    column :title
    column :start
    column :end
    column :classes
    column :kind
    default_actions
  end

  form :partial => "form"

  # form do |f|
  #   f.input :title
  #   f.input :start, :as => :date_picker
  #   f.input :end, :as => :date_picker
  #   f.input :classes
  #   f.input :kind
  #   f.actions
  # end

end
