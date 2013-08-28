class PostsController < ApplicationController
  before_filter :signed_in_user, only: [:create, :destroy,:new]

  def new
  	@post = Post.new
  end

  def create 
    @post = current_user.posts.build(post_params)
    if @post.save
      flash[:success]="Post created!"
      redirect_to current_user
    else
      render 'new'
    end
  end

  def index
  	@posts = Post.all
  end

  def edit

  end

  def show
    
  	@post = Post.find(params[:id])
    # @user = @post.user
     #render :json => @post.to_json
    # render :json => @user.to_json
     #return
  end


  private
    def post_params
      params.require(:post).permit(:title,:content)
    end
end
