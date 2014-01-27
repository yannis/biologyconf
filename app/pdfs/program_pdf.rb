
class ProgramPdf < Prawn::Document
  def initialize
    super(page_layout: :portrait, page_size: 'A4')

    bounding_box [bounds.left-20,bounds.top+15], width: 150 do
      font_size 24
      text "Programme"
    end

    bounding_box [bounds.right-130,bounds.top-20], width: 150 do
      logo = "#{Rails.root}/app/assets/images/pdf_banner.png"
      image logo, at: [0,50], width: 150
    end

    grouped_events = Event.order(:start).group_by{|e| e.start.to_date}

    top = bounds.top
    grouped_events.each do |date, events|
      leftb = (date == grouped_events.keys.first ? 0 : 285)
      bounding_box [bounds.left-15+leftb, top-28], width: 270 do
        font_size 18
        text date.to_s(:day_month_year)
        data = events.map do|event|
          details = "<strong>#{event.title}</strong>"
          details += "\n#{event.speaker_name} – #{event.speaker_affiliation}" if event.speaker_name
          ["#{event.start.to_s(:time_only)}", details]
        end
        table(data, cell_style: { inline_format: true, size: 8 }) do
          cells.borders = []
          cells.padding = 0
          cells.padding_top = 0
          cells.padding_bottom = 6
          column(0).width = 30
          column(0).font_style = :bold
          row(0..-1).borders = [:bottom]
          row(0..-1).border_color = "b3b3b3"
          row(0..-1).border_width = 0.5
          row(-1).border_width = 0
          column(0).border_width = 0
        end
      end
    end
  end
end



# class ProgramPdf < Prawn::Document
#   def initialize
#     super(page_layout: :portrait, page_size: 'A4')

#     bounding_box [bounds.left-20,bounds.top+15], width: 150 do
#       font_size 24
#       text "Program"
#     end

#     bounding_box [bounds.right-130,bounds.top-20], width: 150 do
#       logo = "#{Rails.root}/app/assets/images/pdf_banner.png"
#       image logo, at: [0,50], width: 150
#     end

#     grouped_events = Event.order(:start).group_by{|e| e.start.to_date}

#     top = bounds.top
#     grouped_events.each do |date, events|
#       leftb = (date == grouped_events.keys.first ? 0 : 285)
#       bounding_box [bounds.left-15+leftb, top-28], width: 270 do
#         font_size 18
#         text date.to_s(:day_month_year)
#         data = events.map do|event|
#           details = "<strong>#{event.title}</strong>"
#           details += "\n#{event.speaker_name} (#{event.speaker_affiliation})" if event.speaker_name
#           ["#{event.start.to_s(:time_only)}", details]
#         end
#         table(data, cell_style: { inline_format: true, size: 8 }) do
#           cells.borders = []
#           cells.padding = 0
#           cells.padding_top = 0
#           cells.padding_bottom = 6
#           column(0).width = 30
#           column(0).font_style = :bold
#           row(0..-1).borders = [:bottom]
#           row(0..-1).border_color = "b3b3b3"
#           row(0..-1).border_width = 0.5
#           row(-1).border_width = 0
#           column(0).border_width = 0
#         end
#       end
#     end
#   end
# end
