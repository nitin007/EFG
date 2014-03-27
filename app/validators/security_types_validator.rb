class SecurityTypesValidator < BaseValidator
	
  def validate(record)
    if record.loan_security_types.empty?
      add_error(record, :loan_security_types) 
    end
  end

end
