feature "Destroy links", type: :feature do
  given!(:user) { create(:user) }
  given!(:other_user) { create(:user) }
  
  context 'Question with link' do
    given!(:question) { create(:question, user: user) }
    given!(:link) { create(:link, linkable: question) }

    background do
      visit questions_path
      expect(page).to have_content question.title
    end

    scenario 'deletes link to his question' do
      sign_in(user)
      visit question_path(question)

      click_on 'Destroy link'

      expect(page).to have_content 'Your link succesfully destroyed.'
      expect(page).to_not have_content question.links
    end

    scenario 'deletes link to another question' do
      sign_in(other_user)
      visit question_path(question)

      expect(page).to_not have_link 'Destroy link'
    end
  end

  context 'Answer with link' do
    given!(:question) { create(:question, user: user) }
    given!(:answer) { create(:answer, user: user, question: question) }
    given!(:link) { create(:link, linkable: answer) }

    background do
      visit question_path(question)
      expect(page).to have_content answer.body
    end

    scenario 'deletes link to his answer' do
      sign_in(user)
      visit question_path(question)

      within '.answers' do
        click_on 'Destroy answer link'
      end

      expect(page).to have_content 'Your link succesfully destroyed.'
      expect(page).to_not have_content answer.links
    end

    scenario 'deletes link to another answer' do
      sign_in(other_user)

      expect(page).to_not have_link 'Destroy answer link'
    end
  end
end
