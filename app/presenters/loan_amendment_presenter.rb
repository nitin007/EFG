class LoanAmendmentPresenter < SimpleDelegator
  include ActionView::Helpers::UrlHelper

  AmendmentTypes = %w(data_corrections loan_modifications).freeze

  attr_reader :loan, :amendment_id, :amendment_type, :amendment

  def self.for_loan(loan)
    loan_modifications = loan.loan_modifications.to_a
    data_corrections = loan.data_corrections.to_a
    amendments = loan_modifications.concat(data_corrections).sort_by(&:date_of_change)

    amendments.map do |amendment|
      amendment_type = amendment.class.base_class.name.tableize
      new(loan, id: amendment.id, type: amendment_type)
    end
  end

  def initialize(loan, opts = {})
    @loan = loan
    @amendment_id = opts.fetch(:id)
    @amendment_type = opts.fetch(:type)
    @amendment = get_amendment
    super(amendment)
  end

  def date_link
    link_to date_of_change.to_s(:screen), amendment_path
  end

  def drawn_amount?
    amendment.respond_to?(:amount_drawn) && !!amount_drawn
  end

  def lump_sum_repayment?
    amendment.respond_to?(:lump_sum_repayment) && !!lump_sum_repayment
  end

  def type_of_amendment_link
    link_to change_type_name, amendment_path
  end

  private

  def amendment_path
    Rails.application.routes.url_helpers.loan_loan_amendment_path(loan, self, type: amendment_type)
  end

  def get_amendment
    unless AmendmentTypes.include?(amendment_type)
      raise ActiveRecord::RecordNotFound
    end

    loan.public_send(amendment_type).find(amendment_id)
  end

end
