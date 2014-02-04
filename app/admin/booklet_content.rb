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

  action_item only: :index do
    link_to("Booklet", booklet_admin_booklet_contents_path)
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

  collection_action :booklet do
    pdf = Admin::BookletPdf.new
    send_data pdf.render, filename: "booklet_#{Date.current.to_s}",
                          type: "application/pdf",
                          disposition: "inline",
                          page_size: 'A4'
  end
end
