module BasicDataCorrectable
  extend ActiveSupport::Concern

  included do
    before_save :update_loan

    cattr_accessor :attribute_name
  end

  module ClassMethods
    def data_corrects(attribute_name, opts = {})
      self.attribute_name = attribute_name

      attr_accessor attribute_name
      attr_accessible attribute_name

      unless opts[:skip_validation]
        validates attribute_name, presence: true
      end
    end
  end

  def change_type
    "ChangeType::#{attribute_name.to_s.classify}".constantize
  end

  private

  def update_loan
    loan.public_send("#{attribute_name}=", attribute_value)
  end

  def attribute_name
    self.class.attribute_name
  end

  def attribute_value
    public_send(attribute_name)
  end

end
