feature 'User can create reward for best answer' do
  given(:user) { create(:user) }

  background do
    sign_in(user)

    visit questions_path
    click_on 'Ask question'
  end

  scenario 'User can add reward when create question' do
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'
    
    fill_in 'Name', with: 'Reward'
    attach_file 'Image', "#{Rails.root}/spec/rails_helper.rb"

    click_on 'Ask'

    expect(page).to have_content 'Your question successfully created.'
    expect(page).to have_content 'Test question'
    expect(page).to have_content 'Reward'
  end
end
