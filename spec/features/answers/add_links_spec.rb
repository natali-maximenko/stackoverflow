feature 'User can add links to answer' do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given(:gist_url) { 'https://gist.github.com/vkurennov/743f9367caa1039874af5a2244e1b44c' }

  background do
    sign_in(user)
    visit question_path(question)

    fill_in 'Your answer', with: 'My answer'
    click_on 'Add link'
  end

  scenario 'User adds link when add answer', js: true do
    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_button 'Reply'

    within '.answers' do
      expect(page).to have_link 'My gist', href: gist_url
    end
  end

  scenario 'User try add invalid links when add answer' do
    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: 'yandex.ru'
    
    click_button 'Reply'

    within '.answers' do
      expect(page).to have_content 'yandex.ru is not a valid url'
    end
  end
end