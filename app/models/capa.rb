class Capa < ApplicationRecord
	belongs_to :manga
	validates :manga_id, :arquivo, presence: true
end
