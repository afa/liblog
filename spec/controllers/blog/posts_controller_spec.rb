require 'spec_helper'

describe Blog::PostsController do
  context "when anonymous" do
    before do
      sign_out
    end
    describe "GET 'index'" do
      it "returns http success" do
        get 'index'
        response.should be_success
      end
    end

    describe "GET 'show'" do
      before do
        @post = FactoryGirl.create(:post)
      end
      it "returns http success" do
        get 'show', id: @post.id
        response.should be_success
      end
    end

    describe "GET 'new'" do
      it "reddirects to blog" do
        get 'new'
        response.should redirect_to(blog_root_path)
      end
    end

     describe "POST 'create'" do
      it "reddirects to blog" do
        post 'create'
        response.should redirect_to(blog_root_path)
      end
    end

    describe "GET 'edit'" do
      before do
        @post = FactoryGirl.create(:post)
      end
      it "reddirects to blog" do
        get 'edit', id: @post.id
        response.should redirect_to(blog_root_path)
      end
    end

    describe "PUT 'update'" do
      before do
        @post = FactoryGirl.create(:post)
      end
      it "reddirects to blog" do
        put 'update', id: @post.id
        response.should redirect_to(blog_root_path)
      end
    end

    describe "DELETE 'destroy'" do
      before do
        @post = FactoryGirl.create(:post)
      end
      it "reddirects to blog" do
        delete 'destroy', id: @post.id
        response.should redirect_to(blog_root_path)
        Blog::Post.find(@post.id).should_not be_nil
      end
    end
  end

  context "when usr logged" do
    before do
      sign_in
    end
    describe "GET 'index'" do
      it "returns http success" do
        get 'index'
        response.should be_success
      end
    end

    describe "GET 'show'" do
      before do
        @post = FactoryGirl.create(:post)
      end
      it "returns http success" do
        get 'show', id: @post.id
        response.should be_success
      end
    end

    describe "GET 'new'" do
      it "returns http success" do
        get 'new'
        response.should be_success
      end
    end

    describe "GET 'edit'" do
      before do
        @post = FactoryGirl.create(:post)
      end
      it "returns http success" do
        get 'edit', id: @post.id
        response.should redirect_to(blog_root_path)
      end
    end

    describe "GET 'edit' my post" do
      before do
        @post = FactoryGirl.create(:post, user: @controller.current_user)
      end
      it "returns http success" do
        get 'edit', id: @post.id
        response.should be_success
      end
    end

    describe "POST 'create'" do
      before do
        @count = Blog::Post.count
      end
      it "reddirects to blogs" do
        post 'create', post: {text: ''} 
        response.should redirect_to(blog_posts_path)
        @count.should < Blog::Post.count
      end
    end

    describe "PUT 'update'" do
      before do
        @post = FactoryGirl.create(:post)
      end
      it "reddirects to blog" do
        put 'update', id: @post.id, text: 'to edit'
        response.should redirect_to(blog_root_path)
        Blog::Post.find(@post.id).text.should_not == 'to edit'
      end
    end

    describe "PUT 'update' my post" do
      before do
        @post = FactoryGirl.create(:post, user: @controller.current_user)
      end
      it "reddirects to blogs" do
        put 'update', id: @post.id, post: {text: 'to edit'}
        response.should redirect_to(blog_posts_path)
        Blog::Post.find(@post.id).text.should == 'to edit'
      end
    end

    describe "DELETE 'destroy'" do
      before do
        @post = FactoryGirl.create(:post)
      end
      it "reddirects to blog" do
        delete 'destroy', id: @post.id
        response.should redirect_to(blog_root_path)
        Blog::Post.find(@post.id).should_not be_nil
      end
    end
    describe "DELETE 'destroy' my post" do
      before do
        @post = FactoryGirl.create(:post, user: @controller.current_user)
      end
      it "reddirects to blog" do
        delete 'destroy', id: @post.id
        response.should redirect_to(blog_posts_path)
        Blog::Post.where(id: @post.id).should_not be_exist
      end
    end
  end

end
