import * as helpers from './helpers'

var pagina_arrastada = null
var pagina_destino = null

function inicia_drag(evento){
	pagina_arrastada = evento.target
}

function passa_por_pagina(evento){
	if(evento.target.className == 'pagina-nova-cover' || evento.target.className == 'pagina-capitulo-cover'){
		pagina_destino = evento.target.parentElement
	}
}

function troca_paginas(evento){
	if(pagina_destino != null){
		var fonte_capa = Array.from(pagina_arrastada.getElementsByClassName(pagina_arrastada.className+'-cover'))[0]
		var destino_capa = Array.from(pagina_destino.getElementsByClassName(pagina_destino.className+'-cover'))[0]
		var fonte_data = JSON.parse(Array.from(pagina_arrastada.getElementsByTagName('input'))[0].value)
		var destino_data = JSON.parse(Array.from(pagina_destino.getElementsByTagName('input'))[0].value)
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

		var paginas_container = pagina_destino.parentElement
		auxiliar = paginas_container.removeChild(pagina_arrastada)
		paginas_container.insertBefore(auxiliar,paginas_container.children[fonte_data.sequencia-1])
		auxiliar = paginas_container.removeChild(pagina_destino)
		paginas_container.insertBefore(auxiliar,paginas_container.children[destino_data.sequencia-1])

	}

}

function remove_paginas(){
	var paginas = Array.from(document.getElementsByClassName('pagina-nova'))
	paginas.forEach((pagina)=>{
		pagina.parentElement.removeChild(pagina)
	})
}

function cria_pagina(imagem,indice){
	var pagina = document.createElement('div')
	var pagina_imagem = document.createElement('img')
	var pagina_cover = document.createElement('div')
	var input_nome_sequencia = document.createElement('input')
	var pagina_remover = document.createElement('div')

	pagina.className = "pagina-nova"
	pagina.draggable = true
	pagina_imagem.className = "pagina-nova-imagem"
	pagina_cover.className = "pagina-nova-cover"
	pagina_remover.className = "pagina-remover"
	pagina_remover.innerText = 'X'
	pagina_cover.innerText = indice+1
	pagina_imagem.src = URL.createObjectURL(imagem)

	input_nome_sequencia.name = "sequencia_imagens[]"
	input_nome_sequencia.value = JSON.stringify({nome: imagem.name, sequencia: indice+1})
	input_nome_sequencia.setAttribute('form','salvar-capitulo')
	input_nome_sequencia.style.display = 'none'

	pagina.appendChild(pagina_imagem)
	pagina.appendChild(pagina_cover)
	pagina.appendChild(pagina_remover)
	pagina.appendChild(input_nome_sequencia)

	return pagina
}

function ultimo_indice_paginas(){
	var ultima_pagina = Array.from(document.getElementsByClassName('pagina-capitulo')).pop()

	if(ultima_pagina != null && ultima_pagina != undefined){
		var ultimo_indice = Array.from(ultima_pagina.getElementsByClassName('pagina-capitulo-cover'))[0].innerText
		return parseInt(ultimo_indice)
	}else{
		return 0
	}
}

function insere_paginas(evento){

	remove_paginas()
	helpers.refaz_contagem()

	var ultimo_indice = ultimo_indice_paginas()
	var paginas = Array.from(evento.target.files)
	var paginas_container = document.getElementById('paginas-container')

	paginas.forEach((pagina,indice) => {
		var pagina_tag = cria_pagina(pagina,(ultimo_indice+indice))
		paginas_container.appendChild(pagina_tag)
	})

	document.dispatchEvent(new Event('insere-paginas'))

}

function abre_seletor_paginas(evento){
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