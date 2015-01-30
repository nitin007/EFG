# encoding: utf-8

require 'spec_helper'

describe 'eligibility checks' do

  it 'escapes strings' do
    expect(ActiveRecord::Base.connection.quote("Ben and Niall's shop")).to eq("'Ben and Niall\\'s shop'")
  end

  it 'escapes numbers' do
    expect(ActiveRecord::Base.connection.quote(0)).to eq('0')
  end

end
