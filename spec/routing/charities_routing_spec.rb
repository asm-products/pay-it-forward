require 'rails_helper'

RSpec.describe CharitiesController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/charities').to route_to('charities#index')
    end

    it 'routes to #new' do
      expect(get: '/charities/new').to route_to('charities#new')
    end

    it 'routes to #show' do
      expect(get: '/charities/1').to route_to('charities#show', id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/charities/1/edit').to route_to('charities#edit', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/charities').to route_to('charities#create')
    end

    it 'routes to #update' do
      expect(put: '/charities/1').to route_to('charities#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/charities/1').to route_to('charities#destroy', id: '1')
    end
  end
end
