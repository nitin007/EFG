module BasicDataCorrectable
  extend ActiveSupport::Concern

  included do
    before_save :update_data_correction
    before_save :update_loan

    cattr_accessor :attribute_name
  end

  module ClassMethods
    def data_corrects(attribute_name)
      self.attribute_name = attribute_name

      attr_accessor attribute_name
      attr_accessible attribute_name

      validates attribute_name, presence: true
    end
  end

  private

  def update_data_correction
    data_correction.change_type = change_type_class
    data_correction.public_send("#{attribute_name}=", attribute_value)
    data_correction.public_send("old_#{attribute_name}=", loan.public_send(attribute_name))
  end

  def update_loan
    loan.public_send("#{attribute_name}=", attribute_value)
  end

  def attribute_name
    self.class.attribute_name
  end

  def attribute_value
    public_send(attribute_name)
  end

  def change_type_class
    "ChangeType::#{attribute_name.to_s.classify}".constantize
  end

end
