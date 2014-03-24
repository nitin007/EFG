class ClaimLimitsCsvExport < BaseCsvExport

  private

  def fields
    [
      :lender_name,
      :phase,
      :claim_limit,
      :cumulative_drawn_amount,
      :settled,
      :pre_claim_limit_realisations,
      :claim_limit_remaining
    ]
  end

  def csv_row(record)
    [
      record.lender.name,
      "Phase #{record.phase.id}",
      record.total_amount.to_s,
      record.cumulative_drawn_amount.to_s,
      record.settled_amount.to_s,
      record.pre_claim_realisations_amount.to_s,
      record.amount_remaining.to_s,
    ]
  end

  private

  def translation_scope
    'csv_headers.claim_limits_report'
  end

end
