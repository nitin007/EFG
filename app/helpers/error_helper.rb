module ErrorHelper

  def render_errors_on_base(errors)
    unless errors[:base].empty?
      content_tag(:ul, class: 'errors-on-base') do
        errors[:base].collect { |error| content_tag :li, error }.join.html_safe
      end
    end
  end

  def render_attribute_errors(form, *attribute_names)
    html = attribute_names.collect do |attribute|
      if form.object.errors.include?(attribute)
        content_tag :div, class: "form-group error" do
          content_tag :div, class: "col-sm-12" do
            content_tag :div, class: "help-inline" do
              form.object.errors[attribute].join(', ')
            end
          end
        end
      end
    end

    return if html.empty?

    html.join('')
  end

end
