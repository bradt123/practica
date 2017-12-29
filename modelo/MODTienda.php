<?php
/**
*@package pXP
*@file gen-MODTienda.php
*@author  (admin)
*@date 29-12-2017 14:58:10
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODTienda extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarTienda(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='ti.ft_tienda_sel';
		$this->transaccion='TI_TIE_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_tienda','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('nombre','varchar');
		$this->captura('fecha_reg','timestamp');
		$this->captura('usuario_ai','varchar');
		$this->captura('id_usuario_reg','int4');
		$this->captura('id_usuario_ai','int4');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarTienda(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='ti.ft_tienda_ime';
		$this->transaccion='TI_TIE_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('nombre','nombre','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarTienda(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='ti.ft_tienda_ime';
		$this->transaccion='TI_TIE_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_tienda','id_tienda','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('nombre','nombre','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarTienda(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='ti.ft_tienda_ime';
		$this->transaccion='TI_TIE_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_tienda','id_tienda','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
	
	function siguienteEstadoTienda(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='ti.ft_tienda_ime';
		$this->transaccion='TI_SIGESTADO_IME'; //cambiar 'SAL_SIGESTADO_IME
		$this->tipo_procedimiento='IME';
		
	 $this->setParametro('id_proceso_wf_act','id_proceso_wf_act','int4');
	 $this->setParametro('id_estado_wf_act','id_estado_wf_act','int4');
	 $this->setParametro('id_tipo_estado','id_tipo_estado','int4');
	 $this->setParametro('id_funcionario_wf','id_funcionario_wf','int4');
	 $this->setParametro('id_depto_wf','id_depto_wf','int4');
	 $this->setParametro('obs','obs','text');
	 $this->setParametro('json_procesos','json_procesos','text');
	 
		//Define los parametros para la funcion
		$this->setParametro('id_tienda','id_tienda','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>