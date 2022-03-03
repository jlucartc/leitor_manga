class Imagem < ApplicationRecord
	validates :capitulo_id, :sequencia, :arquivo, presence: true
end
