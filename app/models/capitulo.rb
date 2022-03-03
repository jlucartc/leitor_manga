class Capitulo < ApplicationRecord
	validates :manga_id, presence: true
	validates :titulo, presence: true
	after_destroy :destroy_imagens

	def destroy_imagens
		Imagem.where(capitulo_id: self.id).destroy_all
	end

end
