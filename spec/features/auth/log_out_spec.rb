feature "Log out" do
  scenario "Existing user try to log out" do
    User.create!(email: 'test@gmail.com', password: '12345678')

    visit new_user_session_path
    fill_in 'Email', with: 'test@gmail.com'
    fill_in 'Password', with: '12345678'
    click_on 'Log in'
    expect(page).to have_link 'test@gmail.com'

    click_on 'test@gmail.com'
    expect(page).to have_link 'Logout'

    click_on 'Logout'
    expect(page).to have_content 'Signed out successfully.'
  end
end
