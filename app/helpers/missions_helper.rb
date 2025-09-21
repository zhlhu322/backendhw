module MissionsHelper
  def render_error(f, column)
    field_html = capture do
      yield
    end

    error_html = ""
    if f.object.errors[column].any?
      error_html = content_tag(:span, f.object.errors[column].first, class: "error")
    end

    field_html + error_html
  end
end
