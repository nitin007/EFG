require 'spec_helper'

describe SerializedDateFormatter do
  describe '::format' do
    it 'correctly parses dd/mm/yyyy and returns a Date object' do
      SerializedDateFormatter.format('11/1/2011').should == Date.new(2011, 1, 11)
    end

    it 'correctly parses dd/mm/yy and returns a Date object' do
      SerializedDateFormatter.format('11/1/11').should == Date.new(2011, 1, 11)
    end
  end

  describe '::parse' do
    it 'correctly parses dd/mm/yyyy and returns a Date object' do
      SerializedDateFormatter.format('11/1/2011').should == Date.new(2011, 1, 11)
    end

    it 'correctly parses dd/mm/yy and returns a Date object' do
      SerializedDateFormatter.format('11/1/11').should == Date.new(2011, 1, 11)
    end
  end
end
