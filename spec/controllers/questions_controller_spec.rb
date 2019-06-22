RSpec.describe QuestionsController, type: :controller do
    let(:question) { create(:question) }

    describe 'GET #index' do
      let(:questions) { create_list(:question, 2) }
      before { get :index }
  
      it 'populates an array of all questions' do
        expect(assigns(:questions)).to match_array(questions)
      end
  
      it 'renders index view' do
        expect(response).to render_template :index
      end
    end
    
    describe 'GET #show' do
      before { get :show, params: { id: question } }
    
      it 'assings the requested question to @question' do
        expect(assigns(:question)).to eq question
      end
    
      it 'renders show view' do
        expect(response).to render_template :show
      end
    end

    describe 'GET #new' do
      before { get :new }

      it 'assigns a new Question to @question' do
        expect(assigns(:question)).to be_a_new(Question)
      end

      it 'renders new view' do
        expect(response).to render_template :new
      end
    end

    describe 'POST #create' do
      context 'with valid attributes' do
        let(:question) { create(:question) }
        subject { post :create, params: { question: attributes_for(:question) } }
    
        it 'saves the new question in the database' do
          expect{ subject }.to change(Question, :count).by(1)
        end
    
        it 'redirects to show view' do
          subject
          expect(response).to redirect_to question_path(assigns(:question))
        end
      end
    
      context 'with invalid attributes' do
        subject { post :create, params: { question: attributes_for(:question, :invalid) } }
    
        it 'does not save the question' do
          expect{ subject }.to_not change(Question, :count)
        end
    
        it 're-renders new view' do
          subject
          expect(response).to render_template :new
        end
      end
    end
end
