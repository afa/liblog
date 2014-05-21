class Blog::CommentsController < ApplicationController
  before_action :get_post, :only => [:index, :new, :create]
  before_action :get_comment, :only => [:edit, :update, :show, :destroy]
  before_action :auth, only: [:new, :create]
  before_action :auth_edit, only: [:edit, :update]
  before_action :auth_rm, only: [:destroy]

  def new
    @comment = @post.comments.new
  end

  def create
    if @post.comments.create permitted_params.merge(commenter: current_user)
      redirect_to blog_post_comments_path(@post)
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @comment.update_attributes(permitted_params.merge(commenter: current_user)) #FIXME - user must be checked
      redirect_to blog_post_comments_path(@post)
    else
      render :edit
    end
  end

  def show
  end

  def index
    @comments = @post.comments
  end

  def destroy
    @comment.destroy
    redirect_to blog_post_comments_path(@comment.post)
  end
  private
  def get_post
    @post = Blog::Post.find(params[:post_id])
  end

  def get_comment
    @comment = Blog::Comment.find(params[:id])
    @post = @comment.post
    Rails.logger.info @comment.inspect
    Rails.logger.info @post.inspect
  end

  def auth
    redirect_to blog_post_comments_path(@post) unless can? :create, Blog::Comment
  end

  def auth_edit
    redirect_to blog_post_comments_path(@post) unless can? :edit, @comment
  end

  def auth_rm
    redirect_to blog_posts_path unless can? :delete, @comment
    #redirect_to blog_post_comments_path(@post) unless can? :delete, @comment
  end

  def permitted_params
    params.require(:comment).permit(:title, :text)
  end


 #def openid
 #  authenticate_with_open_id(params[:openid]) do |result, identity_url|
 #  case result.status
 #    when :missing
 #      openid_message  "Sorry, the OpenID server couldn't be found"
 #    when :invalid
 #      openid_message  "Sorry, but this does not appear to be a valid OpenID"
 #    when :canceled
 #      openid_message  "OpenID verification was canceled"
 #    when :failed
 #      openid_message  "Sorry, the OpenID verification failed"
 #    when :successful
 #      unless user = User.find_by_identity_url(identity_url)
 #        user = User.new(:identity_url => identity_url)
 #        user.save_with_autofill
 #        user.activate!
 #      end
 #      self.current_user = user
 #      redirect_to root_path
 #    end
 #
 #  end
 #
 # end


end
