----AddressStudent
IF OBJECT_ID('dbo.AddressByStudent') IS NOT NULL
BEGIN 
    DROP PROC dbo.AddressByStudent
END 
GO

CREATE PROC dbo.AddressByStudent
	@record_book INT
AS 
	SET XACT_ABORT, NOCOUNT ON;
		SELECT a.record_book, r.name as region, d.name as district, a.[address], t.name_type 
		FROM dbo.AddressStudent a inner join dbo.Region r on a.region = r.id_reg
								  inner join dbo.District d on r.district = d.id_distr
								  inner join dbo.TypeAddress t on a.type_addr = t.id_type
		WHERE  record_book = @record_book;
GO
exec dbo.AddressByStudent 71600135;
-----------------------------------------------------------------------------

IF OBJECT_ID('dbo.AddressStudentInsert') IS NOT NULL
BEGIN 
    DROP PROC dbo.AddressStudentInsert
END 
GO

CREATE PROC dbo.AddressStudentInsert
	@rc INT OUTPUT,
	@record_book INT,
	@region_name NVARCHAR(20) = '',					
	@address NVARCHAR(150), 
	@type_addr INT 			
AS 
BEGIN TRY
	SET XACT_ABORT, NOCOUNT ON;
	SET @rc = 0;

	DECLARE @id_region INT = 0;
	SELECT @id_region = id_reg FROM dbo.Region WHERE LOWER(name) like LOWER(@region_name);
	IF(@region_name IS NULL)
		SELECT @id_region = id_reg FROM dbo.Region WHERE name=''; 

	IF( EXISTS(SELECT record_book FROM dbo.Student WHERE record_book = @record_book) AND 
		EXISTS(SELECT id_type FROM dbo.TypeAddress WHERE id_type = @type_addr) )
	BEGIN
		BEGIN TRAN;
			INSERT INTO dbo.AddressStudent (record_book, region,[address], type_addr)
				VALUES  (@record_book, @id_region, @address, @type_addr);
		COMMIT;
		SET @rc = 1;
	END
END TRY
BEGIN CATCH
	SET @rc = -1;
	ROLLBACK;
	SELECT ERROR_NUMBER() AS ErrorNumber,ERROR_MESSAGE() AS ErrorMessage;
END CATCH
GO

DECLARE @a int;
EXEC dbo.AddressStudentInsert @a out, 71600135, 'КоБРИНСКИЙ', 'г.Кобрин, ул.17 Сентября, д.15, к.1', 1;
select @a;
--------------------------------------------------------------------------------

IF OBJECT_ID('dbo.AddressStudentDelete') IS NOT NULL
BEGIN 
    DROP PROC dbo.AddressStudentDelete
END 
GO

CREATE PROC dbo.AddressStudentDelete
	@rc INT OUTPUT,
	@record_book INT,
	@type_addr INT 
AS 
BEGIN TRY
	SET XACT_ABORT, NOCOUNT ON;
	SET @rc = 0;

	IF( EXISTS(SELECT record_book FROM dbo.AddressStudent WHERE record_book = @record_book AND type_addr=@type_addr))
	BEGIN
		BEGIN TRAN;
			DELETE 
			FROM dbo.AddressStudent
			WHERE record_book = @record_book AND type_addr=@type_addr;
		COMMIT;
		SET @rc = 1;
	END
END TRY
BEGIN CATCH
	SET @rc = -1;
	ROLLBACK;
	SELECT ERROR_NUMBER() AS ErrorNumber,ERROR_MESSAGE() AS ErrorMessage;
END CATCH

DECLARE @a int;
exec dbo.AddressStudentDelete @a out, 71600135, 1;
SELECT @a;
