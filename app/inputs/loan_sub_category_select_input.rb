class LoanSubCategorySelectInput < SimpleForm::Inputs::Base
  def input(wrapper_options)
    unless options[:loan_category_id]
      raise ArgumentError, 'Please specify the :loan_category_id'
    end

    input_options[:prompt] = 'Please select'

    merged_input_options = merge_wrapper_options(input_html_options, wrapper_options)

    @builder.collection_select(attribute_name, select_options, :id, :name, input_options, merged_input_options)
  end

  private

  def select_options
    LoanSubCategory.all.select { |s| s.loan_category_id == options[:loan_category_id] }
  end
end
