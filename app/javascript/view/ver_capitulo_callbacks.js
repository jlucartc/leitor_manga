function ver_capitulo(evento){
	var form = Array.from(evento.target.getElementsByTagName('form'))[0]
	form.submit()
}

function ler_manga(evento){
	var link = evento.target.children[0];
	link.click()
}

export{
	ver_capitulo,
	ler_manga
}