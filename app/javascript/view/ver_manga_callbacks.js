function favoritar(evento){
	console.log('favoritando...')
	console.log(evento.target)
	var form = Array.from(evento.target.getElementsByTagName('form'))[0]
	form.submit()
}
function desfavoritar(evento){
	console.log('desfavoritando...')
	console.log(evento.target)
	var form = Array.from(evento.target.getElementsByTagName('form'))[0]
	form.submit()
}

export{
	favoritar,
	desfavoritar
}