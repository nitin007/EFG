class DedCodeInput < SimpleForm::Inputs::Base
  def input(wrapper_options)
    @builder.select(attribute_name, options.delete(:select_options), input_options, input_html_options)
  end
end
