function favoritar(evento){
	var form = Array.from(evento.target.getElementsByTagName('form'))[0]
	form.submit()
}
function desfavoritar(evento){
	var form = Array.from(evento.target.getElementsByTagName('form'))[0]
	form.submit()
}

export{
	favoritar,
	desfavoritar
}