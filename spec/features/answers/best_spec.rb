feature 'Question owner set best answer' do
  given(:user) { create(:user) }
  given(:user2) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'Non-authenticated user try set best answer' do
    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_link 'Make best'
    end
  end

  describe 'Authenticated user' do
    scenario 'Question owner set best answer', js: true do
      sign_in(user)
      visit question_path(question)

      within '.answers' do
        click_on 'Make best'

        expect(page).to have_content '- Best answer!'
      end
    end

    scenario 'Not question owner try set best answer', js: true do
      sign_in(user2)
      visit question_path(question)

      within '.answers' do
        expect(page).to_not have_link 'Make best'
      end
    end
  end
end