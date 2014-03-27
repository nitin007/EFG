class ClaimLimitCalculator

  ClaimLimitStates = [
    Loan::Guaranteed,
    Loan::LenderDemand,
    Loan::Repaid,
    Loan::RepaidFromTransfer,
    Loan::NotDemanded,
    Loan::Demanded,
    Loan::Settled,
    Loan::Realised,
    Loan::Recovered,
    Loan::AutoRemoved,
    Loan::Removed,
  ].freeze

  SettledStates = [
    Loan::Settled,
    Loan::Realised,
    Loan::Recovered,
  ].freeze

  attr_reader :lender

  def initialize(lender)
    @lender = lender
  end

  def self.all_with_amount(lenders)
    lenders.each_with_object([]) do |lender, memo|
      Phase.all.each do |phase|
        calculator = phase.rules.claim_limit_calculator.new(lender)
        memo << calculator unless calculator.total_amount.zero?
      end
    end
  end

  def amount_remaining
    remainder = total_amount + pre_claim_realisations_amount - settled_amount
    remainder < 0 ? Money.new(0) : remainder
  end

  def cumulative_drawn_amount
    @cumulative_drawn_amount ||= begin
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
          ", lender.id, Loan::EFG_SCHEME, ChangeType::RecordAgreedDraw.id, phase.id, ClaimLimitStates
        ]
      ).first
      Money.new(loan.amount_drawn.to_i)
    end
  end

  def percentage_remaining
    return 0 if total_amount.zero?
    return 100 if amount_remaining.zero?

    (amount_remaining / total_amount * 100).round
  end

  def phase
    raise NotImplementedError, 'Implement in sub-class'
  end

  def pre_claim_realisations_amount
    @pre_claim_realisations_amount ||= begin
      loan = Loan.find_by_sql(
        [
          "SELECT SUM(realised_amount) as total_realised_amount
          FROM loan_realisations
          INNER JOIN loans ON (loan_realisations.realised_loan_id = loans.id)
          INNER JOIN lending_limits ON (loans.lending_limit_id = lending_limits.id)
          WHERE loans.lender_id = ?
            AND loans.loan_scheme = ?
            AND lending_limits.phase_id = ?
            AND loans.state IN (?)
          ", lender.id, Loan::EFG_SCHEME, phase.id, SettledStates
        ]
      ).first
      Money.new(loan.total_realised_amount.to_i)
    end
  end

  def settled_amount
    @settled_amount ||= begin
      loan = Loan.find_by_sql(
        [
          "SELECT SUM(settled_amount) as total_settled_amount
          FROM loans
          INNER JOIN lending_limits ON (loans.lending_limit_id = lending_limits.id)
          WHERE loans.lender_id = ?
            AND loans.loan_scheme = ?
            AND lending_limits.phase_id = ?
            AND loans.state IN (?)
          ", lender.id, Loan::EFG_SCHEME, phase.id, SettledStates
        ]
      ).first
      Money.new(loan.total_settled_amount.to_i)
    end
  end

  def total_amount
    raise NotImplementedError, 'Implement in sub-class'
  end

end
