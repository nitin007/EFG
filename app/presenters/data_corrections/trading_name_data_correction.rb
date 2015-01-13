class TradingNameDataCorrection < DataCorrectionPresenter
  attr_accessor :trading_name
  attr_accessible :trading_name

  before_save :update_data_correction
  before_save :update_loan

  validates :trading_name, presence: true

  private
    def update_data_correction
      data_correction.change_type = ChangeType::TradingName
      data_correction.trading_name = trading_name
      data_correction.old_trading_name = loan.trading_name
    end

    def update_loan
      loan.trading_name = trading_name
    end
end
