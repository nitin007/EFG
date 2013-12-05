class MakeLoanRealisationRealisedOnNotNullable < ActiveRecord::Migration
  def up
    execute 'UPDATE loan_realisations SET realised_on = created_at WHERE realised_on IS NULL'
    change_column_null :loan_realisations, :realised_on, false
  end

  def down
    change_column_null :loan_realisations, :realised_on, true
  end
end
