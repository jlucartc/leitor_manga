class Favorito < ApplicationRecord
	validates :manga_id, uniqueness: { scope: :usuario_id }
end
