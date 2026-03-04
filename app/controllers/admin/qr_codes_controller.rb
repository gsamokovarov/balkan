class Admin::QrCodesController < Admin::ApplicationController
  def show
  end

  def create
    @url = params[:url]
    @qrcode_svg = RQRCode::QRCode.new(@url).as_svg(use_path: true, viewbox: true) if @url.present?

    render :show
  end
end
