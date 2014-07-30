class LenderSelectInput < SimpleForm::Inputs::Base
  AllOption = OpenStruct.new(id: 'ALL', name: 'All')

  def input
    output = ActiveSupport::SafeBuffer.new

    output << '<label class="checkbox">'.html_safe
    output << template.check_box_tag("#{object_name}[#{attribute_name}][]", AllOption.id, all_selected)
    output << AllOption.name
    output << '</label>'.html_safe

    output << '<hr>'.html_safe

    output << @builder.collection_check_boxes(attribute_name, collection, value_method, label_method,
        input_options, input_html_options) do |builder|
      builder.check_box + builder.text
    end

    output
  end

  private

  def collection
    @collection ||= options.delete(:collection).to_a
  end

  def input_options
    super.merge(item_wrapper_tag: :label, item_wrapper_class: 'checkbox')
  end

  def label_method
    :name
  end

  def value_method
    :id
  end

  def item_wrapper_class
    "checkbox"
  end

  def all_selected
    Set.new(collection.map(&value_method)) == Set.new(object.send(attribute_name))
  end
end
