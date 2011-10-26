class User
  include Ripple::Document
  property :todos, Array, :default => []

  on_conflict do |siblings|
    # set-union siblings
    self.todos = siblings.map(&:todos).flatten.uniq { |t| t['id'] }
  end

  many :authorizations, :class_name => "Authorization"
end
