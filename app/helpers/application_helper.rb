module ApplicationHelper
  include Pagy::Frontend

  def page_title
    @page_title || AppConfig[:app_name]
  end

  def page_description
    @page_description
  end
end
