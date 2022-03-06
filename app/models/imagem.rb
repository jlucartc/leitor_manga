class Imagem < ApplicationRecord
	belongs_to :capitulo
	validates :capitulo_id, :sequencia, :arquivo, presence: true
	validates :nome, uniqueness: true
	before_create :escolhe_nome
	after_destroy :ajusta_sequencia

	def escolhe_nome
		nome = "#{SecureRandom.hex(20)}_"
		if Imagem.where(nome: nome).present?
			escolhe_nome
		else
			self.nome = nome
		end 
	end

	def ajusta_sequencia
		if Imagem.where("capitulo_id = ? and sequencia = ?",self.capitulo_id,self.sequencia).empty?
			imagens = Imagem.where("capitulo_id = ? and sequencia > ?",self.capitulo_id,self.sequencia)
			imagens.each do |imagem|
				imagem.update(sequencia: imagem.sequencia-1)
			end
		end
	end

	def sequencia_data
		{nome: self.nome,sequencia: self.sequencia}.to_json
	end

	def path
		arquivos_existentes = Dir.glob("#{self.nome}*\.jpeg",base: "#{Rails.public_path.to_s}/tmp/capitulos")
		if arquivos_existentes.empty?
			imagem = Tempfile.new([self.nome,'.jpeg'],"#{Rails.public_path.to_s}/tmp/capitulos",binmode: true)
			imagem.write(self.arquivo)
			imagem.path.gsub(/^.+\/public/,'')
		else
			arquivos_existentes.each do |arquivo|
				File.delete("#{Rails.public_path.to_s}/tmp/capitulos/#{arquivo}")
			end
			path
		end
	end

end
