class Capa < ApplicationRecord
	belongs_to :manga
	validates :manga_id, :arquivo, presence: true
	validates :nome, uniqueness: true
	before_create :escolhe_nome

	def escolhe_nome
		nome = "#{SecureRandom.hex(20)}_"
		if Capa.where(nome: nome).present?
			escolhe_nome
		else
			self.nome = nome
		end 
	end

	def path
		arquivos_existentes = Dir.glob("#{self.nome}*\.jpeg",base: "#{Rails.public_path.to_s}/tmp/capas")
		if arquivos_existentes.empty?
			capa = Tempfile.new([self.nome,'.jpeg'],"#{Rails.public_path.to_s}/tmp/capas",binmode: true)
			capa.write(self.arquivo)
			capa.path.gsub(/^.+\/public/,'')
		else
			arquivos_existentes.each do |arquivo|
				File.delete("#{Rails.public_path.to_s}/tmp/capas/#{arquivo}")
			end
			path
		end
	end

end
