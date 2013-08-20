class UsersController < ApplicationController
	#before_filter :signed_in_user, only: [:index, :edit, :update, :destroy]
	#before_filter :correct_user, only: [:edit, :update]
	before_filter :admin_user, only: :destroy

	def index
		@users= User.all
	end
	def new
		@user = User.new
	end
	def create
		#@user = User.new(params[:user])
		@user = User.new(user_params)
		if @user.save
			#handle successfully
			sign_in @user
			flash.now[:success]="Account has created!"
			redirect_to @user
		else
			#handle fail
			render 'new'
		end
	end
	def show
		@user = User.find(params[:id])
		#render :json => @user.to_json
   		#return
	end
	def edit		
	end
	def update
	end
	def destroy
		User.find(params[:id]).destroy
		flash[:success] = "User destroyed."
		redirect_to users_url
	end


	#Nếu ko là user_admin thì ko cho vao userlist
	def admin_user
		redirect_to(root_url) unless current_user.admin?
	end
end

