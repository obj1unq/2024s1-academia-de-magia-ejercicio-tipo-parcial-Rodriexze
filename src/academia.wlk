//MARCAS

object acme {
	method utilidad(cosa) {
		return cosa.volumen() / 2
	}
}

object cuchuflito {
	method utilidad(cosa) {
		return 0
	}
}

object fenix {
	method utilidad(cosa) {
		return if (cosa.esReliquia()) {3} else {0}
	}
}

class Academia {
	var property muebles = #{}
	
	method tiene(cosa) {
		return muebles.any({mueble=> mueble.tiene(cosa)})
	}
	
	method dondeGuarda(cosa) {
		//self.validarDondeGuarda() aclarar para que pongo el validar ayuda a correccion
		return muebles.find({mueble=> mueble.tiene(cosa)})
	}
	
	method puedeGuardar(cosa) {
		return not self.tiene(cosa) and self.existeMuebleParaGuardar(cosa)
	}
	
	method existeMuebleParaGuardar(cosa) {
		return muebles.any({mueble=> mueble.puedeGuardar(cosa)})
	}
	
	method dondeGuardar(cosa) {
		return muebles.filter({mueble=> mueble.puedeGuardar(cosa)})
	}
	
	method validarPuedeGuardar(cosa) {
		if (not self.puedeGuardar(cosa)) {self.error("No se puede guardar" + cosa)}
	}
	
	method elegirMueble(cosa) {
		return self.dondeGuardar(cosa).anyOne() // aca era any()
	}
	
	method guardar(cosa) {
		self.validarPuedeGuardar(cosa)
		self.elegirMueble(cosa).guardar(cosa)
	}
	
	method menosUtiles() {
		return muebles.map({mueble=> mueble.menosUtil()}).asSet()
	}
	
	method elMenosUtil() {
		return self.menosUtiles().min({mueble=> mueble.utilidad()})
	}
	
	method marcaCosaMenosUtil() {
		return self.elMenosUtil().marca() 
	}
	
	method validarRemoverUtilesNoMagicas() {
		if (self.muebles().size() < 3) {self.error("No hay muebles suficientes")}
	}
	
	method
}

class Cosa {
	
	var property marca // 
	var property volumen // numero
	var property esReliquia
	var property esMagico
	
	method utilidad() {
		return self.volumen() + self.utilidadSiMagica() + self.utilidadSiReliquia() + self.utilidadPorMarca()
	}
	
	method utilidadSiMagica() {
		return if (esMagico) 3 else 0
	}
	
	method utilidadSiReliquia() {
		return if (esReliquia) 5 else 0
	}
	
	method utilidadPorMarca() {
		return marca.utilidad(self)
	}
}

class Mueble {
	
	var property cosas = #{}
	
	method tiene(cosa) {
		return cosas.contains(cosa)
	}
	
	method puedeGuardar(cosa) {
		return not self.tiene(cosa)
	}
	
	method guardar(cosa) {
		self.validarGuardar(cosa)
		cosas.add(cosa)
	}
	
	method validarGuardar(cosa) {
		if (not self.puedeGuardar(cosa)) {self.error("No se puede guardar" + cosa)}
	}
	
	method utilidad() {
		return self.utilidadDeLasCosas() / self.precio()
	}
	
	method utilidadDeLasCosas() {
		return cosas.sum({cosa=> cosa.utilidad()})
	}
	
	method precio()
	
	method menosUtil() {
		return cosas.min({cosa=> cosa.utilidad()}) //comletar
	}
}

class Baul inherits Mueble {
	
	var property volumenMax
	
	override method puedeGuardar(cosa) {
		return super(cosa) and self.hayEspacio(cosa)
	}
	
	method hayEspacio(cosa) {
		return volumenMax >= self.volumenActual() + cosa.volumen()
	}
	
	method volumenActual() {
		return cosas.sum({cosa=> cosa.volumen()})
	}
	
	override method precio() {
		return volumenMax + 2
	}
	
	override method utilidad() {
		return super() + self.extraSiReliquias()
	}
	
	method extraSiReliquias() {
		return if (self.todasReliquias()) {2} else {0}
	}
	
	method todasReliquias() {
		return cosas.all({cosa=> cosa.esReliquia()})
	}
}

class BaulMagico inherits Baul {
	
	override method utilidad() {
		return super() + self.extraMagicos()
	}
	
	method extraMagicos() {
		// filter + size = count
		//flatMap = map + flatten
		//find = filter + anyOne()
		//max(bloque por condiicon).cond() = map + max
		return cosas.count({cosa=> cosa.esMagico()})
	}
	
	override method precio() {
		return super() * 2
	}
}

class GabineteMagico inherits Mueble {
	
	const precio
	
	override method puedeGuardar(cosa) {
		return super(cosa) and cosa.esMagico()
	}
	
	override method precio() {
		return precio
	}
}

class Armario inherits Mueble {
	
	var property cosasMax
	
	override method puedeGuardar(cosa) {
		return super(cosa) and self.hayLugar()
	}
	
	method hayLugar() {
		return cosasMax > cosas.size()
	}
	
	override method precio() {
		return 5 * cosasMax
	}
}