module MailHelper
  BRAND_PALETTES =
    Rails.root.join("app/assets/tailwind/application.css").read
      .gsub(%r{/\*.*?\*/}m, "")
      .scan(/\.theme-(\d+)\s*\{(.*?)\}/m)
      .to_h { |id, css| [id.to_i, css.scan(/--brand-([\w-]+):\s*(#\h{6})/).to_h] }

  def brand_palette(theme_id = 1) = BRAND_PALETTES[1].merge BRAND_PALETTES.fetch(theme_id, {})
  def first_name(name) = name.split.first
  def format_money(amount) = Kernel.format "€%0.2f", amount
end
