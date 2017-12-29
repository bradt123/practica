<?php
/**
*@package pXP
*@file gen-Tienda.php
*@author  (admin)
*@date 29-12-2017 14:58:10
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.Tienda=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.Tienda.superclass.constructor.call(this,config);
		this.init();
		this.load({params:{start:0, limit:this.tam_pag}})
	
	
	
     this.addButton('sig_estado', {
	    grupo: [0, 1, 2, 3, 4, 5],
	    text: 'Siguiente',
	    iconCls: 'badelante',
	    disabled: true,
	    handler: this.sigEstado,
	    tooltip: 'Pasar al Siguiente Estado'
	 });
 },
  sigEstado: function () {
    var rec = this.sm.getSelected();
    this.objWizard = Phx.CP.loadWindows('../../../sis_workflow/vista/estado_wf/FormEstadoWf.php', 'Estado de Wf', {
        modal: true,
        width: 700,
        height: 450
    }, {
        data: {
            id_estado_wf: rec.data.id_estado_wf,
            id_proceso_wf: rec.data.id_proceso_wf
        }
    }, this.idContenedor, 
    'FormEstadoWf', 
    {
    	config: [{
    		event: 'beforesave', 
    		delegate: this.onSaveWizard
    		}], 
    		scope: this
    		});
}
,
preparaMenu: function(n)
    {	var rec = this.getSelectedData();
        var tb =this.tbar;


        Phx.vista.ParteIrregular.superclass.preparaMenu.call(this,n);
        //this.getBoton('btnChequeoDocumentosWf').setDisabled(false);
        //this.getBoton('diagrama_gantt').enable();
        //this.getBoton('btnObs').enable();
        
        this.getBoton('sig_estado').enable();
        
        //this.getBoton('ant_estado').enable();
        //this.getBoton('transferencia').enable();


        return tb;
    },

    liberaMenu:function(){
        var tb = Phx.vista.ParteIrregular.superclass.liberaMenu.call(this);
        if(tb){
            //this.getBoton('ant_estado').disable();
            
            this.getBoton('sig_estado').disable();
            
            //this.getBoton('btnChequeoDocumentosWf').setDisabled(true);
            //this.getBoton('diagrama_gantt').disable();
            //this.getBoton('btnObs').disable();
            //this.getBoton('transferencia').disable();

        }
        return tb
    },	
    
    onSaveWizard:function(wizard,resp){
        var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
        Phx.CP.loadingShow();
        Ext.Ajax.request({
            url:'../../sis_tienda/control/Tienda/siguienteEstadoTienda',
            
            params:{
                id_proceso_wf_act:  resp.id_proceso_wf_act,
                id_estado_wf_act:   resp.id_estado_wf_act,
                id_tipo_estado:     resp.id_tipo_estado,
                id_funcionario_wf:  resp.id_funcionario_wf,
                id_depto_wf:        resp.id_depto_wf,
                obs:                resp.obs,
                json_procesos:      Ext.util.JSON.encode(resp.procesos)
            },
            success:this.successWizard,
            failure: this.conexionFailure,
            argument:{wizard:wizard},
            timeout:this.timeout,
            scope:this
        });
    },
    
    
    
	Atributos:[
	
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_tienda'
			},
			type:'Field',
			form:true 
		},
		{
			config:{
				name: 'estado_reg',
				fieldLabel: 'Estado Reg.',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:10
			},
				type:'TextField',
				filters:{pfiltro:'tie.estado_reg',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'nombre',
				fieldLabel: 'nombre',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:255
			},
				type:'TextField',
				filters:{pfiltro:'tie.nombre',type:'string'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'fecha_reg',
				fieldLabel: 'Fecha creación',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
							format: 'd/m/Y', 
							renderer:function (value,p,record){return value?value.dateFormat('d/m/Y H:i:s'):''}
			},
				type:'DateField',
				filters:{pfiltro:'tie.fecha_reg',type:'date'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'usuario_ai',
				fieldLabel: 'Funcionaro AI',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:300
			},
				type:'TextField',
				filters:{pfiltro:'tie.usuario_ai',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'usr_reg',
				fieldLabel: 'Creado por',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:4
			},
				type:'Field',
				filters:{pfiltro:'usu1.cuenta',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'id_usuario_ai',
				fieldLabel: 'Creado por',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:4
			},
				type:'Field',
				filters:{pfiltro:'tie.id_usuario_ai',type:'numeric'},
				id_grupo:1,
				grid:false,
				form:false
		},
		{
			config:{
				name: 'usr_mod',
				fieldLabel: 'Modificado por',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:4
			},
				type:'Field',
				filters:{pfiltro:'usu2.cuenta',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'fecha_mod',
				fieldLabel: 'Fecha Modif.',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
							format: 'd/m/Y', 
							renderer:function (value,p,record){return value?value.dateFormat('d/m/Y H:i:s'):''}
			},
				type:'DateField',
				filters:{pfiltro:'tie.fecha_mod',type:'date'},
				id_grupo:1,
				grid:true,
				form:false
		}
	],
	tam_pag:50,	
	title:'Tienda',
	ActSave:'../../sis_tienda/control/Tienda/insertarTienda',
	ActDel:'../../sis_tienda/control/Tienda/eliminarTienda',
	ActList:'../../sis_tienda/control/Tienda/listarTienda',
	id_store:'id_tienda',
	fields: [
		{name:'id_tienda', type: 'numeric'},
		{name:'estado_reg', type: 'string'},
		{name:'nombre', type: 'string'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usuario_ai', type: 'string'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
		
	],
	sortInfo:{
		field: 'id_tienda',
		direction: 'ASC'
	},
	bdel:true,
	bsave:true
	}
)
</script>
		
		