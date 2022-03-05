import * as novo_capitulo_callbacks from './novo_capitulo_callbacks';
import * as ver_capitulo_callbacks from './ver_capitulo_callbacks';
import * as ver_manga_callbacks from './ver_manga_callbacks';
import * as helpers from './helpers';

function remove_event_listener(item){
	if(item.hasOwnProperty('classe')){
		var elementos = Array.from(document.getElementsByClassName(item.classe))
		elementos.forEach((elemento)=>{
			elemento.removeEventListener(item.evento,function(evento){
				item.callbacks.forEach((callback)=>{callback(evento)})
			})
		})
	}else if(item.hasOwnProperty('id')){
		var elemento = document.getElementById(item.id)
		if(helpers.exists(elemento)){
			elemento.removeEventListener(item.evento,function(evento){
				item.callbacks.forEach((callback)=>{callback(evento)})
			})
		}
	}
}

function adiciona_event_listener(item){
	if(item.hasOwnProperty('classe')){
		var elementos = Array.from(document.getElementsByClassName(item.classe))
		elementos.forEach((elemento)=>{
			elemento.addEventListener(item.evento,function(evento){
				item.callbacks.forEach((callback)=>{callback(evento)})
			})
		})
	}else if(item.hasOwnProperty('id')){
		var elemento = document.getElementById(item.id)
		if(helpers.exists(elemento)){
			elemento.addEventListener(item.evento,function(evento){
				item.callbacks.forEach((callback)=>{callback(evento)})
			})
		}	
	}
}

var mapa_classe_eventos_turbo_load = [
	{classe:'capitulo',evento:'click',callbacks:[ver_capitulo_callbacks.ver_capitulo]},
	{classe:'excluir-produto-cancelar',evento:'click',callbacks:[]}
]

var mapa_id_eventos_turbo_load = [
	{id:'manga-nao-favorito',evento:'click',callbacks:[ver_manga_callbacks.favoritar]},
	{id:'manga-favorito',evento:'click',callbacks:[ver_manga_callbacks.desfavoritar]},
	{id:'escolher-paginas',evento:'click',callbacks:[novo_capitulo_callbacks.abre_seletor_paginas]},
	{id:'seletor-imagens',evento:'change',callbacks:[novo_capitulo_callbacks.insere_paginas]}
]

var lista_executar_turbo_load = [
]

document.addEventListener('turbo:load',function(){

	mapa_classe_eventos_turbo_load.forEach((item)=>{
		remove_event_listener(item)
		adiciona_event_listener(item)
	})

	mapa_id_eventos_turbo_load.forEach((item)=>{
		remove_event_listener(item)
		adiciona_event_listener(item)
	})

	lista_executar_turbo_load.forEach((method) => {
		method()
	})

})

document.addEventListener('insere-paginas',function(){

	document.removeEventListener('dragstart',novo_capitulo_callbacks.inicia_drag)
	document.removeEventListener('dragend',novo_capitulo_callbacks.troca_drag)
	document.removeEventListener('dragenter',novo_capitulo_callbacks.passa_por_drag)

	document.addEventListener('dragstart',novo_capitulo_callbacks.inicia_drag)
	document.addEventListener('dragend',novo_capitulo_callbacks.troca_paginas)
	document.addEventListener('dragenter',novo_capitulo_callbacks.passa_por_pagina)

})