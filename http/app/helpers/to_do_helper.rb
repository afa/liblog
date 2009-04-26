module ToDoHelper
 def todo_render(collection, max_depth = 0 )
  render :partial=>'to_do/todo', :collection=>collection, :locals=>{ :max_depth=>max_depth }
 end
end
