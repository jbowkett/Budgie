class LoginStepThreeHandler

  attr_reader :login_details
  private :login_details
  def initialize(login_details)
    @login_details = login_details
  end

  def handle(page)
    if page.has_css? '#memorablename'
      page.fill_in('memorable name', :with => login_details.memorable_name)
    elsif page.has_css? '#lastschool'
      page.fill_in('last school', :with => login_details.last_school)
    elsif page.has_css? '#firstschool'
      page.fill_in('first school', :with => login_details.first_school)
    elsif page.has_css? '#memorabledate'
      page.fill_in('memorabledate', :with => login_details.memorable_date.day)
      page.fill_in('memorableMonth', :with => login_details.memorable_date.month)
      page.fill_in('memorableYear', :with => login_details.memorable_date.year)
    end
  end

  def move_on(page)
    page.click_button('ok')
  end
end
