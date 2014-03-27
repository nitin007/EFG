class MoveEuroConversionRateToLoan < ActiveRecord::Migration
  def up
    add_column :loans, :euro_conversion_rate, :decimal, precision: 17, scale: 14

    # Fetch the euro_conversion_rate from the the most recent *scheduled*
    # premium schedule (even though there's supposed to only ever be one).
    execute "UPDATE loans
      SET euro_conversion_rate = (
        SELECT premium_schedules.euro_conversion_rate
        FROM premium_schedules
        WHERE premium_schedules.loan_id = loans.id
          AND calc_type = 'S'
        ORDER BY seq DESC
        LIMIT 1
      )"

    # If a *scheduled* premium schedule doesn't exist (though this also
    # probably shouldn't have ever happened) just use the first one.
    execute "UPDATE loans
      SET euro_conversion_rate = (
        SELECT premium_schedules.euro_conversion_rate
        FROM premium_schedules
        WHERE premium_schedules.loan_id = loans.id
        ORDER BY seq ASC
        LIMIT 1
      )
      WHERE euro_conversion_rate IS NULL"

    remove_column :premium_schedules, :euro_conversion_rate
  end

  def down
    add_column :premium_schedules, :euro_conversion_rate, :decimal, precision: 17, scale: 14

    execute 'UPDATE premium_schedules
      SET euro_conversion_rate = (
        SELECT euro_conversion_rate
        FROM loans
        WHERE id = loan_id
        LIMIT 1
      )'

    change_column_null :premium_schedules, :euro_conversion_rate, false

    remove_column :loans, :euro_conversion_rate
  end
end
