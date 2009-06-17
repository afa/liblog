class AjaxController < ApplicationController
  def index
  end
  def todo_add_child
   if params[:submit] then
    parent = ToDo.find params[:id]
    respond_to do | wants |
     wants.js {
     wants.hide("childs_#{ parent.id.to_s }") 
     }
    end
   end
  end
  def todo_child_form
  end

end
