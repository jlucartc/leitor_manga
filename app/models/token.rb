class Token < ApplicationRecord
	validates :codigo, uniqueness: true;
	belongs_to :usuario
	before_create :gera_codigo

	def gera_codigo
		self.codigo = SecureRandom.hex(20);
		gera_codigo if Token.where(codigo: self.codigo).present?
	end

end
