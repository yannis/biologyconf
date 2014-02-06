class Admin::BookletPdf < Prawn::Document

  attr_accessor :program_page, :welcome_page, :venue_room_page, :venue_restaurant_page, :keynote_speakers_page, :info_page, :talk_abstract_page, :poster_abstract_page, :participants_page, :dosee_page, :going_out_page

  FONT_HEADING = "Domus"
  FONT_HEADING_SIZE = 24
  FONT_BODY = "HelveticaNeue"
  FONT_BODY_SIZE = 10
  FONT_SANSERIF = "HelveticaNeue"


  def initialize
    super(page_layout: :portrait, margin: 0, page_size: 'A4')
    font_families.update(
      "Domus" => {
        normal: "#{ENV["FONT_PATH"]}/DomusTitling-Regular.ttf",
        bold: "#{ENV["FONT_PATH"]}/DomusTitling-Bold.ttf",
        medium: "#{ENV["FONT_PATH"]}/DomusTitling-Medium.ttf",
        extrabold: "#{ENV["FONT_PATH"]}/DomusTitling-Extrabold.ttf"
      },
      "HelveticaNeue" => {
        normal: "#{ENV["FONT_PATH"]}/HelveticaNeue.ttf",
        bold: "#{ENV["FONT_PATH"]}/HelveticaNeue-Bold.ttf",
        light: "#{ENV["FONT_PATH"]}/HelveticaNeue-Light.ttf",
        italic: "#{ENV["FONT_PATH"]}/HelveticaNeue-Italic.ttf",
        light_italic: "#{ENV["FONT_PATH"]}/HelveticaNeue-LightItalic.ttf"
      }
    )
    font FONT_BODY

    # self.program
    # self.welcome
    # self.venue_room
    # self.info
    # self.keynote_speakers
    # self.keynote_speakers2
    self.talk_abstracts
    self.poster_abstracts
    self.participants
    self.dosee
    self.going_out

    self.toc

    page_count.times do |i|

      font_size 10
      go_to_page(i+1)

      even = ((i+1)%2 == 0)

      # header
      bounding_box [(even ? bounds.left+30 : bounds.right-130), bounds.top-20], width: 100 do
        logo = "#{Rails.root}/app/assets/images/pdf_banner_nb.png"
        image logo, at: [0,0], width: 100
      end

      # footer
      bounding_box [(even ? bounds.left+30 : bounds.right-50), bounds.bottom+30], width: 20 do
        font FONT_HEADING
        text "#{i+1}", align: (even ? :left : :right)
      end
    end
    # self.concat "#{Rails.root}/lib/assets/bookletCover.pdf"

    # self.cover
  end

  def cover
    go_to_page 0
    start_new_page size: 'A3', layout: :landscape
    bounding_box [bounds.left, bounds.top], width: 1190.55 do
      cover = "#{Rails.root}/lib/assets/bookletCover.png"
      image cover, at: [0,0], width: 1190.55
    end
  end

  def toc
    go_to_page(1)
    bounding_box [bounds.left+207.28, bounds.top-520], width: 348 do
      self.title "Table of content"
      font_size 12
      move_down font_size
      md = font_size/3
      font FONT_BODY, style: :light
      self.set_toc "Programme", self.program_page
      move_down md
      self.set_toc "Welcome", self.welcome_page
      move_down md
      self.set_toc "Conference venue", self.venue_room_page
      move_down md
      self.set_toc "General informations", self.info_page
      move_down md
      self.set_toc "Keynote speakers", self.keynote_speakers_page
      move_down md
      self.set_toc "Talk abstracts", self.talk_abstract_page
      move_down md
      self.set_toc "Poster abstracts", self.poster_abstract_page
      move_down md
      self.set_toc "List of participants", self.participants_page
      move_down md
      self.set_toc "Things to see/do", self.dosee_page
      move_down md
      self.set_toc "Going out", self.going_out_page
    end
  end

  # def program
  #   start_new_page
  #   self.program_page = page_count
  #   events = Event.where("events.start < DATE('2014-02-14')").order(:start)
  #   oriented_bounding_box [nil, bounds.top-70] do
  #     title "13 February program"
  #     move_down font_size
  #     font "Helvetica"
  #     font_size FONT_BODY_SIZE
  #     data = events.map do|event|
  #       details = "<b>#{event.title}</b>"
  #       details += "\n#{event.speaker_name} – #{event.speaker_affiliation}" if event.speaker_name
  #       ["<font size='12'>#{event.start.to_s(:time_only)}</font>", details]
  #     end
  #     table(data, cell_style: { inline_format: true, size: 9 }) do
  #       cells.borders = []
  #       cells.padding = 0
  #       cells.padding_top = 3
  #       cells.padding_bottom = 5
  #       column(0).width = 40
  #       column(0).font = FONT_HEADING
  #       column(0).font_style = :medium
  #       row(0..-1).borders = [:bottom]
  #       row(0..-1).border_color = "b3b3b3"
  #       row(0..-1).border_width = 0.5
  #       row(-1).border_width = 0
  #       column(0).border_width = 0
  #       column(0).padding = 0
  #     end
  #   end
  # end

  # def program2
  #   start_new_page
  #   self.program_page = page_count
  #   events = Event.where("events.start > DATE('2014-02-14')").order(:start)
  #   oriented_bounding_box [nil, bounds.top-70] do
  #     title "14 February program"
  #     move_down font_size
  #     font "Helvetica"
  #     font_size FONT_BODY_SIZE
  #     data = events.map do|event|
  #       details = "<b>#{event.title}</b>"
  #       details += "\n#{event.speaker_name} – #{event.speaker_affiliation}" if event.speaker_name
  #       ["<font size='12'>#{event.start.to_s(:time_only)}</font>", details]
  #     end
  #     table(data, cell_style: { inline_format: true, size: 9 }) do
  #       cells.borders = []
  #       cells.padding = 0
  #       cells.padding_top = 3
  #       cells.padding_bottom = 5
  #       column(0).width = 40
  #       column(0).font = FONT_HEADING
  #       column(0).font_style = :medium
  #       row(0..-1).borders = [:bottom]
  #       row(0..-1).border_color = "b3b3b3"
  #       row(0..-1).border_width = 0.5
  #       row(-1).border_width = 0
  #       column(0).border_width = 0
  #       column(0).padding = 0
  #     end
  #   end
  # end

  def program
    start_new_page
    self.program_page = page_count
    grouped_events = Event.order(:start).group_by{|e| e.start.to_date}

    top = bounds.top
    grouped_events.each do |date, events|
      leftb = (date == grouped_events.keys.first ? 30 : 295)
      bounding_box [bounds.left+leftb, top-60], width: 255 do
        font_size 18
        font FONT_HEADING, style: :bold
        text date.to_s(:day_month_year)
        font "Helvetica"
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

  def welcome
    start_new_page
    welcome = BookletContent.where(identifier: 'welcome').first
    self.welcome_page = page_count
    oriented_bounding_box [bounds.left+20, bounds.top-300] do
      self.title welcome.title
    end
    oriented_column_box [bounds.right-530, bounds.top-350], columns: 2, height: 390 do
      font FONT_BODY, style: :light
      font_size FONT_BODY_SIZE
      text welcome.text, inline_format: true
    end
  end

  def venue_room
    map = BookletContent.where(identifier: 'venue_room').first
    start_new_page
    self.venue_room_page = page_count
    oriented_bounding_box [nil, bounds.top-130] do
      self.title map.title
      move_down font_size
      font FONT_BODY
      font_size FONT_BODY_SIZE
      text map.text
      map = "#{Rails.root}/app/assets/images/venue_room_nb.png"
      image map, at: [30,y-660], width: 400
    end
  end

  # def venue_restaurant
  #   map = BookletContent.where(identifier: 'venue_restaurant').first
  #   start_new_page
  #   self.venue_restaurant_page = page_count
  #   oriented_bounding_box [nil, bounds.top-200] do
  #     self.title map.title
  #     move_down font_size
  #     font FONT_BODY
  #     font_size FONT_BODY_SIZE
  #     text map.text
  #     map = "#{Rails.root}/app/assets/images/venue_restaurant.png"
  #     image map, at: [0,y-480], width: 500
  #   end
  # end

  def keynote_speakers
    keynote_speakers = [
      BookletContent.where(identifier: "ks_leake").first,
      BookletContent.where(identifier: "ks_antonelli").first,
      BookletContent.where(identifier: "ks_tautz").first
    ]
    start_new_page
    self.keynote_speakers_page = page_count
    oriented_bounding_box [nil, bounds.top-130] do
      self.title "Keynote speakers"
    end
    oriented_bounding_box [nil, bounds.top-160]  do
      keynote_speakers.each do |speaker|
        move_down FONT_HEADING_SIZE
        font FONT_HEADING
        font_size 18
        text speaker.title
        font FONT_BODY, style: :light
        font_size FONT_BODY_SIZE
        text speaker.text, inline_format: true
      end
    end
  end

  def keynote_speakers2
    keynote_speakers = [
      BookletContent.where(identifier: "ks_ibelings").first,
      BookletContent.where(identifier: "ks_gouyon").first
    ]
    start_new_page
    oriented_bounding_box [nil, bounds.top-160]  do
      keynote_speakers.each do |speaker|
        move_down FONT_HEADING_SIZE
        font FONT_HEADING
        font_size 18
        text speaker.title
        font FONT_BODY, style: :light
        font_size FONT_BODY_SIZE
        text speaker.text, inline_format: true
      end
    end
  end

  def info
    infos1 = [
      BookletContent.where(identifier: "info_lunch").first,
      BookletContent.where(identifier: "info_internet").first
    ]
    infos2 = [
      BookletContent.where(identifier: "info_prizes").first,
      BookletContent.where(identifier: "info_meeting").first
    ]
    posters = BookletContent.where(identifier: "info_poster").first
    darwin = BookletContent.where(identifier: "info_darwin").first
    start_new_page
    self.info_page = page_count
    oriented_bounding_box [nil, bounds.top-130] do
      title "General information"
      infos1.each do |info|
        font FONT_HEADING
        font_size 18
        move_down font_size
        text info.title
        font_size FONT_BODY_SIZE
        font FONT_BODY, style: :light
        text info.text, inline_format: true
      end
    end
    start_new_page
    oriented_bounding_box [nil, bounds.top-130] do
      font FONT_HEADING
      font_size 18
      move_down font_size
      text posters.title
      font_size FONT_BODY_SIZE
      font FONT_BODY, style: :light
      text posters.text, inline_format: true
      map = "#{Rails.root}/app/assets/images/venue_poster_300_nb.png"
      image map, at: [0,y-590], width: 460
    end
    oriented_bounding_box [nil, bounds.top-580] do
      infos2.each do |info|
        font FONT_HEADING
        font_size 18
        move_down font_size
        text info.title
        font_size FONT_BODY_SIZE
        font FONT_BODY, style: :light
        text info.text, inline_format: true
      end
    end
    start_new_page
    oriented_bounding_box [nil, bounds.top-130] do
      font FONT_HEADING
      font_size 18
      move_down font_size
      text darwin.title
      font_size FONT_BODY_SIZE
      font FONT_BODY, style: :light
      text darwin.text, inline_format: true
      map = "#{Rails.root}/app/assets/images/venue_restaurant_nb.png"
      image map, at: [0,y-650], width: 460
    end
  end

  def talk_abstracts
    self.talk_abstract_page = page_count+1
    talk_registrations = Registration.includes(:event).where(paid: true).where("registrations.selected_as_talk = 1 AND registrations.body IS NOT NULL AND registrations.body != ''").order("events.start ASC")
    abstracts talk_registrations, "Talk abstracts"
  end

  def poster_abstracts
    self.poster_abstract_page = page_count+1
    poster_registrations = Registration.where("registrations.poster_number IS NOT NULL").order(:poster_number)
    abstracts poster_registrations, "Poster abstracts"
  end

  def abstracts(registrations, atitle="A title")
    start_new_page
    oriented_bounding_box [nil, bounds.top-80] do
      title atitle
    end

    registrations.each_slice(2).with_index do |(a,b), i|
      start_new_page unless i==0
      [a,b].each_with_index do |registration, j|
        if [a.title.length, a.authors.length, a.formatted_body.length, b.title.length, b.authors.length, b.formatted_body.length].sum > 4200 && j == 1
          start_new_page
          abstract registration, 1, 0
        else
          abstract registration, i, j
        end
      end
    end
  end

  def abstract(registration, i, j)
    if registration
      if i == 0 && j == 0
        tb = font_size
      elsif j == 0
        tb = 80
      else
        tb = font_size
      end
      oriented_bounding_box [nil, y-tb] do
        font FONT_HEADING
        font_size 12
        if j == 1
          stroke do
            stroke_color "7f7f7f"
            stroke_horizontal_rule
          end
          move_down font_size
        end
        if registration.poster_number.present?
          text "poster n° #{registration.poster_number}"
        else
          text("#{registration.event.start.to_s(:day_month_hour_minute)} – #{registration.event.end.to_s(:time_only)}", inline_format: true) if registration.event
        end
        text registration.title, style: :bold, inline_format: true
        move_down font_size
        font FONT_BODY
        text registration.authors
        font_size 10
        text registration.institute, style: :italic
        move_down font_size
        font FONT_BODY, style: :light
        text registration.formatted_body, inline_format: true
      end
    end
  end
  # def abstracts(registrations, atitle="A title")
  #   start_new_page
  #   oriented_bounding_box [nil, bounds.top-80] do
  #     title atitle
  #   end

  #   registrations.each_slice(2).with_index do |(a,b), i|
  #     start_new_page unless i==0
  #     tb = (i==0 ? 100 : 50)
  #     oriented_bounding_box [nil, bounds.top-tb], height: 700 do
  #       [a,b].each_with_index do |registration, i|
  #         if registration
  #           if i == 1
  #             stroke do
  #               stroke_color "7f7f7f"
  #               stroke_horizontal_rule
  #             end
  #             move_down font_size
  #           end
  #           move_down font_size
  #           font FONT_HEADING
  #             font_size 12
  #           if registration.poster_number.present?
  #             text registration.poster_number.to_s
  #           else
  #             text("#{registration.event.start.to_s(:day_month_hour_minute)} – #{registration.event.end.to_s(:time_only)}", inline_format: true) if registration.event
  #           end
  #           # move_down font_size/2
  #           text registration.title, style: :bold
  #           move_down font_size
  #           font FONT_BODY
  #           text registration.authors
  #           font_size 10
  #           text "#{registration.institute}, #{registration.city}", style: :italic
  #           move_down font_size
  #           font FONT_BODY, style: :light
  #           text registration.formatted_body, inline_format: true
  #           move_down font_size*2 if i==0
  #         end
  #       end
  #     end
  #   end
  # end

  def abstracts_vert(registrations, atitle="A title")
    start_new_page
    oriented_bounding_box [nil, bounds.top-80] do
      title atitle
    end

    registrations.each_slice(2).with_index do |(a,b), i|
      start_new_page unless i==0
      tb = (i==0 ? 150 : 80)
      oriented_bounding_box [nil, bounds.top-tb] do
        [a,b].each_with_index do |registration, i|
          if registration
            leftb = (i==0 ? 0 : 235)
            bounding_box [leftb, bounds.top], width: 225 do
              font FONT_HEADING
              font_size 18
              if registration.poster_number.present?
                text registration.poster_number.to_s, style: :bold
              else
                text("<i>#{registration.event.start.to_s(:day_month_hour_minute)} – #{registration.event.end.to_s(:time_only)}</i>", inline_format: true) if registration.event
              end
              move_down font_size
              font FONT_HEADING
              font_size 12
              text registration.title, style: :bold
              move_down font_size
              font FONT_BODY
              text registration.authors
              font_size 10
              text "#{registration.institute}, #{registration.city}", style: :italic
              move_down font_size
              font FONT_BODY, style: :light
              text registration.formatted_body, inline_format: true
            end
          end
        end
      end
    end
  end

  def participants
    map = BookletContent.where(identifier: 'participants').first
    registrations = Registration.where(paid: true).order(:last_name)
    start_new_page
    self.participants_page = page_count
    oriented_bounding_box [nil, bounds.top-80], height: 100 do
      font FONT_HEADING
      font_size FONT_HEADING_SIZE
      text map.title, style: :bold
      move_up font_size/2
      font FONT_BODY
      font_size FONT_BODY_SIZE
      text map.text, style: :light
      move_down font_size
      stroke do
        stroke_color "7f7f7f"
        stroke_horizontal_rule
      end
    end
    registrations.each_slice(28).with_index do |regs, i|
      tb = 130
      if i==0
        tb = 150
      else
        start_new_page
      end
      data = regs.map{|registration| [registration.full_name, registration.institute, registration.email]}
      oriented_bounding_box [nil, bounds.top-tb], height: 670 do
        font FONT_BODY, style: :light
        font_size FONT_BODY_SIZE
        table(data, cell_style: { inline_format: true, size: 10 }) do
          cells.borders = []
          cells.padding = 3
          cells.padding_top = 1
          cells.padding_bottom = 4
          column(0).width = 100
          column(-1).width = 150
          column(0).font_style = :bold
          row(0..-1).borders = [:bottom]
          row(0..-1).border_color = "b3b3b3"
          row(0..-1).border_width = 0.5
          row(-1).border_width = 0
          # column(0).border_width = 0
        end
      end
    end
  end



  #   data = Registration.where(paid: true).order(:last_name).map{|registration| [registration.full_name, registration.institute, registration.email]}
  #   oriented_bounding_box [nil, bounds.top-100], height: 640 do
  #     title map.title
  #     move_down font_size
  #     font FONT_BODY, style: :light
  #     font_size FONT_BODY_SIZE
  #     # text map.text
  #     table(data, cell_style: { inline_format: true, size: 10 }) do
  #       cells.borders = []
  #       cells.padding = 5
  #       cells.padding_top = 2
  #       cells.padding_bottom = 6
  #       column(0).width = 120
  #       column(-1).width = 160
  #       column(0).font_style = :bold
  #       row(0..-1).borders = [:bottom]
  #       row(0..-1).border_color = "b3b3b3"
  #       row(0..-1).border_width = 0.5
  #       row(-1).border_width = 0
  #       # column(0).border_width = 0
  #     end
  #   end
  # end

  def dosee
    start_new_page
    dosee = BookletContent.where(identifier: 'dosee').first
    self.dosee_page = page_count
    oriented_bounding_box [nil, bounds.top-80], height: 100 do
      font FONT_HEADING
      font_size FONT_HEADING_SIZE
      text dosee.title, style: :bold
      move_up font_size/2
      font FONT_BODY
      font_size FONT_BODY_SIZE
      text "Modified from http://www.geneva.info/sights", style: :light
      move_down font_size
      stroke do
        stroke_color "7f7f7f"
        stroke_horizontal_rule
      end
    end
    oriented_bounding_box [nil, bounds.top-140], height: 600 do
      move_down font_size
      font FONT_BODY, style: :light
      font_size FONT_BODY_SIZE
      text dosee.text, inline_format: true
    end
  end

  def going_out
    start_new_page
    going_out = BookletContent.where(identifier: 'going_out').first
    self.going_out_page = page_count
    oriented_bounding_box [nil, bounds.top-100], height: 600 do
      title going_out.title
      move_down font_size
      font FONT_BODY, style: :light
      font_size FONT_BODY_SIZE
      text going_out.text, inline_format: true
    end
  end

  def self.concat(pdf_file)
    if File.exists?(pdf_file)
      pdf_temp_nb_pages = self.new(template: pdf_file).page_count
      (1..pdf_temp_nb_pages).each do |i|
        self.start_new_page(template: pdf_file, template_page: i)
      end
    end
  end

  def title(title_text="", size=FONT_HEADING_SIZE)
    font FONT_HEADING
    font_size size
    text title_text, style: :bold
    stroke do
      stroke_color "7f7f7f"
      stroke_horizontal_rule
    end
  end

  def set_toc(text, number, total=62)
    text "#{text}"
    ts = 95-(text.length/2)-(text.length/1.3)
    float do
      move_up font_size+2
      text( ("  "+number.to_s).rjust(ts, "."), align: :right)
    end
  end

  def oriented_bounding_box(point, options={}, &block)
    options[:width] = 460
    points = [page_count%2 == 0 ? bounds.left+50 : bounds.right-510, point.last]
    bounding_box points, options do
      yield
    end
  end

  def oriented_column_box(point, options={}, &block)
    options[:width] = 460
    points = [page_count%2 == 0 ? bounds.left+50 : bounds.right-510, point.last]
    column_box points, options do
      yield
    end
  end

end
