class UsersController < ApplicationController
	before_filter :non_signed_in_user, only: [:index, :edit, :update, :destroy, :show]
	before_filter :correct_user, only: [:edit, :update, :edit_password,:update_password]
	before_filter :admin_user, only: :destroy
	helper_method :sort_direction, :sort_column
	def index
		@users = sort

	end

	def new
		@user = User.new
	end
	def create
		#@user = User.new(params[:user])
		@user = User.new(user_params)
		if @user.save
			#Send Email to confirmation
			UserMailer.registration_confirmation(@user).deliver
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
		@posts = @user.posts(params[:id])
		#render :json => @posts.to_json
 		#return
	end
	def edit		
		# @user = User.find(params[:id])
	end
	def update
		# @user = User.find(params[:id])
		if @user.update_attributes(user_params)
			# Handle a successful update.
			flash[:success] = "Profile updated"
			sign_in @user
			redirect_to @user
		else
			render'edit'
		end
	end
	def destroy
		User.find(params[:id]).destroy
		flash[:success] = "User destroyed."
		redirect_to users_url
	end


	#Edit and update new password
	def edit_password
		# Do da def correct_user nen co the bo @user=User.find(paramas[:id])
		#could be same content as edit
		#@user = User.find(params[:id])
	end
	def update_password
		#code to update new password(only password)
		# @user = User.find(params[:id])
			# render :json => @user.to_json
			# return
		user = User.find_by_email(current_user.email).try(:authenticate, params[:current_password])
		if user && @user.update_attributes(user_params)
			flash[:success] = "Your password has changed."
			sign_in @user
			redirect_to @user
		else
			flash.now[:error] = "Incorrect current password."
			sign_in @user
			render 'edit_password'
		end
	end


 private
	#Nếu ko là user_admin thì ko cho vao userlist
	def admin_user
		redirect_to(root_url) unless current_user.admin?
	end

	#Nếu User chua dang nhap thì bat dang nhap
	def non_signed_in_user
		#redirect_to signin_url, notice: "Please sign in." unless signed_in?
		unless signed_in?
			store_location #lay vi tri hien tai khi request url.
			flash[:notice] =" Please sign in."
			redirect_to signin_url
		end
	end

	# Dung' user ko?
	def correct_user
		@user= User.find(params[:id])
		redirect_to (root_url) unless current_user?(@user)
	end

	#Sort Colum table Section

	#Sort_default
	def sort
		#User.order(sort_column + " " + sort_direction).page(params[:page])
		User.paginate(	:page => params[:page], per_page: 10, 
					  	order: (sort_column + " " + sort_direction))
	end

	def sort_column
		User.column_names.include?(params[:sort]) ? params[:sort] :  "id"
	end

	def sort_direction
		%w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
	end
end

