class SponsorsController < ApplicationController
  def show
    @sponsor = Sponsor.find params[:id]
    @job_postings = @sponsor.job_postings.for Current.event
  end

  def prospectus
    pdf = SponsorshipProspectus.generate Current.event
    filename = "#{Current.event.name.parameterize}-sponsorship-prospectus.pdf"

    send_data pdf, disposition: "attachment", type: "application/pdf", filename:
  end
end
