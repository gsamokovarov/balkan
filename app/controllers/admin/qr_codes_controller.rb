class Admin::QrCodesController < Admin::ApplicationController
  allow_staff_to :create

  def show = nil

  def create
    @url = params[:url]
    @qrcode_svg = RQRCode::QRCode.new(@url).as_svg(use_path: true, viewbox: true) if @url.present?

    render :show
  end
end
