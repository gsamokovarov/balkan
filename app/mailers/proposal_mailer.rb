class ProposalMailer < ApplicationMailer
  def selected(proposal)
    @proposal = proposal

    mail to: @proposal.email, subject: "Your talk has been selected for #{proposal.event.name}"
  end

  def waitlisted(proposal)
    @proposal = proposal

    mail to: @proposal.email, subject: "Your #{proposal.event.name} proposal update"
  end
end
