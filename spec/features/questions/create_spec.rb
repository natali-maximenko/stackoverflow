feature 'User can create question', %q{
  In order to get answer from a community
  As an authenticated user
  I'd like to be able to ask the question
} do
  
  given(:user) { create(:user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
  
      visit questions_path
      click_on 'Ask question'
    end

    scenario 'Create the question' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'
      click_on "Ask"
    
      expect(page).to have_content 'Your question successfully created.'
      expect(page).to have_content 'Test question'
      expect(page).to have_content 'text text text'
    end
    
    scenario 'Asks a question with errors' do
      click_on 'Ask'

      expect(page).to have_content "Title can't be blank"
    end

    scenario 'Asks a question with attached files' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'
      attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on "Ask"

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end  

  scenario 'Non-authenticated user try to create question' do
    visit questions_path
    click_on 'Ask'
    
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  describe 'multiple sessions' do
    scenario "question appears on another user's page" do
      Capybara.using_session('user') do
        sign_in(user)
        visit questions_path
      end

      Capybara.using_session('guest') do
        visit questions_path
      end

      Capybara.using_session('user') do
        click_on 'Ask question'

        within '.question' do
          fill_in 'Title', with: 'Test question'
          fill_in 'Body', with: 'text text text'
        end

        click_on 'Ask'

        expect(page).to have_content 'Test question'
        expect(page).to have_content 'text text text'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'Test question'
      end
    end
  end
end      