----Expelled
IF OBJECT_ID('dbo.ExpelledSelect') IS NOT NULL
BEGIN 
    DROP PROC dbo.ExpelledSelect 
END 
GO

CREATE PROC dbo.ExpelledSelect
    @number VARCHAR(15)
AS 
	SET XACT_ABORT, NOCOUNT ON;
		SELECT number, date_sig, signed  
		FROM   dbo.Expelled 
		WHERE  (number = @number OR @number IS NULL); 

GO

exec ExpelledSelect null;
------------------------------------------------------------

IF OBJECT_ID('dbo.ExpelledInsert') IS NOT NULL
BEGIN 
    DROP PROC dbo.ExpelledInsert 
END 
GO

CREATE PROC dbo.ExpelledInsert 
    @number VARCHAR(15),
    @date_sig DATE,
	@signed NVARCHAR(15)
AS
BEGIN TRY 
	SET XACT_ABORT, NOCOUNT ON;
	BEGIN TRAN;
		INSERT INTO  dbo.Expelled (number, date_sig, signed)
				VALUES( @number, @date_sig, @signed);
	COMMIT;
		SELECT number, date_sig, signed
		FROM   dbo.Expelled
		WHERE  number = @number;
END TRY
BEGIN CATCH
	ROLLBACK;
	SELECT ERROR_NUMBER() AS ErrorNumber,ERROR_MESSAGE() AS ErrorMessage;
END CATCH
GO

EXEC ExpelledInsert '2017/18 01-10', '2017-10-01', '״טלאם ִ.ֲ.';
------------------------------------------------------------------------------

IF OBJECT_ID('dbo.ExpelledUpdate') IS NOT NULL
BEGIN 
    DROP PROC dbo.ExpelledUpdate
END 
GO

CREATE PROC dbo.ExpelledUpdate 
	@number VARCHAR(15),
    @numbernew VARCHAR(15),
    @date_sig DATE,
	@signed NVARCHAR(15)
AS 
BEGIN TRY 
	SET XACT_ABORT, NOCOUNT ON;
	BEGIN TRAN;
		UPDATE dbo.Expelled 
		SET    number = @numbernew, date_sig = @date_sig,  signed = @signed
		WHERE  number = @number;
	COMMIT;
		SELECT number, date_sig, signed
		FROM   dbo.Expelled
		WHERE  number = @numbernew;  
END TRY
BEGIN CATCH
	ROLLBACK;
	SELECT ERROR_NUMBER() AS ErrorNumber,ERROR_MESSAGE() AS ErrorMessage;
END CATCH
GO

EXEC ExpelledUpdate '2017/18 10-01', '2017/18 01-10', '2017-10-01', '״טלאם ִ.ֲ.';
----------------------------------------------------------------------------------

IF OBJECT_ID('dbo.ExpelledDelete') IS NOT NULL
BEGIN 
    DROP PROC dbo.ExpelledDelete
END 
GO

CREATE PROC dbo.ExpelledDelete 
   @number VARCHAR(15)
AS 
BEGIN TRY
	SET XACT_ABORT, NOCOUNT ON;
	BEGIN TRAN;
		DELETE
		FROM  dbo.Expelled
		WHERE  number = @number;
	COMMIT;
END TRY
BEGIN CATCH
	ROLLBACK;
	SELECT ERROR_NUMBER() AS ErrorNumber,ERROR_MESSAGE() AS ErrorMessage;
END CATCH
GO

exec ExpelledDelete '2017/18 01-10';