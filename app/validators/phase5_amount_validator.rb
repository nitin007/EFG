class Phase5AmountValidator < Validator

  def validate
    if amount.blank?
      add_error(:amount, :allowed_amount)
    elsif !amount.between?(Money.new(1_000_00), Money.new(1_000_000_00))
      add_error(:amount, :allowed_amount)
    end
  end

  private

  delegate :amount, to: :object

end
