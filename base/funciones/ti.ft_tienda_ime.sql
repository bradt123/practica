CREATE OR REPLACE FUNCTION "ti"."ft_tienda_ime" (	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$

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
	v_id_tienda	integer;
			    
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
        	--Sentencia de la insercion
        	insert into ti.ttienda(
			estado_reg,
			nombre,
			fecha_reg,
			usuario_ai,
			id_usuario_reg,
			id_usuario_ai,
			id_usuario_mod,
			fecha_mod
          	) values(
			'activo',
			v_parametros.nombre,
			now(),
			v_parametros._nombre_usuario_ai,
			p_id_usuario,
			v_parametros._id_usuario_ai,
			null,
			null
							
			
			
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
$BODY$
LANGUAGE 'plpgsql' VOLATILE
COST 100;
ALTER FUNCTION "ti"."ft_tienda_ime"(integer, integer, character varying, character varying) OWNER TO postgres;
