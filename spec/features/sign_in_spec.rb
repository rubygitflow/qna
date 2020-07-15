require 'rails_helper'

feature 'User can login', %q(
  To ask a question as an authenticated user, he must be able to log in
) do
  given(:user) { create(:user) }
  background { visit new_user_session_path }

  scenario 'A registered user is trying to log in' do
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'
    # save_and_open_page
    expect(page).to have_content 'Signed in successfully.'
  end

  scenario 'An unregistered user is trying to log in' do
    fill_in 'Email', with: 'wrong@test.com'
    fill_in 'Password', with: '12345678'
    click_on 'Log in'

    expect(page).to have_content 'Invalid Email or password.'
  end
end
