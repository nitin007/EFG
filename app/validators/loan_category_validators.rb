class LoanCategoryValidators
  include ActiveModel::Validations

  CategoryBValidators = [
    PercentageValidator.new(attribute: :security_proportion, minimum: 0.1, maximum: 99.9),
    SecurityTypesValidator.new({})
  ].freeze

  CategoryCValidators = [
    PercentageValidator.new(attribute: :original_overdraft_proportion, minimum: 0.1, maximum: 99.9),
    PercentageValidator.new(attribute: :refinance_security_proportion, minimum: 0.1, maximum: 100.0)
  ].freeze

  CategoryDValidators = [
    PercentageValidator.new(attribute: :refinance_security_proportion, minimum: 0.1, maximum: 100.0),
    PresenceValidator.new(attributes: [ :current_refinanced_amount, :final_refinanced_amount ])
  ].freeze

  CategoryEValidators = [
    PresenceValidator.new(attributes: :loan_sub_category_id),
    PresenceValidator.new(attributes: :overdraft_limit),
    InclusionValidator.new(attributes: :overdraft_maintained, in: [ true ])
  ].freeze

  CategoryFValidators = [
    PresenceValidator.new(attributes: :invoice_discount_limit),
    PercentageValidator.new(attribute: :debtor_book_coverage, minimum: 1.0, maximum: 99.9),
    PercentageValidator.new(attribute: :debtor_book_topup, minimum: 1.0, maximum: 30.0)
  ].freeze

  def self.for_category(loan_category_id)
    {
      2 => CategoryBValidators,
      3 => CategoryCValidators,
      4 => CategoryDValidators,
      5 => CategoryEValidators,
      6 => CategoryFValidators,
      7 => CategoryEValidators,
      8 => CategoryFValidators
    }.fetch(loan_category_id, [])
  end

end
