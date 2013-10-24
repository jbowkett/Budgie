require 'rspec'
require_relative '../lib/transaction_extractor'


def cell(text)
  double(:cell, :text => text)
end

describe TransactionExtractor do
  describe '#extractFrom' do
    let(:account) { double(:account, :is_credit_card? => is_credit_card) }
    context 'for a regular account' do
      let(:is_credit_card) { false }
      context 'and a debit transaction' do
        let(:table) { [
            double(:row, :all => [ cell('02/10/2013'), cell('A Bill'), cell(''), cell('£10.74') ] )
        ] }

        it 'should extract the transaction' do
          items = TransactionExtractor.new(account).extract_from(table)
          items.size.should == 1
          items[0].amount_in_pence.should == -1074
        end
      end

      context 'and a credit transaction' do
        let(:table) { [
            double(:row, :all => [ cell('02/10/2013'), cell('A credit'), cell('£10.74'), cell('') ] )
        ] }

        it 'should extract the transaction' do
          items = TransactionExtractor.new(account).extract_from(table)
          items.size.should == 1
          items[0].amount_in_pence.should == 1074
        end

      end

    end
    context 'for a credit card account' do
      let(:is_credit_card) { true }

      context 'and a debit transaction' do
        let(:table) { [
            double(:row, :all => [ cell('02/10/2013'), cell('A meal out'), cell('£100.74') ] )
        ] }

        it 'should make a positive amount in the input a negative amount' do
          items = TransactionExtractor.new(account).extract_from(table)
          items[0].amount_in_pence.should == -10074
        end
      end

      context 'and a credit transaction' do
        let(:table) { [
            double(:row, :all => [ cell('02/10/2013'), cell('A refund payment made to the card'), cell('-£100.74') ] )
        ] }
        it 'should make a negative amount in the input a positive amount' do
          items = TransactionExtractor.new(account).extract_from(table)
          items[0].amount_in_pence.should == 10074
        end
      end
    end
  end
end
