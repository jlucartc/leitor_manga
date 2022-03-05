function ver_capitulo(evento){
	var form = Array.from(evento.target.getElementsByTagName('form'))[0]
	form.submit()
}

export{
	ver_capitulo
}