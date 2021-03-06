/**************************************************************************
 SISTEMA:		Tienda
 FUNCION: 		ti.ft_tienda_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'ti.ttienda'
 AUTOR: 		 (admin)
 FECHA:	        29-12-2017 14:58:10
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				29-12-2017 14:58:10								Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'ti.ttienda'	
 #
 ***************************************************************************/

DECLARE

	v_consulta    		varchar;
	v_parametros  		record;
	v_nombre_funcion   	text;
	v_resp				varchar;
			    
BEGIN

	v_nombre_funcion = 'ti.ft_tienda_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'TI_TIE_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		admin	
 	#FECHA:		29-12-2017 14:58:10
	***********************************/

	if(p_transaccion='TI_TIE_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						tie.id_tienda,
						tie.estado_reg,
						tie.nombre,
						tie.fecha_reg,
						tie.usuario_ai,
						tie.id_usuario_reg,
						tie.id_usuario_ai,
						tie.id_usuario_mod,
						tie.fecha_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod	
						from ti.ttienda tie
						inner join segu.tusuario usu1 on usu1.id_usuario = tie.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = tie.id_usuario_mod
				        where  ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'TI_TIE_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin	
 	#FECHA:		29-12-2017 14:58:10
	***********************************/

	elsif(p_transaccion='TI_TIE_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_tienda)
					    from ti.ttienda tie
					    inner join segu.tusuario usu1 on usu1.id_usuario = tie.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = tie.id_usuario_mod
					    where ';
			
			--Definicion de la respuesta		    
			v_consulta:=v_consulta||v_parametros.filtro;

			--Devuelve la respuesta
			return v_consulta;

		end;
					
	else
					     
		raise exception 'Transaccion inexistente';
					         
	end if;
					
EXCEPTION
					
	WHEN OTHERS THEN
			v_resp='';
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje',SQLERRM);
			v_resp = pxp.f_agrega_clave(v_resp,'codigo_error',SQLSTATE);
			v_resp = pxp.f_agrega_clave(v_resp,'procedimientos',v_nombre_funcion);
			raise exception '%',v_resp;
END;