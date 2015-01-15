class DataCorrection < LoanModification
  include FormatterConcern

  Formatters = {
    dti_demand_outstanding: MoneyFormatter.new,
    dti_interest: MoneyFormatter.new,
    dti_amount_claimed: MoneyFormatter.new,
    facility_letter_date: SerializedDateFormatter,
    facility_letter_date: SerializedDateFormatter,
    postcode: PostcodeFormatter,
    trading_date: SerializedDateFormatter,
  }

  serialize :data_correction_changes, JSON

  def old_lending_limit_id
    lending_limit(:first)
  end

  def lending_limit_id
    lending_limit(:last)
  end

  def data_correction_changes=(changes)
    changes.each do |(key, values)|
      formatter = Formatters.fetch(key.to_sym, DefaultFormatter)
      changes[key][1] = formatter.parse(values.last)
    end
    super(changes)
  end

  def data_correction_changes
    @corrections ||= correction_details
  end

  def old_repayment_frequency
    RepaymentFrequency.find(old_repayment_frequency_id)
  end

  def repayment_frequency
    RepaymentFrequency.find(repayment_frequency_id)
  end

  def changes
    data_correction_changes.map do |attribute_name, changes|
      new_attribute_name = attribute_name.sub(/_id$/, '')
      old_attribute_name = "old_#{new_attribute_name}"
      {
        old_attribute: old_attribute_name,
        old_value: self.public_send("old_#{attribute_name}"),
        attribute: new_attribute_name,
        value: self.public_send(attribute_name),
      }
    end
  end

  private

  def lending_limit(first_or_last)
    limit_id = data_correction_changes['lending_limit_id'].try(first_or_last)
    LendingLimit.find_by_id(limit_id)
  end

  def correction_details
    corrections = (read_attribute(:data_correction_changes) || {})
    corrections.each_with_object({}) do |(key, values), memo|
      formatter = Formatters.fetch(key.to_sym, DefaultFormatter)
      memo[key] = []
      memo[key][0] = formatter.format(values.first)
      memo[key][1] = formatter.format(values.last)
    end
  end

  def method_missing(method, *args, &block)
    is_old = !!(method =~ /^old_/)
    change_key = method.to_s.gsub(/^old_/, '')
    if data_correction_changes.try(:has_key?, change_key)
      values = data_correction_changes[change_key]
      is_old ? values.first : values.last
    else
      super
    end
  end

end
