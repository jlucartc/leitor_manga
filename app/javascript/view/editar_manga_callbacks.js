function mudar_capa(evento){
	var input = document.getElementById('input-capa')
	var capa = document.getElementById('capa-manga')
	console.log(capa)
	console.log(input.files)
	capa.src = URL.createObjectURL(input.files[0])
}

function escolher_capa(evento){
	console.log('escolher capa...')
	var input = document.getElementById('input-capa')
	input.click()
}

export{
	escolher_capa,
	mudar_capa
}