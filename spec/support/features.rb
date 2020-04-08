def sign_up_with(email, password)
  visit sign_up_path
  fill_in "Email", with: email
  fill_in "Password", with: password
  click_button "Sign up"
end

def sign_in_with(email, password)
  visit sign_in_path
  fill_in "Email", with: email
  fill_in "Password", with: password
  click_button "Log in"
end

def navigate_navbar_to(link_text)
  within ".navbar" do
    click_link link_text
  end
end
