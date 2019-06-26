feature "Sign up" do

  background { visit new_user_registration_path }  

  scenario "Non-existing user try to sign up" do
    fill_in 'Email', with: 'user@test.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'
    click_on 'Sign up'

    expect(page).to have_content 'Welcome! You have signed up successfully.'
    expect(current_path).to eq root_path
  end

  scenario 'Existed user try to sign up' do
    User.create!(email: 'user@test.com', password: '12345678')

    fill_in 'Email', with: 'user@test.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'
    click_on 'Sign up'

    expect(page).to have_content  'Email has already been taken'
  end
end
