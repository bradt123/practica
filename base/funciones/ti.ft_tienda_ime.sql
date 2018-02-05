/**************************************************************************
 SISTEMA:		Tienda
 FUNCION: 		ti.ft_tienda_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'ti.ttienda'
 AUTOR: 		 (admin)
 FECHA:	        29-12-2017 14:58:10
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				29-12-2017 14:58:10								Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'ti.ttienda'	
 #
 ***************************************************************************/

DECLARE

	v_nro_requerimiento    	integer;
	v_parametros           	record;
	v_id_requerimiento     	integer;
	v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
	v_id_tienda				integer;
    
    v_nro_tramite 			varchar;
    v_id_proceso_wf			integer;
    v_id_estado_wf			integer;
    v_codigo_estado			varchar;
    v_id_gestion 			integer;
			    
BEGIN

    v_nombre_funcion = 'ti.ft_tienda_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'TI_TIE_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		29-12-2017 14:58:10
	***********************************/

	if(p_transaccion='TI_TIE_INS')then
					
        begin
        	 select g.id_gestion
             into v_id_gestion
             from param.tgestion g
             where g.gestion = EXTRACT(YEAR FROM current_date);
        --raise exception 'llega: %',v_id_gestion; PARA LANZAR MENSJE
        
        	SELECT 
            	ps_num_tramite,
                ps_id_proceso_wf,
                ps_id_estado_wf,
                ps_codigo_estado
         	into 
            	v_nro_tramite,
                v_id_proceso_wf,
                v_id_estado_wf,
                v_codigo_estado
         	FROM wf.f_inicia_tramite(
                 p_id_usuario,
                 v_parametros._id_usuario_ai,
                 v_parametros._nombre_usuario_ai,
                 v_id_gestion, 
                 'SISV',
                 1,
	        	null, 
    	        'Gestión Equipajes',
        	    'BOA-SIS_V'
                );
                
        	--Sentencia de la insercion
        	insert into ti.ttienda(
			estado_reg,
			nombre,
			fecha_reg,
			usuario_ai,
			id_usuario_reg,
			id_usuario_ai,
			id_usuario_mod,
			fecha_mod,
            
            nro_tramite,
            id_proceso_wf,
            id_estado_wf,
            estado
            
          	) values(
			'activo',
			v_parametros.nombre,
			now(),
			v_parametros._nombre_usuario_ai,
			p_id_usuario,
			v_parametros._id_usuario_ai,
			null,
			null,
            
            v_nro_tramite,
            v_id_proceso_wf,
            v_id_estado_wf,
            v_codigo_estado
							
			
			
			)RETURNING id_tienda into v_id_tienda;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Tienda almacenado(a) con exito (id_tienda'||v_id_tienda||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_tienda',v_id_tienda::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'TI_TIE_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		29-12-2017 14:58:10
	***********************************/

	elsif(p_transaccion='TI_TIE_MOD')then

		begin
			--Sentencia de la modificacion
			update ti.ttienda set
			nombre = v_parametros.nombre,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now(),
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_tienda=v_parametros.id_tienda;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Tienda modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_tienda',v_parametros.id_tienda::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'TI_TIE_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		29-12-2017 14:58:10
	***********************************/

	elsif(p_transaccion='TI_TIE_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from ti.ttienda
            where id_tienda=v_parametros.id_tienda;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Tienda eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_tienda',v_parametros.id_tienda::varchar);
              
            --Devuelve la respuesta
            return v_resp;

		end;
         
	else
     
    	raise exception 'Transaccion inexistente: %',p_transaccion;

	end if;

EXCEPTION
				
	WHEN OTHERS THEN
		v_resp='';
		v_resp = pxp.f_agrega_clave(v_resp,'mensaje',SQLERRM);
		v_resp = pxp.f_agrega_clave(v_resp,'codigo_error',SQLSTATE);
		v_resp = pxp.f_agrega_clave(v_resp,'procedimientos',v_nombre_funcion);
		raise exception '%',v_resp;
				        
END;