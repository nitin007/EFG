class UpdateLoanLendingLimitsController < ApplicationController
  before_filter :load_loan, only: [:new, :create]
  before_filter :verify_create_permission, only: [:new, :create]

  def new
    @update_lending_limit = UpdateLoanLendingLimit.new(@loan)
  end

  def create
    @update_lending_limit = UpdateLoanLendingLimit.new(@loan)
    @update_lending_limit.attributes = params[:update_loan_lending_limit]
    @update_lending_limit.modified_by = current_user

    if @update_lending_limit.save
      if @update_lending_limit.state == Loan::Incomplete
        redirect_to(new_loan_entry_path(@loan), alert: t('update_loan_lending_limit.loan_not_valid_for_lending_limit'))
      else
        render
      end
    else
      render :new
    end
  end

  private
  def load_loan
    @loan = current_lender.loans.find(params[:loan_id])
  end

  def verify_create_permission
    enforce_create_permission(UpdateLoanLendingLimit)
  end
end
