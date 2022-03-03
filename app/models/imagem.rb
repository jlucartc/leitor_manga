class Imagem < ApplicationRecord
	belongs_to :capitulo
	validates :capitulo_id, :sequencia, :arquivo, presence: true
end
