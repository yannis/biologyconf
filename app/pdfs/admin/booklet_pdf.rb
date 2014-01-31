class Admin::BookletPdf < Prawn::Document

  attr_accessor :program_page, :welcome_page, :venue_room_page, :venue_restaurant_page, :keynote_speakers_page, :info_page, :talk_abstract_page, :poster_abstract_page

  def initialize
    super(page_layout: :portrait)
    font "Helvetica"

    self.program
    self.welcome
    self.venue_room
    self.venue_restaurant
    self.keynote_speakers
    self.info
    self.talk_abstracts
    self.poster_abstracts
    self.toc

    page_count.times do |i|

      font_size 10
      go_to_page(i+1)

      # header
      bounding_box [bounds.left, bounds.top-50], width: 100 do
        logo = "#{Rails.root}/app/assets/images/pdf_banner.png"
        image logo, :at => [450,60], width: 100
      end

      # footer
      bounding_box [bounds.right-20, bounds.bottom+10], width: 50 do
        # text "#{i+1} / #{page_count}"
        text "#{i+1}"
      end
    end
  end

  def toc
    font "Helvetica"
    go_to_page(1)
    bounding_box [bounds.left, bounds.top-50], width: 540 do
      font_size 24
      text "Table of content"
      move_down font_size
      font_size 18
      text "Program: #{self.program_page}"
      text "Welcome: #{self.welcome_page}"
      text "Conference venue: #{self.venue_room_page}"
      text "Darwin dinner: #{self.venue_restaurant_page}"
      text "General informations: #{self.info_page}"
      text "Keynote speakers: #{self.keynote_speakers_page}"
      text "Talk abstracts: #{self.talk_abstract_page}"
      text "Poster abstracts: #{self.poster_abstract_page}"
    end
  end

  def program
    start_new_page
    self.program_page = page_count

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

  def welcome
    welcome = BookletContent.where(identifier: 'welcome').first

    start_new_page
    self.welcome_page = page_count
    bounding_box [bounds.left, bounds.top-220], width: 540 do
      font_size welcome.title_size
      text welcome.title
    end
    column_box [bounds.left, bounds.top-260], width: 540, columns: 2 do
      # font "Times-Roman"
      font_size 12
      text welcome.text
    end
  end

  def venue_room
    map = BookletContent.where(identifier: 'venue_room').first
    start_new_page
    self.venue_room_page = page_count
    bounding_box [bounds.left, bounds.top-30], width: 540 do
      font_size map.title_size
      text map.title
      move_down font_size
      font_size 12
      text map.text
      map = "#{Rails.root}/app/assets/images/venue_room.png"
      image map, :at => [80,y-650], width: 400
    end
  end

  def venue_restaurant
    map = BookletContent.where(identifier: 'venue_restaurant').first
    start_new_page
    self.venue_restaurant_page = page_count
    bounding_box [bounds.left, bounds.top-30], width: 540 do
      font_size map.title_size
      text map.title
      move_down font_size
      font_size 12
      text map.text
      map = "#{Rails.root}/app/assets/images/venue_restaurant.png"
      image map, :at => [80,y-650], width: 400
    end
  end

  def keynote_speakers
    keynote_speakers = [
      BookletContent.where(identifier: "ks_leake").first,
      BookletContent.where(identifier: "ks_antonelli").first,
      BookletContent.where(identifier: "ks_tautz").first,
      BookletContent.where(identifier: "ks_ibelings").first,
      BookletContent.where(identifier: "ks_gouyon").first
    ]
    start_new_page
    self.keynote_speakers_page = page_count
    bounding_box [bounds.left, bounds.top-50], width: 540 do
      font_size 24
      text "Keynote speakers"
      keynote_speakers.each do |speaker|
        font_size speaker.title_size
        move_down font_size
        text speaker.title
        font_size 12
        text speaker.text, inline_format: true
      end
    end
  end

  def info
    infos = [
      BookletContent.where(identifier: "info_lunch").first,
      BookletContent.where(identifier: "info_internet").first,
      BookletContent.where(identifier: "info_poster").first,
      BookletContent.where(identifier: "info_prizes").first,
      BookletContent.where(identifier: "info_meeting").first
    ]
    start_new_page
    self.info_page = page_count
    bounding_box [bounds.left, bounds.top-50], width: 540 do
      font_size 24
      text "General information"
      infos.each do |info|
        font_size info.title_size
        move_down font_size
        text info.title
        font_size 12
        text info.text, inline_format: true
      end
    end
  end

  def talk_abstracts
    self.talk_abstract_page = page_count+1
    talk_registrations = Registration.includes(:event).where(paid: true).where("registrations.selected_as_talk = 1 AND registrations.body IS NOT NULL AND registrations.body != ''").order("events.start ASC")
    abstracts talk_registrations, "Talk abstracts"
  end

  def poster_abstracts
    self.poster_abstract_page = page_count+1
    poster_registrations = Registration.where(paid: true).where("registrations.poster_number IS NOT NULL AND registrations.body IS NOT NULL AND registrations.body != ''").order(:poster_number)
    abstracts poster_registrations, "Poster abstracts"
  end

  def abstracts(registrations, title="A title")
    font "Helvetica"
    bounding_box [bounds.left, bounds.top-50], width: 540 do
      start_new_page
      font_size 24
      text title
    end

    registrations.each_slice(2).with_index do |(a,b), i|
      start_new_page unless i==0
      tb = (i==0 ? 100 : 30)
      bounding_box [bounds.left, bounds.top-tb], width: 540 do
        [a,b].each_with_index do |registration, i|
          font "Helvetica"
          stroke_horizontal_rule if i == 1
          move_down font.height
          font_size 10
          if registration.poster_number.present?
            text "Poster #{registration.poster_number}"
          else
            text("<i>#{registration.event.start.to_s(:day_month_year_hour_minute)}–#{registration.event.end.to_s(:time_only)}</i>", inline_format: true) if registration.event
          end
          move_down font.height
          font_size 12
          text registration.title, style: :bold
          move_down font.height
          text registration.authors
          font_size 11
          text "#{registration.institute}, #{registration.city}", style: :italic
          move_down font.height
          font "Times-Roman"
          text registration.formatted_body, inline_format: true
          move_down font.height if i==0
        end
      end
    end

  end
end
