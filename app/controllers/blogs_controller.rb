class BlogsController < ApplicationController
  def show
    @blog_post = BlogPost.find params[:id].to_i
  end
end
