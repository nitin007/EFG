class LoanChangesController < ApplicationController
  TYPES = {
    'lump_sum_repayment' => LumpSumRepaymentLoanChange,
    'repayment_duration' => RepaymentDurationLoanChange,
    'reprofile_draws' => ReprofileDrawsLoanChange
  }

  before_filter :verify_create_permission
  before_filter :load_loan
  before_filter :load_presenter, only: [:new, :create]

  def index
  end

  def new
  end

  def create
    @presenter.attributes = params.fetch(:loan_change, {})

    if @presenter.save
      redirect_to loan_url(@loan)
    else
      render :new
    end
  end

  private
    def load_loan
      @loan = current_lender.loans.guaranteed.find(params[:loan_id])
    end

    def load_presenter
      klass = TYPES[params[:type]]

      if klass
        @presenter = klass.new(@loan, current_user)
      else
        redirect_to action: :index
      end
    end

    def verify_create_permission
      enforce_create_permission(LoanChange)
    end
end
