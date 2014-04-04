module PostcodeFormatter
  def self.format(value)
    Postcode.new(value)
  end

  def self.parse(value)
    case value
    when Postcode
      value.to_s
    else
      Postcode.new(value).to_s
    end
  end
end
