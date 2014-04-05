require 'spec_helper'

describe Blog::CommentsController do
  context "when anonymous" do
    before do
      sign_out
      @post = FactoryGirl.create :post
    end
    describe "GET 'index'" do
      it "returns http success" do
        get 'index', post_id: @post.id
        response.should be_success
      end
    end

    describe "GET 'show'" do
      before do
        @comment = FactoryGirl.create(:comment)
      end
      it "returns http success" do
        get 'show', id: @comment.id
        response.should be_success
      end
    end

    describe "GET 'new'" do
      it "reddirects to blog" do
        get 'new', post_id: @post.id
        response.should redirect_to(blog_post_comments_path(@post))
      end
    end

    describe "GET 'edit'" do
      before do
        @comment = FactoryGirl.create(:comment)
      end
      it "reddirects to blog" do
        get 'edit', id: @comment.id
        response.should redirect_to(blog_post_comments_path(@comment.post))
      end
    end
  end
  context "when usr logged" do
    before do
      sign_in
      @post = FactoryGirl.create :post
    end
    describe "GET 'index'" do
      it "returns http success" do
        get 'index', post_id: @post.id
        response.should be_success
      end
    end

    describe "GET 'show'" do
      before do
        @comment = FactoryGirl.create(:comment)
      end
      it "returns http success" do
        get 'show', id: @comment.id
        response.should be_success
      end
    end

    describe "GET 'new'" do
      it "returns http success" do
        get 'new', post_id: @post.id
        response.should be_success
      end
    end

    describe "GET 'edit'" do
      before do
        @comment = FactoryGirl.create(:comment)
      end
      it "returns http success" do
        get 'edit', id: @comment.id
        response.should redirect_to(blog_post_comments_path(@comment.post))
      end
    end

    describe "DELETE 'destroy'" do
      before do
        @comment = FactoryGirl.create(:comment)
      end
      it "returns http success" do
        delete 'destroy', id: @comment.id
        response.should redirect_to(blog_post_comments_path(@comment.post))
      end
    end
    context "and accessing comment of my post" do
      before do
        @post = FactoryGirl.create(:post, user: @controller.current_user)
        @comment = FactoryGirl.create(:comment, post: @post)
      end
      describe "GET 'edit'" do
        it "should return http success" do
          get 'edit', id: @comment.id
          response.should be_success
        end
      end
      describe "DELETE 'destroy'" do
        it "should successfully redirect to comments" do
          delete 'destroy', id: @comment.id
          response.should redirect_to(blog_post_comments_path(@post))
          Blog::Comment.where(id: @comment.id).should_not be_exist
        end
      end
    end
    context "and accessing my comment" do
      describe "GET 'edit'" do
        before do
          @comment = FactoryGirl.create(:comment, commenter: @controller.current_user)
        end
        it "returns http success" do
          get 'edit', id: @comment.id
          response.should be_success
        end
      end
    end
  end
end
