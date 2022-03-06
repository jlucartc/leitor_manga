function exists(elemento){
	return (elemento != null && elemento != undefined)
}

function aumenta_leitor(evento){
	var leitor = document.getElementById('leitor-manga')
	if(leitor.offsetWidth < 1447){
		leitor.style.width = (leitor.offsetWidth + 100)+'px'
	}
}

function proxima_pagina(evento){
	var link = Array.from(evento.target.getElementsByTagName('a'))[0]
	link.click()
}

function pagina_anterior(evento){
	var link = Array.from(evento.target.getElementsByTagName('a'))[0]
	link.click()
}

function diminui_leitor(evento){
	var leitor = document.getElementById('leitor-manga')
	leitor.style.width = (leitor.offsetWidth - 100)+'px'
}

function ativa_modal_exclusao(evento){
	console.log('ativa_modal_exclusao')
	var indice = evento.target.id.split('-')[2]

	if(parseInt(indice) != parseInt(indice)){
		var modal = Array.from(document.getElementsByClassName('modal-exclusao-escondido'))[0]
		modal.className = 'modal-exclusao'
	}else{
		var modal = document.getElementById('modal-exclusao-'+indice)
		modal.className = 'modal-exclusao'
	}

}

function cancela_exclusao(evento){
	var modal = evento.target.parentElement.parentElement.parentElement
	modal.className = 'modal-exclusao-escondido'
}

function confirma_exclusao(evento){
	var indice = evento.target.parentElement.parentElement.parentElement.id.split('-').pop()

	if(parseInt(indice) != parseInt(indice)){
		var form = document.getElementById('excluir')
		form.submit()
	}else{
		var form = document.getElementById('excluir-manga-'+indice)
		form.submit()
	}

}

function refaz_contagem(){
	var paginas_existentes = Array.from(document.getElementsByClassName('pagina-capitulo'))
	var paginas_novas = Array.from(document.getElementsByClassName('pagina-nova'))
	var paginas = paginas_existentes.concat(paginas_novas)

	paginas.forEach((pagina,indice)=>{
		var pagina_existente_cover = Array.from(pagina.getElementsByClassName('pagina-capitulo-cover'))[0]
		var pagina_nova_cover = Array.from(pagina.getElementsByClassName('pagina-nova-cover'))[0]
		var pagina_input = Array.from(pagina.getElementsByTagName('input'))[0]
		var pagina_input_data = JSON.parse(pagina_input.value)

		if(exists(pagina_existente_cover)){
			pagina_existente_cover.innerText = indice + 1
		}else if(exists(pagina_nova_cover)){
			pagina_nova_cover.innerText = indice + 1
		}

		pagina_input_data.sequencia = indice + 1
		pagina_input.value = JSON.stringify(pagina_input_data)
	})
}

function remover_pagina(evento){
	var pagina = evento.target.parentElement
	pagina.parentElement.removeChild(pagina)
	refaz_contagem()
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
	ver_manga,
	remover_pagina,
	refaz_contagem,
	ativa_modal_exclusao,
	cancela_exclusao,
	confirma_exclusao,
	aumenta_leitor,
	diminui_leitor,
	proxima_pagina,
	pagina_anterior
}