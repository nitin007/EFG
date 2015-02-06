class DedCodeInput < SimpleForm::Inputs::Base
  def input(wrapper_options)
    merged_input_options = merge_wrapper_options(input_html_options, wrapper_options)

    @builder.select(attribute_name, options.delete(:select_options), input_options, merged_input_options)
  end
end
