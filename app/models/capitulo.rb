class Capitulo < ApplicationRecord
	has_many :imagens
	belongs_to :manga
	validates :manga_id, presence: true
	validates :titulo, presence: true
	validates :sequencia, uniqueness: {scope: :manga_id}
	before_create :atribui_sequencia
	after_destroy :destroy_imagens, :ajusta_sequencia

	def atribui_sequencia
		capitulos = Capitulo.where(manga_id: self.manga_id)
		if capitulos.empty?
			self.sequencia = 1
		else
			self.sequencia = capitulos.last.sequencia+1
		end
	end

	def ajusta_sequencia
		Capitulo.where('manga_id = ? and sequencia > ?',self.manga_id,self.sequencia).each do |capitulo|
			capitulo.update(sequencia: capitulo.sequencia-1)
		end
	end

	def destroy_imagens
		Imagem.where(capitulo_id: self.id).destroy_all
	end

end
