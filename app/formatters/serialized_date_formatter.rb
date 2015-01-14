class SerializedDateFormatter < QuickDateFormatter
  def self.format(value)
    Date.parse(value)
  end

  def self.parse(value)
    super.to_s
  end
end
