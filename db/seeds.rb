# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

Usuario.create(email: 'user1@gmail.com', password: '123456', password_confirmation: '123456')
Usuario.create(email: 'user2@gmail.com', password: '123456', password_confirmation: '123456')

Manga.create(usuario_id: 1, titulo: 'Naruto Classic', descricao: 'Shounen', finalizado: true)
Manga.create(usuario_id: 1, titulo: 'Naruto Shippuden', descricao: 'Shounen', finalizado: true)
Manga.create(usuario_id: 1, titulo: 'Nanatsu no Taizai', descricao: 'Shounen', finalizado: true)
Manga.create(usuario_id: 1, titulo: 'Monster', descricao: 'Seinen', finalizado: true)
Manga.create(usuario_id: 1, titulo: 'Boku no Hero Academia', descricao: 'Shounen', finalizado: true)
Manga.create(usuario_id: 1, titulo: 'Berserk', descricao: 'Seinen', finalizado: true)
Manga.create(usuario_id: 1, titulo: 'Gantz', descricao: 'Seinen', finalizado: true)
Manga.create(usuario_id: 1, titulo: 'Bleach', descricao: 'Shounen', finalizado: true)
Manga.create(usuario_id: 1, titulo: 'One Piece', descricao: 'Shounen', finalizado: true)
Manga.create(usuario_id: 1, titulo: 'The Breaker', descricao: 'Seinen', finalizado: true)

