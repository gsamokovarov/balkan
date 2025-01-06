class Admin::InvoiceSequencesController < Admin::ApplicationController
  def index
    @invoice_sequences = InvoiceSequence.all
  end
end
