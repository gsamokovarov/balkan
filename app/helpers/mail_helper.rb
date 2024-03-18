module MailHelper
  def first_name(name) = name.split.first
  def format_money(amount) = Kernel.format "€%0.2f", amount
end
