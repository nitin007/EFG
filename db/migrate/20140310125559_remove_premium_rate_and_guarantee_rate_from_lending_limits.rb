class RemovePremiumRateAndGuaranteeRateFromLendingLimits < ActiveRecord::Migration
  def up
    remove_column :lending_limits, :premium_rate
    remove_column :lending_limits, :guarantee_rate
  end

  def down
    add_column :lending_limits, :premium_rate, :decimal, precision: 16, scale: 2, null: false
    add_column :lending_limits, :guarantee_rate, :decimal, precision: 16, scale: 2, null: false

    LendingLimit.reset_column_information
    LendingLimit.find_each do |l|
      rules = l.phase_id == 6 ? Phase6Rules : Phase5Rules
      l.premium_rate = rules.loan_category_premium_rate(1)
      l.guarantee_rate = rules.loan_category_guarantee_rate
      l.save!
    end
  end
end
