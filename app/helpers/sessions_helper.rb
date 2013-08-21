module SessionsHelper
	def sign_in(user)
		remember_token = User.new_remember_token
		if params[:remember_me]
			cookies.permanent[:remember_token]= {value: remember_token, expires: 1.month.from_now.utc}
		else
			cookies[:remember_token]= remember_token
		end
		
		user.update_attribute(:remember_token, User.encrypt(remember_token))
		self.current_user= user
	end

	def sign_out
		self.current_user= nil
		cookies.delete(:remember_token)
	end

	def current_user= (user)
		@current_user = user
	end
	def current_user?(user)
		user == current_user
	end
	def current_user
		remember_token = User.encrypt(cookies[:remember_token])
		@current_user ||= User.find_by_remember_token(remember_token)
	end

	def signed_in? #Signed roi
		!current_user.nil? #Current_user ko nil
	end

	#chuyen huong ng dung
	def redirect_back_or(default)
		redirect_to(session[:return_to]|| default)
		session.delete(:return_to)
	end
	#Luu tru location truoc do
	def store_location
		session[:return_to] = request.url
	end

end
