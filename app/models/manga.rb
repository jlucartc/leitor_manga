class Manga < ApplicationRecord
	validates :titulo, :descricao, :usuario_id, presence: true
	validates :finalizado, inclusion: [true,false]
	after_destroy :destroy_capitulos, :destroy_capa, :destroy_favoritos
	has_one :capa
	has_many :capitulos
	has_many :favoritos
	belongs_to :usuario

	def destroy_capitulos
		Capitulo.where(manga_id: self.id).destroy_all
	end

	def destroy_capa
		Capa.where(manga_id: self.id).destroy_all
	end

	def destroy_favoritos
		Favorito.where(manga_id: self.id).destroy_all
	end

end
