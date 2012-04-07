# coding: UTF-8
module ToDoHelper
 def todo_render(collection, opts = {} )
  render :partial=>'to_do/todo', :collection=>collection, :locals=>{ :opts=>opts }
 end
end
