class ReceiptsController < ApplicationController
  layout "receipts"

  def show
    @receipt = Receipt.find_by_token_for! :receipt_access, params[:id]
  end
end
