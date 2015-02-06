class DurationInput < SimpleForm::Inputs::Base
  def input(wrapper_options)
    duration = @builder.object.send(attribute_name)

    merged_input_options = merge_wrapper_options(input_html_options, wrapper_options)

    template.content_tag(:div, class: 'input-group col-xs-10') do
      @builder.fields_for(attribute_name, duration) do |duration_fields|
        duration_fields.text_field(:years, merged_input_options) + add_on('years') + ' ' +
        duration_fields.text_field(:months, merged_input_options) + add_on('months')
      end
    end
  end

  private
  def add_on(name)
    name = ERB::Util.html_escape(name)
    %Q{<span class="input-group-addon">#{name}</span>}.html_safe
  end
end
