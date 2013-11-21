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
      context 'and transactions without a balance' do
        context 'for debit transactions' do
          context 'that are ordered newest first' do
            let(:table) { [
                double(:row, :all => [cell('02/10/2013'), cell('A Bill'), cell(''), cell('£10.74')]), # 100.00
                double(:row, :all => [cell('01/10/2013'), cell('A Bill'), cell(''), cell('£10.56')]) # 110.74
            ] }

            it 'should extract the transactions' do
              items = TransactionExtractor.new(account).extract_from(table, 0)
              items.size.should == 2
              items[0].amount_in_pence.should == -1074
              items[1].amount_in_pence.should == -1056
            end

            it 'should set the balance' do
              items = TransactionExtractor.new(account).extract_from(table, 10000)
              items[0].balance_in_pence.should == 10000
              items[1].balance_in_pence.should == 11074
            end

          end
          context 'that are ordered oldest first' do
            let(:table) { [
                double(:row, :all => [cell('30/09/2013'), cell('A Bill'), cell(''), cell('£10.48')]),
                double(:row, :all => [cell('01/10/2013'), cell('A Bill'), cell(''), cell('£10.56')]),
                double(:row, :all => [cell('13/10/2013'), cell('A Bill'), cell(''), cell('£10.74')])
            ] }

            it 're orders the transactions' do
              items = TransactionExtractor.new(account).extract_from(table, 0)
              items[0].transaction_date.should == Date.parse('13-10-2013')
              items[2].transaction_date.should == Date.parse('30-09-2013')
            end

          end

        end


        context 'for credit transactions' do
          let(:table) { [
              double(:row, :all => [cell('02/10/2013'), cell('A credit'), cell('£10.74'), cell('')]), # 100.00
              double(:row, :all => [cell('01/10/2013'), cell('A credit'), cell('£10.56'), cell('')]) #  89.26
          ] }

          it 'should extract the transactions' do
            items = TransactionExtractor.new(account).extract_from(table, 0)
            items.size.should == 2
            items[0].amount_in_pence.should == 1074
            items[1].amount_in_pence.should == 1056
          end
          it 'should set the balance' do
            items = TransactionExtractor.new(account).extract_from(table, 10000)
            items[0].balance_in_pence.should == 10000
            items[1].balance_in_pence.should == 8926
          end
        end

        context 'for credit and debit transactions' do
          let(:table) { [
              double(:row, :all => [cell('03/10/2013'), cell('A credit1'), cell('£0.01'), cell('')]), # 100.00
              double(:row, :all => [cell('02/10/2013'), cell('A credit2'), cell('£0.02'), cell('')]), # 99.99
              double(:row, :all => [cell('01/10/2013'), cell('A debit1'), cell(''), cell('£0.05')]), # 99.97
              double(:row, :all => [cell('28/09/2013'), cell('A credit2'), cell('£0.02'), cell('')]) # 100.02
          ] }

          it 'should set the balance' do
            items = TransactionExtractor.new(account).extract_from(table, 10000)
            items[0].balance_in_pence.should == 10000
            items[1].balance_in_pence.should == 9999
            items[2].balance_in_pence.should == 9997
            items[3].balance_in_pence.should == 10002
          end

        end
      end
    end
    context 'for a credit card account' do
      let(:is_credit_card) { true }
      context 'and transactions without a balance' do
        context 'for debit transactions' do
          let(:table) { [
              double(:row, :all => [cell('02/10/2013'), cell('A meal out'), cell('£100.74')]),
              double(:row, :all => [cell('01/10/2013'), cell('bought something cheap'), cell('£0.10')]),
          ] }

          it 'should make a positive amount in the input a negative amount' do
            items = TransactionExtractor.new(account).extract_from(table, 0)
            items[0].amount_in_pence.should == -10074
          end

          it 'should set the balance' do
            items = TransactionExtractor.new(account).extract_from(table, -10084)
            items[0].balance_in_pence.should == -10084
            items[1].balance_in_pence.should == -10

          end
        end

        context 'for credit transactions' do
          let(:table) { [
              double(:row, :all => [cell('02/10/2013'), cell('A refund payment made to the card'), cell('-£100.74')]),
              double(:row, :all => [cell('01/10/2013'), cell('A previous refund'), cell('-£53.00')])
          ] }
          it 'should make a negative amount in the input a positive amount' do
            items = TransactionExtractor.new(account).extract_from(table, 0)
            items[0].amount_in_pence.should == 10074
          end
          it 'should set the balance' do
            items = TransactionExtractor.new(account).extract_from(table, 0)
            items[0].balance_in_pence.should == 0
            items[1].balance_in_pence.should == -10074
          end
        end
      end
    end
  end
end
