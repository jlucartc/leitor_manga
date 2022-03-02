import { createApp } from "vue";

var app = createApp({
	data(){
		return { 
			message: 'Olá Vue!'
		}
	},
	methods:{
		clickme(event){
			console.log(event.target.tagName)
		},
		print_ref(el){
			console.log(el)
		}
	}
}).mount('#root')