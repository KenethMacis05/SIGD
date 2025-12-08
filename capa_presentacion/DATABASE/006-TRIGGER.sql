CREATE OR ALTER TRIGGER trg_ActualizarEstadoPlanDidactico
ON PLANIFICACIONINDIVIDUALSEMESTRAL
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @IdPlanDidactico INT;
    
    -- Obtener el ID del plan didáctico afectado
    SELECT @IdPlanDidactico = fk_plan_didactico 
    FROM (
        SELECT fk_plan_didactico FROM inserted
        UNION
        SELECT fk_plan_didactico FROM deleted
    ) AS ChangedPlans;
    
    -- Actualizar el estado del plan didáctico
    IF @IdPlanDidactico IS NOT NULL
    BEGIN
        EXEC usp_ActualizarEstadoPlanDidactico @IdPlanDidactico;
    END
END;
GO