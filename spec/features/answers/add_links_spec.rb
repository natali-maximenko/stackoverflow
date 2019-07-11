feature 'User can add links to answer' do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:gist_url) { 'https://gist.github.com/vkurennov/743f9367caa1039874af5a2244e1b44c' }

  scenario 'User adds link when asks answer', js: true do
    sign_in(user)
    visit question_path(question)

    fill_in 'Your answer', with: 'My answer'

    click_on 'Add link'
    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_button 'Reply'

    within '.answers' do
      expect(page).to have_link 'My gist', href: gist_url
    end
  end
end