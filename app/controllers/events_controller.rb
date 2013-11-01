class EventsController < ApplicationController

  respond_to :pdf

  def index
    pdf = ProgramPdf.new
    send_data pdf.render, filename: "biology14_program_#{Date.current.to_s}",
                          type: "application/pdf",
                          disposition: "inline",
                          page_size: 'A4'
  end
end
