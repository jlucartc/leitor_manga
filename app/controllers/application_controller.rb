class ApplicationController < ActionController::Base

	def after_sign_in_path_for(resource)
	end

	def after_sign_out_path_for(resource)
	end

	def index
		@posts = Post.all
	end

end
