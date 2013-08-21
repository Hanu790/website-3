class SessionsController < ApplicationController
	def new
	end

	
	def create	
		user = User.find_by_email(params[:session][:email].downcase)
		if user && user.authenticate(params[:session][:password])
			#redirect to profile
			sign_in user
			#tra ve profile hoac vi tri truoc khi dang nhap
			flash[:success] = "Hello #{user.name}!"
			redirect_back_or user
		else
			#flash error
			flash[:error]="Invalid Email or Password combination"
			render 'new'
		end
	end

	def destroy
		sign_out
		redirect_to root_url
	end
end
