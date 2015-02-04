class QuickDateInput < SimpleForm::Inputs::Base
  def input(wrapper_options)
    date = @builder.object.send(attribute_name)

    input_html_options[:placeholder] = 'dd/mm/yyyy'
    input_html_options[:value] = date && date.to_s(:screen)

    merged_input_options = merge_wrapper_options(input_html_options, wrapper_options)

    template.content_tag(:div) do
      @builder.text_field(attribute_name, merged_input_options)
    end
  end
end
