class Admin::BlogPostsController < Admin::ApplicationController
  def index
    @blog_posts = scope event.blog_posts.includes(:author)
  end

  def show
    @blog_post = BlogPost.find params[:id]
  end

  def new
    @blog_post = event.blog_posts.new
  end

  def create
    @blog_post = event.blog_posts.new(**blog_post_params)

    if @blog_post.save
      redirect_to admin_event_blog_posts_path(@blog_post.event), notice: "Blog post created"
    else
      render :new
    end
  end

  def update
    @blog_post = BlogPost.find params[:id]

    if @blog_post.update blog_post_params
      redirect_to admin_event_blog_posts_path(@blog_post.event), notice: "Blog post updated"
    else
      render :show
    end
  end

  private

  def blog_post_params = params.require(:blog_post).permit(:event_id, :author_id, :title, :date, :content, :published)
  def event = Event.find(params[:event_id])
end
