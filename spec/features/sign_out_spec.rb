require 'rails_helper'

feature 'User can log out', %(
  An authenticated user must log out to end the session
) do
  given(:user) { create(:user) }

  scenario 'Authenticated user logs out' do
    login(user)
    click_on 'Log out'
    expect(page).to have_content 'Signed out successfully.'
  end
end
