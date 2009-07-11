class CommentsController < ApplicationController
  def index
   @post = BlogPost.find(params[:blog_id])
   @comments = @post.comments
  end
  def show
   @comment = BlogComment.find params[:id]
  end
  def new
   @parent = BlogComment.find params[:id] if params.has_key? :id
   @post = BlogPost.find params[:blog_id]
   @comment = BlogComment.new :blog_comment_id=>(@parent ? @parent.id : nil), :blog_post_id=>@post.id
  end
  def create
   if BlogComment.create(params[:comment])
    redirect_to :action=>'index'
   else
    render :action=>'new'
   end
  end
  def edit
  end
  def update
  end
  def delete
  end
end
