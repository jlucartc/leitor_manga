class Usuario < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :favoritos
  has_many :tokens
  validates :password_confirmation, presence: true
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
