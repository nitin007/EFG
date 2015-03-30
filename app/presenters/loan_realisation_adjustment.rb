class LoanRealisationAdjustment
  include ActiveModel::Validations

  attr_accessor :created_by, :notes
  attr_reader :amount, :date

  validates_presence_of :amount
  validates_presence_of :date

  validate do
    errors.add(:amount, :greater_than, count: 0) unless amount.cents > 0
    errors.add(:amount, :not_greater_than_adjusted_realisations) if amount > loan.cumulative_adjusted_realised_amount
  end

  def initialize(loan, attributes = {})
    @loan = loan
    self.amount = attributes['amount']
    self.date = attributes['date']
    self.notes = attributes['notes']
  end

  def amount=(value)
    @amount = Money.parse(value)
  end

  def date=(value)
    @date = QuickDateFormatter.parse(value)
  end

  def save
    return false if invalid?

    loan.realisation_adjustments.create! do |realisation_adjustment|
      realisation_adjustment.amount = amount
      realisation_adjustment.created_by = created_by
      realisation_adjustment.date = date
      realisation_adjustment.notes = notes
    end
  end

  # ActiveModel compliance.
  def self.model_name; ActiveModel::Name.new(self, nil, 'RealisationAdjustment'); end
  def persisted?; false; end
  def to_key; nil; end

  private
    attr_reader :loan
end
