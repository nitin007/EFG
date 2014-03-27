class AddStateAidThresholdToSicCodes < ActiveRecord::Migration
  def up
    add_column :sic_codes, :state_aid_threshold, :integer, limit: 8

    # default threshold is 200,000
    execute 'UPDATE sic_codes SET state_aid_threshold = 20000000'

    sic_code_threshold_mappings = {
      '01110' => 1500000,
      '01120' => 1500000,
      '01130' => 1500000,
      '01140' => 1500000,
      '01150' => 1500000,
      '01160' => 1500000,
      '01190' => 1500000,
      '01210' => 1500000,
      '01220' => 1500000,
      '01230' => 1500000,
      '01240' => 1500000,
      '01250' => 1500000,
      '01260' => 1500000,
      '01270' => 1500000,
      '01280' => 1500000,
      '01290' => 1500000,
      '01300' => 1500000,
      '01410' => 1500000,
      '01420' => 1500000,
      '01430' => 1500000,
      '01440' => 1500000,
      '01450' => 1500000,
      '01460' => 1500000,
      '01470' => 1500000,
      '01490' => 1500000,
      '01500' => 1500000,
      '01610' => 1500000,
      '01621' => 1500000,
      '01629' => 1500000,
      '01630' => 1500000,
      '01640' => 1500000,
      '03110' => 3000000,
      '03120' => 3000000,
      '03210' => 3000000,
      '03220' => 3000000,
      '49410' => 10000000,
      '64201' => 1500000,
    }

    sic_code_threshold_mappings.each do |code, threshold|
      execute "UPDATE sic_codes SET state_aid_threshold = #{threshold} WHERE code = '#{code}'"
    end

    change_column_null :sic_codes, :state_aid_threshold, false
  end

  def down
    remove_column :sic_codes, :state_aid_threshold
  end
end
