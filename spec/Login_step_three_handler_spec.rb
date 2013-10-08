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
  let(:login_details) { double(:login_details, :memorable_name => memorable_name ) }

  it 'should fill out the memorable name' do
    @session.visit("file:///Users/jbowkett/other/Smile-Bank-Txn-Downloader/spec/fixtures/login_three_memorable_name.html")
    LoginStepThreeHandler.new(login_details).handle(@session)
    @session.find('#memorablename')['value'].should == memorable_name
  end

end
