require 'rails_helper'

RSpec.describe Admin::DataSetsController, type: :routing do
  describe 'routing' do
    it 'routes to #new' do
      expect(get: '/admin/data_sets/new').to route_to('admin/data_sets#new')
    end

    it 'routes to #show' do
      expect(get: '/admin/data_sets/1').to route_to('admin/data_sets#show', id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/admin/data_sets/1/edit').to route_to('admin/data_sets#edit', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/admin/data_sets').to route_to('admin/data_sets#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/admin/data_sets/1').to route_to('admin/data_sets#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/admin/data_sets/1').to route_to('admin/data_sets#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/admin/data_sets/1').to route_to('admin/data_sets#destroy', id: '1')
    end
  end
end
