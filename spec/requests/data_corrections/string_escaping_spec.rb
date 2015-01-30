# encoding: utf-8

require 'spec_helper'

describe 'eligibility checks' do

  it 'escapes strings' do
    ActiveRecord::Base.connection.quote("Ben and Niall's shop").should eq("'Ben and Niall\\'s shop'")
  end

  it 'escapes numbers' do
    ActiveRecord::Base.connection.quote(0).should eq('0')
  end

end
