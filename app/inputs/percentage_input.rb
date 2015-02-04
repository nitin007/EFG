class PercentageInput < SimpleForm::Inputs::StringInput
  def input(wrapper_options)
    unit = '%'

    input_html_options[:maxlength] = 6
    input_html_options[:placeholder] = '0.0'
    input_html_options[:value] = @builder.object.send(attribute_name)

    merged_input_options = merge_wrapper_options(input_html_options, wrapper_options)

    template.content_tag(:div, class: 'input-group') do
      @builder.text_field(attribute_name, merged_input_options) +
      template.content_tag(:span, unit, class: 'input-group-addon')
    end
  end
end
