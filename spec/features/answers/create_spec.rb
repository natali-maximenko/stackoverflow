feature "Create answer", type: :feature do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:girl) { create(:user) }
  given(:question2) { create(:question, user: girl) }

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

  describe 'Multiple sessions' do
    scenario 'answer appears on girl page', js: true do
      Capybara.using_session('girl') do
        sign_in(girl)
        visit question_path(question)
      end

      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('girl') do
        fill_in 'Your answer', with: 'Answer'
        click_on 'Reply'

        expect(current_path).to eq question_path(question)
        within '.answers' do
          expect(page).to have_content 'Answer'
        end
      end

      Capybara.using_session('user') do
        within '.answers' do
          expect(page).to have_content 'Answer'
          expect(page).to have_content 'Rating:'
          expect(page).to have_link 'Up!'
          expect(page).to have_link 'Down'
          expect(page).to have_link 'Make best'
        end
      end

      Capybara.using_session('guest') do
        within '.answers' do
          expect(page).to have_content 'Answer'
          expect(page).to have_link 'Like!'
          expect(page).to have_link 'Dislike...'
        end
      end
    end
  end
end