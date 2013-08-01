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
