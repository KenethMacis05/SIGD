CREATE FUNCTION [dbo].[FiltrarDominio](
    @UsuarioId INT,
    @TipoDominio VARCHAR(50)
)
RETURNS @Ids TABLE(ReferenciaId INT)
AS
BEGIN
    DECLARE @RolId INT = (SELECT fk_rol FROM USUARIOS WHERE id_usuario = @UsuarioId);
    
    -- Obtener dominios del usuario + dominios de su rol
    INSERT INTO @Ids
    SELECT DISTINCT D.referencia_id
    FROM DOMINIO D
    INNER JOIN TIPO_DOMINIO TD ON D.fk_tipo_dominio = TD.id_tipo_dominio
    WHERE TD.descripcion_tipo_dominio = @TipoDominio
    AND D.estado = 1
    AND TD.estado = 1
    AND (
        -- Dominios asignados a su rol
        EXISTS (SELECT 1 FROM DOMINIO_ROL DR 
                WHERE DR.fk_rol = @RolId AND DR.fk_dominio = D.id_dominio AND DR.estado = 1)
    )
    RETURN
END
GO