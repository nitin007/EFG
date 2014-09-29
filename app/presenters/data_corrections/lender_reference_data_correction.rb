class LenderReferenceDataCorrection < DataCorrectionPresenter
  attr_accessor :lender_reference
  attr_accessible :lender_reference

  before_save :update_data_correction
  before_save :update_loan

  validates :lender_reference, presence: true

  private
    def update_data_correction
      data_correction.change_type = ChangeType::LenderReference
      data_correction.lender_reference = lender_reference
      data_correction.old_lender_reference = loan.lender_reference
    end

    def update_loan
      loan.lender_reference = lender_reference
    end
end
