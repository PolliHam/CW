----Enrollment
IF OBJECT_ID('dbo.EnrollmentSelect') IS NOT NULL
BEGIN 
    DROP PROC dbo.EnrollmentSelect 
END 
GO

CREATE PROC dbo.EnrollmentSelect
    @number VARCHAR(15)
AS 
	SET XACT_ABORT, NOCOUNT ON;
		SELECT number, date_sig, signed  
		FROM   dbo.Enrollment 
		WHERE  (number = @number OR @number IS NULL);
GO

exec EnrollmentSelect null;
------------------------------------------------------------

IF OBJECT_ID('dbo.EnrollmentInsert') IS NOT NULL
BEGIN 
    DROP PROC dbo.EnrollmentInsert 
END 
GO

CREATE PROC dbo.EnrollmentInsert 
    @number VARCHAR(15),
    @date_sig DATE,
	@signed NVARCHAR(15)
AS 
BEGIN TRY
	SET XACT_ABORT, NOCOUNT ON;
	BEGIN TRAN;
		INSERT INTO  dbo.Enrollment (number, date_sig, signed)
				VALUES( @number, @date_sig, @signed);
	COMMIT;
		SELECT number, date_sig, signed
		FROM   dbo.Enrollment
		WHERE  number = @number;
END TRY
BEGIN CATCH
	ROLLBACK;
	SELECT ERROR_NUMBER() AS ErrorNumber,ERROR_MESSAGE() AS ErrorMessage;
END CATCH
GO

EXEC EnrollmentInsert '2017/18 01-10', '2017-10-01', '״טלאם ִ.ֲ.';
------------------------------------------------------------------------------

IF OBJECT_ID('dbo.EnrollmentUpdate') IS NOT NULL
BEGIN 
    DROP PROC dbo.EnrollmentUpdate
END 
GO

CREATE PROC dbo.EnrollmentUpdate 
	@number VARCHAR(15),
    @numbernew VARCHAR(15),
    @date_sig DATE,
	@signed NVARCHAR(15)
AS 
BEGIN TRY
	SET XACT_ABORT, NOCOUNT ON;
	BEGIN TRAN;
		UPDATE dbo.Enrollment 
		SET    number = @numbernew, date_sig = @date_sig,  signed = @signed
		WHERE  number = @number;
	COMMIT;
		SELECT number, date_sig, signed
		FROM   dbo.Enrollment 
		WHERE  number = @numbernew;
END TRY
BEGIN CATCH
	ROLLBACK;
	SELECT ERROR_NUMBER() AS ErrorNumber,ERROR_MESSAGE() AS ErrorMessage;
END CATCH
GO

EXEC EnrollmentUpdate '2017/18 10-01', '2017/18 01-10', '2017-10-01', '״טלאם ִ.ֲ.';
----------------------------------------------------------------------------------

IF OBJECT_ID('dbo.EnrollmentDelete') IS NOT NULL
BEGIN 
    DROP PROC dbo.EnrollmentDelete
END 
GO

CREATE PROC dbo.EnrollmentDelete 
   @number VARCHAR(15)
AS 
BEGIN TRY
	SET XACT_ABORT, NOCOUNT ON;
	BEGIN TRAN;
		DELETE
		FROM  dbo.Enrollment 
		WHERE  number = @number;
	COMMIT;
END TRY
BEGIN CATCH
	ROLLBACK;
	SELECT ERROR_NUMBER() AS ErrorNumber,ERROR_MESSAGE() AS ErrorMessage;
END CATCH
GO

exec EnrollmentDelete '2017/18 01-10';