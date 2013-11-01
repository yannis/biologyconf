
class ProgramPdf < Prawn::Document
  def initialize
    super(page_layout: :portrait)
    # inconsolata_font
    # start_new_page :layout => :landscape

    # bounding_box [bounds.left + 0, bounds.top-40], :width => 700 do
    #

    bounding_box [bounds.left, bounds.top-50], :width => 200 do
      logo = "#{Rails.root}/app/assets/images/pdf_banner.png"
      image logo, :at => [0,50], :width => 200
      font_size 24
      text "program"
    end

    # text "This <i>includes <b>inline</b></i> <font size='24'>formatting</font>", :inline_format => true
    grouped_events = Event.order(:start).group_by{|e| e.start.to_date}

    grouped_events.each do |date, events|
      leftb = date == grouped_events.keys.first ? 0 : 270

      bounding_box [bounds.left+leftb, bounds.top-100], width: 250 do
        font_size 24
        text date.to_s(:day_month_year)
        data = events.map{|event| ["#{event.start.to_s(:time_only)} – #{event.end.to_s(:time_only)}", event.title] }
        table(data, :cell_style => { :inline_format => true, size: 10 }) do
          cells.borders = []
          row(0..-1).borders = [:bottom]
          row(0..-1).border_width = 0.5
          row(-1).border_width = 0
          # row(0).borders = [:bottom]
          # row(0).border_width = 2
          # row(0).font_style = :bold
          # row(-1).borders = [:top]
          # row(-1).border_width = 1
          # row(-1).font_style = :bold
        end
      end
    end



  #   bounding_box [bounds.left+10, bounds.top-300], :width => 600 do
  #     text "Nous certifions avoir reçu la somme de #{@user.bill(:chf)} CHF / #{@user.bill(:eur)} EUR.".html_safe
  #     data = [
  #       [ "Nom",
  #         "Compétition",
  #         "Diner",
  #         "Dortoire",
  #         "Total"
  #       ]
  #     ]

  #     for enrollment in @user.enrollments
  #       data << [
  #         enrollment.last_name.titleize,
  #         "#{enrollment.competition_fee(:chf)} CHF / #{enrollment.competition_fee(:eur)} €",
  #          "#{enrollment.dinner_fee(:chf)} CHF / #{enrollment.dinner_fee(:eur)} €",
  #          "#{enrollment.dormitory_fee(:chf)} CHF / #{enrollment.dormitory_fee(:eur)} €",
  #          "<b>#{enrollment.bill(:chf)} CHF / #{enrollment.bill(:eur)} EUR</b>"
  #       ]
  #     end
  #     data << [nil, nil, nil, nil, "<b>#{@user.bill(:chf)} CHF / #{@user.bill(:eur)} EUR</b>"]

  #     table(data, :cell_style => { :inline_format => true, size: 12 }, width: 550) do
  #       cells.borders = []
  #       row(0).borders = [:bottom]
  #       row(0).border_width = 2
  #       row(0).font_style = :bold
  #       row(-1).borders = [:top]
  #       row(-1).border_width = 1
  #       row(-1).font_style = :bold
  #     end

  #     bounding_box [bounds.left, bounds.bottom-20], :width => 700 do
  #       text "Avec tous nos remerciements,"

  #       text "Le comité d'organisation de la coupe Kasahara"
  #     end
  #   end
  end
end
