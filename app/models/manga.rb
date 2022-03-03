class Manga < ApplicationRecord
	validates :titulo, :descricao, :usuario_id, presence: true
	after_destroy :destroy_capitulos, :destroy_capa
	has_one :capa
	has_many :favoritos
	belongs_to :usuario

	def destroy_capitulos
		Capitulo.where(manga_id: self.id).destroy_all
	end

	def destroy_capa
		Capa.where(manga_id: self.id).destroy_all
	end

	def capa_path
		if self.capa.present?
			folder_path = "public/tmp/#{self.usuario_id}"
			capa = Capa.where(manga_id: self.id).first
			
			if !Dir.exist?(folder_path)
				Dir.mkdir(folder_path)
			end

			image_path = "#{folder_path}/#{capa.id}"

			if !File.exists?(image_path)
				arquivo = File.open(image_path,'wb')
				arquivo.write(capa.arquivo)
			end

			File.open(image_path).path.gsub(/^.*public/,'')
		else
			"/dummy.png"
		end
	end

end
