require 'spec_helper'

describe User do  
  before do
    User.bucket.allow_mult=true
  end
  
  it 'should resolve conflicting todos' do
    u = User.create! :todos => []

    u1 = User.find(u.key)
    u2 = User.find(u.key)

    u1.todos = [{'id' => 'foo'}]
    u1.save
    
    u2.todos = [{'id' => 'bar'}]
    u2.save!

    User.find(u.key).todos.map { |t| t['id'] }.sort.should == ['bar', 'foo']
  end
end
