require 'rails_helper'

feature 'User can register in the system', %(
  To enter the system, a non-registered user must register
) do
  background { visit new_user_registration_path }

  describe 'The user is registered in the system' do
    scenario 'with correct data' do
      fill_in 'Email', with: 'new_user@test.com'
      fill_in 'Password', with: '12345678'
      fill_in 'Password confirmation', with: '12345678'
      clear_emails
      click_button 'Sign up'

      expect(page).to have_content 'A message with a confirmation link has been sent to your email address'

      open_email('new_user@test.com')
      current_email.click_link 'Confirm my account'

      expect(page).to have_content 'Your email address has been successfully confirmed'      
    end

    scenario 'with errors' do
      click_button 'Sign up'
      expect(page).to have_content "Email can't be blank"
    end
  end
end
