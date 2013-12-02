class LoginStepOneHandler

  attr_reader :account
  private :account
  def initialize(account)
    @account = account
  end

  def handle(page)
    if account.is_credit_card?
      page.fill_in('Visa credit card number', :with => account.account_id)
    else
      page.fill_in('sort code', :with => account.sort_code)
      page.fill_in('accountnumber', :with => account.account_id)
    end
  end

  def move_on(page)
    page.click_button('ok')
  end
end
