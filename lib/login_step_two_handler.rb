class LoginStepTwoHandler

  attr_reader :login_details
  private :login_details
  def initialize(login_details)
    @login_details = login_details
  end

  def handle(page)

    indexes = []
    labels = []
    tip = page.find('td strong').text

    if tip =~ /.*first.*/
      indexes << 0
      labels << 'first digit'
    end
    if tip =~ /.*second.*/
      indexes << 1
      labels << 'second digit'
    end
    if tip =~ /.*third.*/
      indexes << 2
      labels << 'third digit'
    end
    if tip =~ /.*fourth.*/
      indexes << 3
      labels << 'fourth digit'
    end

    first_pass_code_digit = login_details.security_code[indexes[0]]
    second_pass_code_digit = login_details.security_code[indexes[1]]

    first_pass_code_label = labels[0]
    second_pass_code_label = labels[1]

    page.select(first_pass_code_digit, :from => first_pass_code_label)
    page.select(second_pass_code_digit, :from => second_pass_code_label)
  end

  def move_on(page)
    page.click_button('ok')
  end
end
