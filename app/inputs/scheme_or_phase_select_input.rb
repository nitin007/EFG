class SchemeOrPhaseSelectInput < SimpleForm::Inputs::Base
  def input(wrapper_options)
    merged_input_options = merge_wrapper_options(input_html_options, wrapper_options)

    @builder.select(attribute_name, select_options, input_options, merged_input_options)
  end

  private
  def select_options
    phase_options = Phase.all.collect { |phase| [phase.name, phase.id] }

    template.options_for_select([['', ''], ['SFLG', Loan::SFLG_SCHEME]]) +
    template.grouped_options_for_select({'EFG' => phase_options})
  end
end
