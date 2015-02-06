# encoding: utf-8

class CurrencyInput < SimpleForm::Inputs::StringInput
  def input(wrapper_options)
    unit = options[:unit] || '£'

    input_html_options[:type] = 'text'
    input_html_options[:value] = @builder.object.send(attribute_name)

    template.content_tag(:div, class: 'input-group col-xs-7') do
      template.content_tag(:span, unit, class: 'input-group-addon') + super
    end
  end
end
