class TradingDateDataCorrection < DataCorrectionPresenter
  include BasicDataCorrectable

  data_corrects :trading_date
end
