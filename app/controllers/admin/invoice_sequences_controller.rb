class Admin::InvoiceSequencesController < Admin::ApplicationController
  def index
    @invoice_sequences = scope InvoiceSequence.all
  end
end
