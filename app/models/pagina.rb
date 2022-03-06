class Pagina < ApplicationRecord
	belongs_to :capitulo
	validates :capitulo_id, :sequencia, :arquivo, presence: true
	validates :nome, uniqueness: true
	before_create :escolhe_nome
	after_destroy :ajusta_sequencia

	def escolhe_nome
		nome = "#{SecureRandom.hex(20)}_"
		if Pagina.where(nome: nome).present?
			escolhe_nome
		else
			self.nome = nome
		end 
	end

	def ajusta_sequencia
		if Pagina.where("capitulo_id = ? and sequencia = ?",self.capitulo_id,self.sequencia).empty?
			paginas = Pagina.where("capitulo_id = ? and sequencia > ?",self.capitulo_id,self.sequencia)
			paginas.each do |pagina|
				pagina.update(sequencia: pagina.sequencia-1)
			end
		end
	end

	def sequencia_data
		{nome: self.nome,sequencia: self.sequencia}.to_json
	end

	def path
		arquivos_existentes = Dir.glob("#{self.nome}*\.jpeg",base: "#{Rails.public_path.to_s}/tmp/paginas")
		if arquivos_existentes.empty?
			pagina = Tempfile.new([self.nome,'.jpeg'],"#{Rails.public_path.to_s}/tmp/paginas",binmode: true)
			pagina.write(self.arquivo)
			pagina.path.gsub(/^.+\/public/,'')
		else
			arquivos_existentes.each do |arquivo|
				File.delete("#{Rails.public_path.to_s}/tmp/paginas/#{arquivo}")
			end
			path
		end
	end

end
