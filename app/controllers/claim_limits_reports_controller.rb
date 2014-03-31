class ClaimLimitsReportsController < ApplicationController
  before_filter :verify_create_permission

  def show
    respond_to do |format|
      format.csv do
        csv_export = ClaimLimitsCsvExport.new(calculators)
        filename = "lender_claim_limits_#{Date.current.to_s(:db)}.csv"
        stream_response(csv_export, filename)
      end
    end
  end

  private

  def calculators
    lenders = current_user.lenders.active
    ClaimLimitCalculator.all_with_amount(lenders)
  end

  def verify_create_permission
    enforce_create_permission(ClaimLimitsCsvExport)
  end

end
