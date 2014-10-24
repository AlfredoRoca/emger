module ApplicationHelper
  def localize_date(date)
    I18n.l date, format: "%d/%m/%Y %a, %H:%M" if date
  end
end
