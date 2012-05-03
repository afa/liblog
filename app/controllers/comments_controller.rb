# coding: UTF-8
class CommentsController < ApplicationController

 before_filter :get_post, :only=>[:index, :new, :create]

  def index
   @comments = @post.comments
  end

  def show
   @comment = BlogComment.find params[:id]
  end

  def new
   @parent = BlogComment.find params[:id] if params.has_key? :id
   @comment = BlogComment.new :blog_comment_id=>(@parent ? @parent.id : nil), :blog_post_id=>@post.id
  end

  def add

  end

  def create
   if BlogComment.create(params[:comment].merge( {:user=>current_user}))
    redirect_to blog_comments_path(@post)
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

protected

  def get_post
   @post = BlogPost.find params[:blog_id]
  end

  def openid_message(message)
   flash[:notice] = message
   redirect_to new_session_path

  end

end
 def openid
   authenticate_with_open_id(params[:openid]) do |result, identity_url|
   case result.status
     when :missing
       openid_message  "Sorry, the OpenID server couldn't be found"
     when :invalid
       openid_message  "Sorry, but this does not appear to be a valid OpenID"
     when :canceled
       openid_message  "OpenID verification was canceled"
     when :failed
       openid_message  "Sorry, the OpenID verification failed"
     when :successful
       unless user = User.find_by_identity_url(identity_url)
         user = User.new(:identity_url => identity_url)
         user.save_with_autofill
         user.activate!
       end
       self.current_user = user
       redirect_to root_path
     end

   end

 end

