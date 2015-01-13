class TradingDateDataCorrection < DataCorrectionPresenter
  attr_accessor :trading_date
  attr_accessible :trading_date

  before_save :update_data_correction
  before_save :update_loan

  validates :trading_date, presence: true

  private
    def update_data_correction
      data_correction.change_type = ChangeType::TradingDate
      data_correction.trading_date = trading_date
      data_correction.old_trading_date = loan.trading_date
    end

    def update_loan
      loan.trading_date = trading_date
    end
end
