class UsersController < ApplicationController
	def index

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
	end
end

