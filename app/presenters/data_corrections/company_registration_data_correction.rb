class CompanyRegistrationDataCorrection < DataCorrectionPresenter
  include BasicDataCorrectable

  data_corrects :company_registration
end
