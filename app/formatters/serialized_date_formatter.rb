class SerializedDateFormatter
  def self.format(value)
    Date.parse(value)
  end

  def self.parse(value)
    QuickDateFormatter.parse(value).to_s
  end
end
