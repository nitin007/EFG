class LenderSelectInput < SimpleForm::Inputs::Base
  def input
    @builder.collection_check_boxes(attribute_name, collection, value_method, label_method, input_options, input_html_options) do |builder|
      builder.check_box + builder.text
    end
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
end