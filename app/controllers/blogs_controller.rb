class BlogsController < ApplicationController
  def index
    @blog_posts = Current.event.blog_posts.published.order date: :desc
  end

  def show
    @blog_post = BlogPost.find params[:id].to_i
  end
end
