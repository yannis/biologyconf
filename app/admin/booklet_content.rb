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
    link_to("See booklet", booklet_admin_booklet_contents_path)
  end

  action_item only: :index do
    link_to("Regenerate publicly available booklet", booklet_admin_booklet_contents_path(add_cover: true, save_it: true), title: "booklet available at /system/booklet/biology14_booklet.pdf")
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
    add_cover = (params[:add_cover] == 'true')
    save_it = (params[:save_it] == 'true')
    Rails.logger.info "params: #{params}"
    # filename = "booklet_#{Date.current.to_s}.pdf"
    filename = "biology14_booklet.pdf"
    file_path = "#{Rails.root}/public/system/booklet/#{filename}"
    pdf = Admin::BookletPdf.new({add_cover: add_cover, save_it: save_it})
    if save_it
      pdf.render_file file_path
      redirect_to "/system/booklet/#{filename}"
    else
      send_data pdf.render, filename: filename, type: "application/pdf", disposition: "inline", page_size: 'A4'
    end
  end
end
