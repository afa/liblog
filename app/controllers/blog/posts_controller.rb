class Blog::PostsController < ApplicationController
  respond_to :xml

  before_action :get_posts, only: [:index]
  before_action :get_post, only: [:show, :edit, :update, :destroy]
  before_action :auth, only: [:new, :create, :edit, :update, :destroy]
  before_action :auth_edit, only: [:edit, :update]
  before_action :auth_rm, only: [:destroy]

  def rss
    #вынести в экспорт
  end

  def index
  end

  def show
  end

  def new
    @post = current_user.blog_posts.new
  end

  def edit
  end

  def create
    if current_user.blog_posts.create(permitted_params)
      redirect_to blog_posts_path
    else
      render :new
    end
  end

  def update
    if @post.update_attributes(permitted_params)
      redirect_to blog_posts_path
    else
      render :edit
    end
  end

  def destroy
    @post.destroy
    redirect_to blog_posts_path
  end
  protected

  def get_post
   @post = Blog::Post.find params[:id] unless @post
  end

  def get_posts
    @posts = Blog::Post.lasts.paginate(page: params[:page])
  end

  private
  def permitted_params
    params.require(:blog_post).permit(:title, :text, :name)
  end

  def auth
    redirect_to blog_root_path unless can? :create, Blog::Post
  end

  def auth_edit
    redirect_to blog_root_path unless can? :edit, @post
  end

  def auth_rm
    redirect_to blog_root_path unless can? :destroy, @post
  end
end
