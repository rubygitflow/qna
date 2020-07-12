require 'rails_helper'

feature 'Пользователь может войти в систему', %q(
чтобы задать вопрос
как аутентифицированный пользователь
он должен иметь возможность войти в систему
) do
  given(:user) { User.create!(email: 'user@test.com', password: '12345678') }
  background { visit new_user_session_path }

  scenario 'Зарегистрированный пользователь пытается войти в систему' do
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'
    # save_and_open_page
    expect(page).to have_content 'Signed in successfully.'
  end

  scenario 'Не зарегистрированный пользователь пытается войти в систему' do
    fill_in 'Email', with: 'wrong@test.com'
    fill_in 'Password', with: '12345678'
    click_on 'Log in'

    expect(page).to have_content 'Invalid Email or password.'
  end
end