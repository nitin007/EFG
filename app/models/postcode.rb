class Postcode
  delegate :full?, to: :uk_postcode

  def initialize(value)
    @uk_postcode = UKPostcode.new(value || '')
  end

  def ==(other)
    to_s == other.to_s
  end

  alias_method :eql?, :==

  def inspect
    "<Postcode raw:#{raw}>"
  end

  def to_s
    normalised = norm
    normalised.empty? ? raw : normalised
  end

  private
    attr_reader :uk_postcode

    delegate :norm, :raw, to: :uk_postcode
end
