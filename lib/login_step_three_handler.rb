class LoginStepThreeHandler

  attr_reader :login_details
  private :login_details
  def initialize(login_details)
    @login_details = login_details
  end

  def handle(page)
    if page.has_css? '#memorablename'
      page.fill_in('memorable name', :with => login_details.memorable_name)
    end
  end

  def move_on(page)
    page.click_button('ok')
  end
end
