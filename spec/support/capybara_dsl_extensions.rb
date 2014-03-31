module CapybaraDSLExtensions
  include Capybara::DSL

  def select_option_value(option_value, options = {})
    field_name = options.fetch(:from)

    find("##{field_name} option[value='#{option_value}']").select_option
  end
end
