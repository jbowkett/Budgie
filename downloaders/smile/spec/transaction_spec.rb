require 'rspec'
require_relative '../common/transaction'
require 'data_mapper'

require 'date'
describe 'Transaction' do
   before do
     DataMapper.finalize
   end

  it 'should calculate a month surrogate key for year 00' do
    Transaction.new(:transaction_date => DateTime.parse('0000-01-01 12:00')).month_sk.should == 0
  end
  it 'should calculate a month surrogate key for 2013' do
    Transaction.new(:transaction_date => DateTime.parse('2013-12-01 12:00')).month_sk.should == 24167
  end
  it 'should calculate a month surrogate key for 2014' do
    Transaction.new(:transaction_date => DateTime.parse('2014-01-01 12:00')).month_sk.should == 24168
  end
end
