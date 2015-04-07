class LoanReport
  def initialize
    @loan_types = []
    @phases = []
  end

  attr_accessor :states, :loan_types, :phases, :lender_ids, :created_by_id,
              :facility_letter_start_date, :facility_letter_end_date,
              :created_at_start_date, :created_at_end_date,
              :last_modified_start_date, :last_modified_end_date

  def loans
    loans = scope

    # Loan attributes
    loans = loans.select('loans.*')
    loans = loans.select('loans.guarantee_rate AS loan_guarantee_rate')
    loans = loans.select('loans.premium_rate AS loan_premium_rate')

    # DED Code attributes
    loans = loans.select('ded_codes.group_description AS ded_code_group_description')
    loans = loans.select('ded_codes.category_description AS ded_code_category_description')
    loans = loans.select('ded_codes.code_description AS ded_code_code_description')
    loans = loans.select('ded_codes.code AS ded_code_code')
    loans = loans.joins('LEFT JOIN ded_codes ON loans.dti_ded_code = ded_codes.code')

    # Initial Draw attributes
    loans = loans.select('initial_draw_change.date_of_change AS initial_draw_date')
    loans = loans.select('initial_draw_change.amount_drawn AS initial_draw_amount')
    loans = loans.joins('LEFT JOIN loan_modifications AS initial_draw_change ON initial_draw_change.loan_id = loans.id AND initial_draw_change.type = "InitialDrawChange"')

    # Invoice attributes
    loans = loans.select('invoices.reference AS invoice_reference')
    loans = loans.joins('LEFT JOIN invoices ON loans.invoice_id = invoices.id')

    # Lending Limit attributes
    loans = loans.select('lending_limits.phase_id AS lending_limit_phase_id')
    loans = loans.select('lending_limits.name AS lending_limit_name')

    # User attributes
    loans = loans.select('created_by_user.username AS created_by_username')
    loans = loans.joins('LEFT JOIN users AS created_by_user ON loans.created_by_id = created_by_user.id')

    loans = loans.select('modified_by_user.username AS modified_by_username')
    loans = loans.joins('LEFT JOIN users AS modified_by_user ON loans.modified_by_id = modified_by_user.id')

    # Sub-Selects
    loans = loans.select('(SELECT organisation_reference_code FROM lenders WHERE id = loans.lender_id) AS lender_organisation_reference_code')
    loans = loans.select('(SELECT recovered_on FROM recoveries WHERE loan_id = loans.id ORDER BY recoveries.id DESC LIMIT 1) AS last_recovery_on')
    loans = loans.select('(SELECT SUM(amount_due_to_dti) FROM recoveries WHERE loan_id = loans.id) AS total_recoveries')
    loans = loans.select('(SELECT created_at FROM loan_realisations WHERE realised_loan_id = loans.id ORDER BY loan_realisations.id DESC LIMIT 1) AS last_realisation_at')
    loans = loans.select('(SELECT SUM(realised_amount) FROM loan_realisations WHERE realised_loan_id = loans.id) AS total_loan_realisations')
    loans = loans.select('(SELECT SUM(amount_drawn) FROM loan_modifications WHERE loan_id = loans.id) AS total_amount_drawn')
    loans = loans.select('(SELECT SUM(lump_sum_repayment) FROM loan_modifications WHERE loan_id = loans.id) AS total_lump_sum_repayment')
    loans = loans.select('(SELECT SUM(realised_amount) FROM loan_realisations WHERE realised_loan_id = loans.id AND post_claim_limit = 0) AS cumulative_pre_claim_limit_realised_amount')
    loans = loans.select('(SELECT SUM(realised_amount) FROM loan_realisations WHERE realised_loan_id = loans.id AND post_claim_limit = 1) AS cumulative_post_claim_limit_realised_amount')

    loans
  end

  def count
    scope.count
  end

  private
  def scope

    scope = Loan.all

    scope = scope.joins('LEFT JOIN lending_limits ON loans.lending_limit_id = lending_limits.id')

    scope = scope.where('loans.state IN (?)', states) if states.present?

    if loan_types.any? || phases.any?
      # If we have any phases we need to retrive a subset of EFG loans rather
      # than all EFG loans.
      if phases.any?
        loan_types.delete(LoanTypes::EFG)
      end

      loans = Loan.arel_table
      lending_limits = LendingLimit.arel_table

      conditions = loan_types.map do |type|
        condition = (loans[:loan_scheme].eq(type.scheme).and(loans[:loan_source].eq(type.source)))
        condition.to_sql
      end

      conditions += phases.map do |phase|
        condition = (loans[:loan_scheme].eq(phase.type.scheme).and(loans[:loan_source].eq(phase.type.source)).and(lending_limits[:phase_id].eq(phase.id)))
        condition.to_sql
      end

      scope = scope.where(conditions.join(' OR '))
    end

    scope = scope.where('loans.lender_id IN (?)', lender_ids) if lender_ids.present?
    scope = scope.where('loans.created_by_id = ?', created_by_id) if created_by_id.present?
    scope = scope.where('loans.facility_letter_date >= ?', facility_letter_start_date) if facility_letter_start_date.present?
    scope = scope.where('loans.facility_letter_date <= ?', facility_letter_end_date) if facility_letter_end_date.present?
    scope = scope.where('loans.created_at >= ?', created_at_start_date.beginning_of_day) if created_at_start_date.present?
    scope = scope.where('loans.created_at <= ?', created_at_end_date.end_of_day) if created_at_end_date.present?
    scope = scope.where('loans.last_modified_at >= ?', last_modified_start_date.beginning_of_day) if last_modified_start_date.present?
    scope = scope.where('loans.last_modified_at <= ?', last_modified_end_date.end_of_day) if last_modified_end_date.present?

    scope
  end
end
