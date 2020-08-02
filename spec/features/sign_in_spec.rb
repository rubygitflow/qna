require 'rails_helper'

feature 'User can login', %(
  To ask a question as an authenticated user, he must be able to log in
) do
  given(:user) { create(:user) }
  given(:unconfirmed_user) { create(:user, confirmed_at: nil) }
  background { visit new_user_session_path }

  scenario 'A registered user is trying to log in with a confirmed email address' do
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'
    # save_and_open_page
    expect(page).to have_content 'Signed in successfully.'
  end

  scenario 'A registered user is trying to log in with a UNconfirmed email address' do
    fill_in 'Email', with: unconfirmed_user.email
    fill_in 'Password', with: unconfirmed_user.password
    click_on 'Log in'

    expect(page).to have_content 'You have to confirm your email address before continuing.'
  end

  scenario 'An unregistered user is trying to log in' do
    fill_in 'Email', with: 'wrong@test.com'
    fill_in 'Password', with: '12345678'
    click_on 'Log in'

    expect(page).to have_content 'Invalid Email or password.'
  end

  scenario "User can sign in with Github account" do
    click_on "Sign in with GitHub"
    expect(page).to have_content 'Successfully authenticated from Github account.'
  end

  scenario "App handles an authentication error" do
    OmniAuth.config.mock_auth[:github] = :invalid_credentials
    click_on "Sign in with GitHub"
    expect(page).to have_content 'Invalid credentials'
  end
end
