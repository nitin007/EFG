class Phase6ClaimLimitCalculator < ClaimLimitCalculator

  ReducedLoanPercentage = BigDecimal.new('65')
  ReducedLoanCategoryIds = [ 6 ].freeze
  FirstOneHundredThousandPercentage = BigDecimal.new('75')
  AboveOneHundredThousandPercentage = BigDecimal.new('15')

  def phase
    Phase.find(6)
  end

  def total_amount
    first_one_hundred_thousand_amount + above_one_hundred_thousand_amount
  end

  private

  def first_one_hundred_thousand_amount
    amount = cumulative_drawn_amount >= Money.new(100_000_00) ? Money.new(100_000_00) : cumulative_drawn_amount
    amount * FirstOneHundredThousandPercentage / 100
  end

  def above_one_hundred_thousand_amount
    if cumulative_drawn_amount > Money.new(100_000_00)
      (cumulative_drawn_amount - Money.new(100_000_00)) * AboveOneHundredThousandPercentage / 100
    else
      Money.new(0)
    end
  end

  private

  def cumulative_drawn_amount
    non_reduced_loans_cumulative_draw_amount + reduced_loans_cumulative_draw_amount
  end

  def non_reduced_loans_cumulative_draw_amount
    @non_reduced_loans_cumulative_draw_amount ||= begin
      loan = Loan.find_by_sql(
        [
          "SELECT SUM(amount_drawn) as amount_drawn
          FROM loan_modifications
          INNER JOIN loans ON (loan_modifications.loan_id = loans.id)
          INNER JOIN lending_limits ON (loans.lending_limit_id = lending_limits.id)
          WHERE loans.lender_id = ?
            AND loans.loan_scheme = ?
            AND (loan_modifications.type = 'InitialDrawChange' OR loan_modifications.change_type_id = ?)
            AND lending_limits.phase_id = ?
            AND loans.state IN (?)
            AND loans.loan_category_id NOT IN (?)
          ", lender.id, Loan::EFG_SCHEME, ChangeType::RecordAgreedDraw.id, phase.id, ClaimLimitStates, ReducedLoanCategoryIds
        ]
      ).first
      Money.new(loan.amount_drawn.to_i)
    end
  end

  def reduced_loans_cumulative_draw_amount
    @reduced_loans_cumulative_draw_amount ||= begin
      loan = Loan.find_by_sql(
        [
          "SELECT SUM(amount_drawn) as amount_drawn
          FROM loan_modifications
          INNER JOIN loans ON (loan_modifications.loan_id = loans.id)
          INNER JOIN lending_limits ON (loans.lending_limit_id = lending_limits.id)
          WHERE loans.lender_id = ?
            AND loans.loan_scheme = ?
            AND (loan_modifications.type = 'InitialDrawChange' OR loan_modifications.change_type_id = ?)
            AND lending_limits.phase_id = ?
            AND loans.state IN (?)
            AND loans.loan_category_id IN (?)
          ", lender.id, Loan::EFG_SCHEME, ChangeType::RecordAgreedDraw.id, phase.id, ClaimLimitStates, ReducedLoanCategoryIds
        ]
      ).first
      Money.new(loan.amount_drawn.to_i) * ReducedLoanPercentage / 100
    end
  end

end
