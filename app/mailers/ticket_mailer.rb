class TicketMailer < ApplicationMailer
  def welcome_email(ticket)
    @ticket = ticket
    @ticket_png = ticket.qrcode.as_png size: 240

    attachments["balkan_ruby_ticket.png"] = @ticket_png.to_s
    attachments["balkan_ruby_event.ics"] = calendar_event ticket

    mail to: @ticket.email, subject: "Welcome to Balkan Ruby!"
  end

  def ticket_email(ticket)
    @ticket = ticket
    @ticket_png = ticket.qrcode.as_png size: 240

    attachments["balkan_ruby_ticket.png"] = @ticket_png.to_s

    mail to: @ticket.email, subject: "Your ticket for Balkan Ruby"
  end

  private

  def calendar_event(ticket)
    calendar = Icalendar::Calendar.new
    calendar.event do |e|
      e.dtstart = Icalendar::Values::Date.new ticket.event.start_date
      e.dtend = Icalendar::Values::Date.new ticket.event.end_date
      e.url = "https://balkanruby.com"
      e.location = "Bulgaria Blvd, 1463 Ndk, Sofia, Bulgaria"
      e.organizer = "mailto:genadi@balkanruby.com"
      e.summary = "Balkan Ruby"
      e.description = "Balkan Ruby is back to business! April 26–27, 2024 in Sofia, Bulgaria"
    end

    calendar.to_ical
  end
end
