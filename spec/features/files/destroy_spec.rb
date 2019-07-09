feature "Destroy files", type: :feature do
  given!(:user) { create(:user) }
  given!(:other_user) { create(:user) }
  
  context 'Question with file' do
    given!(:question) { create(:question_with_file, user: user) }

    background do
      visit questions_path
      expect(page).to have_content question.title
    end

    scenario 'deletes file to his question' do
      sign_in(user)
      visit question_path(question)

      click_on 'Destroy file'

      expect(page).to have_content 'Your file succesfully destroyed.'
      expect(page).to_not have_content question.files
    end

    scenario 'deletes file to another question' do
      sign_in(other_user)
      visit question_path(question)

      expect(page).to_not have_link 'Destroy file'
    end
  end

  context 'Answer with file' do
    given!(:question) { create(:question, user: user) }
    given!(:answer) { create(:answer_with_file, user: user, question: question) }

    background do
      visit question_path(question)
      expect(page).to have_content answer.body
    end

    scenario 'deletes file to his answer' do
      sign_in(user)
      visit question_path(question)

      within '.answers' do
        click_on 'Destroy answer file'
      end

      expect(page).to have_content 'Your file succesfully destroyed.'
      expect(page).to_not have_content answer.files
    end

    scenario 'deletes file to another answer' do
      sign_in(other_user)

      expect(page).to_not have_link 'Destroy answer file'
    end
  end
end
