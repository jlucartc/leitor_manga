class Favorito < ApplicationRecord
	belongs_to :usuario
	belongs_to :manga
	validates :manga_id, uniqueness: { scope: :usuario_id }
end
