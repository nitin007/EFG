class AddPostClaimLimitToRealisationAdjustments < ActiveRecord::Migration
  def change
    add_column :realisation_adjustments, :post_claim_limit, :boolean, default: false, null: false
  end
end
