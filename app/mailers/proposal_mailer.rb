class ProposalMailer < ApplicationMailer
  def submitted(proposal)
    @proposal = proposal

    mail to: @proposal.email, subject: "Your #{proposal.event.name} proposal has been received"
  end

  def selected(proposal)
    @proposal = proposal

    mail to: @proposal.email, subject: "Your talk has been accepted for #{proposal.event.name}"
  end

  def waitlisted(proposal)
    @proposal = proposal

    mail to: @proposal.email, subject: "Your #{proposal.event.name} proposal update"
  end
end
