feature "Create answer", type: :feature do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
  
      visit question_path(question)
    end

    scenario 'Authenticated user create the answer', js: true do
      fill_in 'Your answer', with: 'answer text'
      click_button 'Reply'

      expect(page).to have_content 'answer text'
    end

    scenario 'Try to create answer with errors', js: true do
      click_button 'Reply'

      expect(page).to have_content "Body can't be blank"
    end

    scenario 'Reply with attached files', js: true do
      fill_in 'Your answer', with: 'answer text'
      attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_button 'Reply'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  scenario 'Non-authenticated user try to create answer', js: true do
    visit question_path(question)
    
    expect(page).to_not have_content 'Create Answer'
    expect(page).to_not have_button 'Reply'
  end
end