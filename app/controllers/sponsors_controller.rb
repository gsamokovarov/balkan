class SponsorsController < ApplicationController
  def prospectus
    pdf = SponsorshipProspectus.generate Current.event
    filename = "#{Current.event.name.parameterize}-sponsorship-prospectus.pdf"

    send_data pdf, disposition: "attachment", type: "application/pdf", filename:
  end
end
