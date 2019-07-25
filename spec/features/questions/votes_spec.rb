feature 'Votes for question' do
  given!(:user) { create(:user) }
  given!(:girl) { create(:user) }
  given!(:question) { create(:question, user: girl) }

  describe 'Authenticated user' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'try to like not his question', js: true do
      within ".question_#{question.id}" do
        within '.question_votes' do
          click_on 'Up!'

          within '.question_rating' do
            expect(page).to have_content question.rating
          end
        end
      end
    end

    scenario 'try to dislike not his question', js: true do
      within ".question_#{question.id}" do
        within '.question_votes' do
          click_on 'Down'

          within '.question_rating' do
            expect(page).to have_content question.rating
          end
        end
      end
    end
  end

  scenario 'Author of question does not see the voting links' do
    sign_in(girl)
    visit question_path(question)

    within ".question_#{question.id}" do
      within '.question_votes' do
        expect(page).to_not have_link 'Up!'
        expect(page).to_not have_link 'Down'
      end
    end
  end

  scenario 'Non-authenticated user does not see the voting links' do
    visit question_path(question)

    within ".question_#{question.id}" do
      within '.question_votes' do
        expect(page).to_not have_link 'Up!'
        expect(page).to_not have_link 'Down'
      end
    end
  end
end
