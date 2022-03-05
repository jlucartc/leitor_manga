var pagina_arrastada = null
var pagina_destino = null

function inicia_drag(evento){
	pagina_arrastada = evento.target
}

function passa_por_pagina(evento){
	if(evento.target.className == 'pagina-cover'){
		pagina_destino = evento.target.parentElement
	}
}

function troca_paginas(evento){
	if(pagina_destino != null){
		var fonte_data = JSON.parse(Array.from(pagina_arrastada.getElementsByTagName('input'))[0].value)
		var fonte_capa = Array.from(pagina_arrastada.getElementsByClassName('pagina-cover'))[0]
		var destino_data = JSON.parse(Array.from(pagina_destino.getElementsByTagName('input'))[0].value)
		var destino_capa = Array.from(pagina_destino.getElementsByClassName('pagina-cover'))[0]
		var fonte_input = Array.from(pagina_arrastada.getElementsByTagName('input'))[0]
		var destino_input = Array.from(pagina_destino.getElementsByTagName('input'))[0]

		var auxiliar = null
		auxiliar = fonte_data.sequencia
		fonte_data.sequencia = destino_data.sequencia
		destino_data.sequencia = auxiliar

		fonte_capa.innerText = fonte_data.sequencia
		destino_capa.innerText = destino_data.sequencia

		fonte_input.value = JSON.stringify(fonte_data)
		destino_input.value = JSON.stringify(destino_data)

		var pagina = pagina_destino.parentElement
		auxiliar = pagina.removeChild(pagina_arrastada)
		pagina.insertBefore(auxiliar,pagina.children[fonte_data.sequencia-1])
		auxiliar = pagina.parentElement.removeChild(pagina_destino)
		pagina.insertBefore(auxiliar,pagina.parentElement.children[destino_data.sequencia-1])

	}

}

function remove_paginas(){
	var paginas = Array.from(document.getElementsByClassName('pagina'))
	paginas.forEach((pagina)=>{
		pagina.parentElement.removeChild(pagina)
	})
}

function cria_pagina(imagem,indice){
	var pagina = document.createElement('div')
	var pagina_imagem = document.createElement('img')
	var pagina_cover = document.createElement('div')
	var input_nome_sequencia = document.createElement('input')

	pagina.className = "pagina"
	pagina.draggable = true
	pagina_imagem.className = "pagina-imagem"
	pagina_cover.className = "pagina-cover"
	pagina_cover.innerText = indice+1
	//pagina_cover.draggable = true
	pagina_imagem.src = URL.createObjectURL(imagem)

	input_nome_sequencia.name = "sequencia_imagens[]"
	input_nome_sequencia.value = JSON.stringify({nome: imagem.name, sequencia: indice+1})
	input_nome_sequencia.setAttribute('form','salvar-capitulo')
	input_nome_sequencia.style.display = 'none'

	pagina.appendChild(pagina_imagem)
	pagina.appendChild(pagina_cover)
	pagina.appendChild(input_nome_sequencia)


	return pagina

}

function insere_paginas(evento){

	remove_paginas()

	var paginas = Array.from(evento.target.files)
	var paginas_container = document.getElementById('paginas-container')
	console.log(paginas.files)

	paginas.forEach((pagina,indice) => {
		var pagina_tag = cria_pagina(pagina,indice)
		paginas_container.appendChild(pagina_tag)
	})

	document.dispatchEvent(new Event('insere-paginas'))

}

function abre_seletor_paginas(evento){
	console.log('Abre seletor paginas...')
	var input = document.getElementById('seletor-imagens')
	input.click()
}

export{
	abre_seletor_paginas,
	insere_paginas,
	troca_paginas,
	inicia_drag,
	passa_por_pagina
}