RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question_with_answers) }
  let(:answer) { question.answers.first }
  
  describe "GET #index" do
    let(:answers) { question.answers }
    before { get :index, params: { question_id: question } }
  
    it "populates an array of all answers to current question" do
      expect(assigns(:answers)).to match_array(answers)
    end
  
    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe "GET #new" do
    before { get :new, params: { question_id: question } }

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe "GET #create" do
    let(:answers) { question.answers }

    context 'with valid attributes' do
      subject { post :create, params: { question_id: question, answer: attributes_for(:answer) } }

      it 'saves the new answer in the database' do
        expect{ subject }.to change(answers, :count).by(1)
      end

      it 'redirects to show view' do
        subject
        expect(response).to redirect_to question_answers_path(assigns(:question))
      end
    end

    context 'with invalid attributes' do
      let(:invalid_answer) { question.build(:invalid_answer) }
      subject { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) } }

      it 'does not save the answer' do
        expect{ subject }.to_not change(answers, :count)
      end

      it 're-renders new view' do
        subject
        expect(response).to render_template :new
      end
    end
  end

  describe "GET #show" do
    before { get :show, params: { question_id: question, id: answer } }

   it 'renders show view' do
     expect(response).to render_template :show
   end
 end
end
