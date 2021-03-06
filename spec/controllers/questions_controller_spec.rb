RSpec.describe QuestionsController, type: :controller do
  let!(:user) { create(:user) }
  let!(:user2) { create(:user) }

  describe 'GET #index' do
    let!(:questions) { create_list(:question, 2) }
    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end
  
  describe 'GET #show' do
    let!(:question) { create(:question, user: user) }
    before { get :show, params: { id: question } }
  
    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before do
        login(user)
        get :new
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      let(:question) { create(:question) }
      subject { post :create, params: { question: attributes_for(:question) } }
  
      it 'saves the new question in the database' do
        expect{ subject }.to change(Question, :count).by(1)
      end

      it 'saves question by current user' do
        expect{ subject }.to change(user.questions, :count).by(1)
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

  describe 'POST #like' do
    let!(:question) { create(:question, user: user) }
    before { login(user2) }

    it 'saves a new vote in the database' do
      expect { post :like, params: { id: question.id, format: :json } }.to change(question.votes, :count).by(1)
    end
  end

  describe 'POST #dislike' do
    let!(:question) { create(:question, user: user) }
    before { login(user2) }

    it 'saves a new vote in the database' do
      expect { post :like, params: { id: question.id, format: :json } }.to change(question.votes, :count).by(1)
    end
  end

  describe 'PATCH #update' do
    let!(:question) { create(:question, user: user) }
    before { login(user) }

    context 'with valid attributes' do
      it 'assings the requested question to @question' do
        patch :update, params: { id: question, question: attributes_for(:question) }, format: :js
        expect(assigns(:question)).to eq question
      end

      it 'changes question attributes' do
        patch :update, params: { id: question, question: { title: 'new title', body: 'new body' } }, format: :js
        question.reload

        expect(question.title).to eq 'new title'
        expect(question.body).to eq 'new body'
      end

      it 'renders update template' do
        patch :update, params: { id: question, question: attributes_for(:question) }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      before { patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js }

      it 'does not change question' do
        question.reload

        expect(question.body).to eq 'MyText'
      end

      it 'render updated template' do
        expect(response).to render_template :update
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:question) { create(:question, user: user) }
    let(:questions) { user.questions }

    context 'owner' do
      before { login(user) }

      it 'deletes question' do
        expect{ delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
      end

      it 'redirect to index view' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end

    context 'not owner' do
      before { login(user2) }
      subject { delete :destroy, params: { id: question } }

      it 'not deletes question' do
        expect{ subject }.to_not change(Question, :count)
      end

      it 'redirect to root path' do
        subject
        expect(response).to redirect_to root_path
      end
    end
  end
end
