class Admin::RegistrationsPdf < Prawn::Document
  def initialize(registrations)
    super(page_layout: :portrait)
    # inconsolata_font
    # start_new_page :layout => :landscape

    # bounding_box [bounds.left + 0, bounds.top-40], width: 700 do
    #


    registrations.order(:last_name).each_with_index do |registration, i|
      bounding_box [bounds.left, bounds.top-50], width: 100 do
        logo = "#{Rails.root}/app/assets/images/pdf_banner.png"
        image logo, :at => [450,60], width: 100
      end
      bounding_box [bounds.left, bounds.top-50], :width => 540 do
        font_size 12
        start_new_page unless i == 0
        text "<em>Abstract submitted by</em> #{registration.full_name} (#{registration.institute})", inline_format: true
        font_size 18
        move_down font.height
        text registration.title
        move_down font.height
        font_size 12
        text "<i>#{registration.authors}</i>", inline_format: true
        move_down font.height
        text registration.formatted_body, inline_format: true
      end
    end
  end
end
