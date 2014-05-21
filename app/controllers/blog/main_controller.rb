class Blog::MainController < ApplicationController
  def dashboard
    #todo: добавить обработку состояний (active)
    @posts = Blog::Post.lasts.paginate(page: params[:page])
    @comments = Blog::Comment.lasts.limit(5)
  end
end
