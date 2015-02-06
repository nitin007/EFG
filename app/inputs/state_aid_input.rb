# encoding: utf-8
class StateAidInput < CurrencyInput
  def input(wrapper_options)
    options[:unit] = '€'
    input_html_options[:disabled] = true

    super + @builder.button(:submit, 'State Aid Calculation', class: 'btn btn-info col-xs-offset-1 col-xs-5')
  end

  private

  def input_grid_class
    'col-xs-6'
  end
end
