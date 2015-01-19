class LoanAmendmentsController < ApplicationController
  before_filter :verify_view_permission
  before_filter :load_loan

  def index
    @loan_amendments = get_loan_amendments
  end

  def show
    @loan_amendment = get_loan_amendment
  end

  private
    def load_loan
      @loan = current_lender.loans.find(params[:loan_id])
    end

    def get_loan_amendments
      loan_modifications = @loan.loan_modifications.to_a
      data_corrections = @loan.data_corrections.to_a

      loan_modifications.concat(data_corrections).sort_by(&:date_of_change)
    end

    def get_loan_amendment
      unless [
        'data_corrections',
        'loan_modifications',
      ].include?(params[:type])
        raise ActiveRecord::RecordNotFound
      end

      @loan.public_send(params[:type]).find(params[:id])
    end

    def verify_view_permission
      enforce_view_permission(LoanModification)
    end
end
