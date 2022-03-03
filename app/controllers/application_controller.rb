class ApplicationController < ActionController::Base

	def after_sign_in_path_for(resource)
		meus_mangas_path
	end

	def after_sign_out_path_for(resource)
		new_usuario_session_path
	end

	def index
		redirect_to new_usuario_session_path
	end

end
