class Capa < ApplicationRecord
	validates :manga_id, :arquivo, presence: true
end
