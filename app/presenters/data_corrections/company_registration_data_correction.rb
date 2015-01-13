class CompanyRegistrationDataCorrection < DataCorrectionPresenter
  attr_accessor :company_registration
  attr_accessible :company_registration

  before_save :update_data_correction
  before_save :update_loan

  validates :company_registration, presence: true

  private
    def update_data_correction
      data_correction.change_type = ChangeType::CompanyRegistration
      data_correction.company_registration = company_registration
      data_correction.old_company_registration = loan.company_registration
    end

    def update_loan
      loan.company_registration = company_registration
    end
end
