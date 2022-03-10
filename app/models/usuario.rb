class Usuario < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :favoritos
  has_many :tokens
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
