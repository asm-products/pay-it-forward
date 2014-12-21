require 'rails_helper'

RSpec.describe CharitiesController, type: :controller do

  let(:valid_attributes) { { name: 'Charity' } }

  let(:invalid_attributes) { { name: nil } }

  let(:valid_session) { {} }

  before(:each) do
    skip('add user auth^2')
  end

  describe 'GET index' do
    it 'assigns all charities as @charities' do
      charity = Charity.create! valid_attributes
      get :index, {}, valid_session
      expect(assigns(:charities)).to eq([charity])
    end
  end

  describe 'GET show' do
    it 'assigns the requested charity as @charity' do
      charity = Charity.create! valid_attributes
      get :show, { id: charity.to_param }, valid_session
      expect(assigns(:charity)).to eq(charity)
    end
  end

  describe 'GET new' do
    it 'assigns a new charity as @charity' do
      get :new, {}, valid_session
      expect(assigns(:charity)).to be_a_new(Charity)
    end
  end

  describe 'GET edit' do
    it 'assigns the requested charity as @charity' do
      charity = Charity.create! valid_attributes
      get :edit, { id: charity.to_param }, valid_session
      expect(assigns(:charity)).to eq(charity)
    end
  end

  describe 'POST create' do
    describe 'with valid params' do
      it 'creates a new Charity' do
        expect do
          post :create, { charity: valid_attributes }, valid_session
        end.to change(Charity, :count).by(1)
      end

      it 'assigns a newly created charity as @charity' do
        post :create, { charity: valid_attributes }, valid_session
        expect(assigns(:charity)).to be_a(Charity)
        expect(assigns(:charity)).to be_persisted
      end

      it 'redirects to the created charity' do
        post :create, { charity: valid_attributes }, valid_session
        expect(response).to redirect_to(Charity.last)
      end
    end

    describe 'with invalid params' do
      it 'assigns a newly created but unsaved charity as @charity' do
        post :create, { charity: invalid_attributes }, valid_session
        expect(assigns(:charity)).to be_a_new(Charity)
      end

      it "re-renders the 'new' template" do
        post :create, { charity: invalid_attributes }, valid_session
        expect(response).to render_template('new')
      end
    end
  end

  describe 'PUT update' do
    describe 'with valid params' do
      let(:new_attributes) do
        { name: 'New Charity', description: 'Free Stuff' }
      end

      it 'updates the requested charity' do
        charity = Charity.create! valid_attributes
        put :update, { id: charity.to_param, charity: new_attributes }, valid_session
        charity.reload

        expect(charity.name).to eq 'New Charity'
        expect(charity.description).to eq 'Free Stuff'
      end

      it 'assigns the requested charity as @charity' do
        charity = Charity.create! valid_attributes
        put :update, { id: charity.to_param, charity: valid_attributes }, valid_session
        expect(assigns(:charity)).to eq(charity)
      end

      it 'redirects to the charity' do
        charity = Charity.create! valid_attributes
        put :update, { id: charity.to_param, charity: valid_attributes }, valid_session
        expect(response).to redirect_to(charity)
      end
    end

    describe 'with invalid params' do
      it 'assigns the charity as @charity' do
        charity = Charity.create! valid_attributes
        put :update, { id: charity.to_param, charity: invalid_attributes }, valid_session
        expect(assigns(:charity)).to eq(charity)
      end

      it "re-renders the 'edit' template" do
        charity = Charity.create! valid_attributes
        put :update, { id: charity.to_param, charity: invalid_attributes }, valid_session
        expect(response).to render_template('edit')
      end
    end
  end

  describe 'DELETE destroy' do
    it 'destroys the requested charity' do
      charity = Charity.create! valid_attributes
      expect do
        delete :destroy, { id: charity.to_param }, valid_session
      end.to change(Charity, :count).by(-1)
    end

    it 'redirects to the charities list' do
      charity = Charity.create! valid_attributes
      delete :destroy, { id: charity.to_param }, valid_session
      expect(response).to redirect_to(charities_url)
    end
  end

end
