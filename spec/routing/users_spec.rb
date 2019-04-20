require 'rails_helper.rb'

RSpec.describe 'users controller Routes', type: :routing do
  it 'POST users/:id #show' do
    expect(get: 'users/1').to route_to(action: 'show', controller: 'users', id: '1')
  end
end
