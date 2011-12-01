class User
  include Ripple::Document
  property :todos, Array, :default => []

  on_conflict do |siblings|
    # resolution strategy is based upon sibling set-union.
    
    # due to the possibility of the application re-ordering todos,
    # conflicts can no longer be resolved using the id attribute only.

    # instead, a combination of id, order, and update attributes are used.

    # The basic approach is to flatten the list of siblings, then
    # iterate through a grouping of orders to select one order based upon the
    # highest update attribute.

    # this can probably be simplified, but after fiddling around for a while
    # this is what ended up working

=begin Debug Siblings
    puts "Siblings:\n"
    puts siblings
=end

    self.todos = siblings.map(&:todos).flatten

=begin Show the flat list.
    puts "Unresolved - Flat List:\n"
    puts todos
=end

    # a handy strategy for just dumping everything back to the client
    # at which point the browser can be used to initiate a deletes.
    # self.todos = self.todos.uniq { |t| t }

    # order / update time conflict strategy
    resolved = []
    self.todos.uniq { |u| u }.map{ |u| u['order'] }.uniq.each{ |u| resolved[u] = self.todos.uniq { |t| t }.group_by{ |t| t['order'] }[u].max{ |t| t['update'] } }
    self.todos = resolved.delete_if{ |t| t == nil }.uniq{ |t| t['id'] }
 
=begin Show the resolved list.
    puts "Resolved:\n"
    puts todos
=end

  end

  many :authorizations, :class_name => "Authorization"
end
