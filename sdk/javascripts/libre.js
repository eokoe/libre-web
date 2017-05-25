// stricted always
'use strict';


// requires
const Config = require('config.js');
const ButtonView = require('views/button.js');


/**
* Libre SDK class
*/
class SDK {

	// constructor
	constructor(args = {}) {
		this.name = args.n || 'none';
		this.version = args.v || 0;
	}

	// dom object
	dom() { return document }

	// configs
	config(){ return Config.env() }

	// sdk renderer
	render() {
		// button renderer
		this.dom().querySelectorAll('.lbr-button')
			.forEach( b => (new ButtonView({el: b, config: this.config()})).render() )
	}
}


const Libre = {
	start(args = {}){
		return (new SDK(args)).render()
	}
};

// single point entry
Libre.start({n:'libre-sdk', v:'1.0'})