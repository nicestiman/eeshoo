def sign_in(user)
  visit signin_path
  #save_and_open_page
  fill_in "Email",    with: user.email
  fill_in "Password", with: user.password
  click_button "Sign in"
  # Sign in when not using Capybara
  cookies[:remember_token] = user.remember_token
end

def full_title(page_title)
  base_title = "HIWIPI"
  if page_title.empty?
    base_title
  else
    "#{base_title} | #{page_title}"
  end
end

def register(new_user)
  visit signup_path
  fill_in      "First",        with: new_user.first
  fill_in      "Last",         with: new_user.last
  fill_in      "Email",        with: new_user.email
  fill_in      "Password",     with: new_user.password
  fill_in      "Confirmation", with: new_user.password
  click_button "Create my account"
end
