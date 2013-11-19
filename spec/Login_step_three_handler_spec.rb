require 'rspec'
require_relative '../lib/login_step_three_handler'
require 'capybara'

describe '#handle' do

  before :each do
    Capybara.javascript_driver = :webkit
    Capybara.run_server = false
    @session = Capybara::Session.new(:selenium)
    # todo: get the current directory out of rspec
  end

  let(:memorable_name) { 'memorable name' }
  let(:memorable_date) { Date.parse('01-01-2013') }
  let(:last_school) { 'Brighton Borstal' }
  let(:first_school) { 'Brighton Borstal' }
  let(:login_details) { double(:login_details, { :memorable_name => memorable_name,
                                                 :last_school => last_school,
                                                 :first_school => first_school,
                                                 :memorable_date => memorable_date } ) }

  it 'should fill out the memorable name' do
    @session.visit("file:///Users/jbowkett/other/Smile-Bank-Txn-Downloader/spec/fixtures/login_three_memorable_name.html")
    LoginStepThreeHandler.new(login_details).handle(@session)
    @session.find('#memorablename')['value'].should == memorable_name
  end

  it 'should fill out the last school attended' do
    @session.visit("file:///Users/jbowkett/other/Smile-Bank-Txn-Downloader/spec/fixtures/login_three_last_school.html")
    LoginStepThreeHandler.new(login_details).handle(@session)
    @session.find('#lastschool')['value'].should == last_school
  end

  it 'should fill out the first school attended' do
    @session.visit("file:///Users/jbowkett/other/Smile-Bank-Txn-Downloader/spec/fixtures/login_three_first_school.html")
    LoginStepThreeHandler.new(login_details).handle(@session)
    @session.find('#firstschool')['value'].should == first_school
  end

  context 'for a memorable date' do
    before :each do
      @session.visit("file:///Users/jbowkett/other/Smile-Bank-Txn-Downloader/spec/fixtures/login_three_memorable_date.html")
      LoginStepThreeHandler.new(login_details).handle(@session)
    end
    it 'enters the day' do
      @session.find('#memorabledate')['value'].should == '01'
    end
    it 'enters the month' do
      @session.find('#memorabledate').parent.find(:xpath, "//input[@name='memorableMonth']")['value'].should == '01'
    end
    it 'enters the year' do
      @session.find('#memorabledate').parent.find(:xpath, "//input[@name='memorableYear']")['value'].should == memorable_date.year.to_s
    end
  end
end
