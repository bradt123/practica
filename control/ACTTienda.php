<?php
/**
*@package pXP
*@file gen-ACTTienda.php
*@author  (admin)
*@date 29-12-2017 14:58:10
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTTienda extends ACTbase{    
			
	function listarTienda(){
		$this->objParam->defecto('ordenacion','id_tienda');

		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODTienda','listarTienda');
		} else{
			$this->objFunc=$this->create('MODTienda');
			
			$this->res=$this->objFunc->listarTienda($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarTienda(){
		$this->objFunc=$this->create('MODTienda');	
		if($this->objParam->insertar('id_tienda')){
			$this->res=$this->objFunc->insertarTienda($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarTienda($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarTienda(){
		$this->objFunc=$this->create('MODTienda');	
		$this->res=$this->objFunc->eliminarTienda($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	function siguienteEstadoTienda(){
		$this->objFunc=$this->create('MODTienda');	
		$this->res=$this->objFunc->siguienteEstadoTienda($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>