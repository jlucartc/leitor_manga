function exists(elemento){
	return (elemento != null && elemento != undefined)
}

function apresentar_lista(evento){
	var container = document.getElementById('itens-container-grade')
	var itens = Array.from(document.getElementsByClassName('manga-item-grade'))

	if(exists(container) && exists(itens)){
		container.id = "itens-container-lista"
		itens.forEach((item)=>{
			item.className = 'manga-item-lista'
		})
	}
}

function apresentar_grade(evento){
	var container = document.getElementById('itens-container-lista')
	var itens = Array.from(document.getElementsByClassName('manga-item-lista'))

	if(exists(container) && exists(itens)){
		container.id = "itens-container-grade"	
		itens.forEach((item)=>{
			item.className = 'manga-item-grade'
		})
	}
}

function ver_manga(evento){
	var botao = Array.from(evento.target.parentElement.parentElement.getElementsByClassName('manga-ver'))[0]
	botao.click()
}


export {
	exists,
	apresentar_lista,
	apresentar_grade,
	ver_manga
}