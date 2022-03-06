function mudar_capa(evento){
	var input = document.getElementById('input-capa')
	var capa = document.getElementById('capa-manga')
	capa.src = URL.createObjectURL(input.files[0])
}

function escolher_capa(evento){
	var input = document.getElementById('input-capa')
	input.click()
}

export{
	escolher_capa,
	mudar_capa
}