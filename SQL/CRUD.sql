SET ANSI_NULLS ON;
--------------------CRUD---------------------
----- Mark 
IF OBJECT_ID('dbo.MarkSelect') IS NOT NULL
BEGIN 
    DROP PROC dbo.MarkSelect 
END 
GO

CREATE PROC dbo.MarkSelect
    @id INT
AS 
	SET XACT_ABORT, NOCOUNT ON;
		SELECT id_mark, name, type_mark  
		FROM   dbo.Mark
		WHERE  (id_mark = @id OR @id IS NULL); 
GO

exec MarkSelect null;
------------------------------------------------------------

IF OBJECT_ID('dbo.MarkInsert') IS NOT NULL
BEGIN 
    DROP PROC dbo.MarkInsert 
END 
GO

CREATE PROC dbo.MarkInsert 
    @name NVARCHAR(15),
	@type_mark BIT
AS 
BEGIN TRY
	SET XACT_ABORT, NOCOUNT ON;
	BEGIN TRAN;
		INSERT INTO  dbo.Mark ( name, type_mark)
				VALUES( @name, @type_mark)
	COMMIT;
		SELECT id_mark, name, type_mark
		FROM   dbo.Mark
		WHERE  id_mark = SCOPE_IDENTITY();
END TRY
BEGIN CATCH
	ROLLBACK;
	SELECT ERROR_NUMBER() AS ErrorNumber,ERROR_MESSAGE() AS ErrorMessage;
END CATCH
GO

EXEC MarkInsert 'fd', 1;
------------------------------------------------------------------------------

IF OBJECT_ID('dbo.MarkUpdate') IS NOT NULL
BEGIN 
    DROP PROC dbo.MarkUpdate
END 
GO

CREATE PROC dbo.MarkUpdate 
	@id INT,
	@name NVARCHAR(15),
	@type_mark BIT
AS 
BEGIN TRY
	SET XACT_ABORT, NOCOUNT ON;
	BEGIN TRAN;		
		UPDATE dbo.Mark
		SET    name=@name, type_mark=@type_mark
		WHERE  id_mark = @id;
	COMMIT;
		SELECT id_mark, name, type_mark
		FROM   dbo.Mark
		WHERE  id_mark = @id;	
END TRY
BEGIN CATCH
	ROLLBACK;
	SELECT ERROR_NUMBER() AS ErrorNumber,ERROR_MESSAGE() AS ErrorMessage;
END CATCH
GO

EXEC MarkUpdate 17, 'dfd', 0;
----------------------------------------------------

IF OBJECT_ID('dbo.MarkDelete') IS NOT NULL
BEGIN 
    DROP PROC dbo.MarkDelete
END 
GO

CREATE PROC dbo.MarkDelete 
   @id INT
AS 
BEGIN TRY
	SET XACT_ABORT, NOCOUNT ON;
	BEGIN TRAN;
		DELETE
		FROM  dbo.Mark
		WHERE  id_mark = @id;
	COMMIT;
END TRY
BEGIN CATCH
	ROLLBACK;
	SELECT ERROR_NUMBER() AS ErrorNumber,ERROR_MESSAGE() AS ErrorMessage;
END CATCH
GO

exec MarkDelete 18;
-----Attribute

IF OBJECT_ID('dbo.AttributeSelect') IS NOT NULL
BEGIN 
    DROP PROC dbo.AttributeSelect 
END 
GO

CREATE PROC dbo.AttributeSelect
    @id INT = NULL
AS 
	SET XACT_ABORT, NOCOUNT ON

	BEGIN TRAN

	SELECT id_atr, name  
	FROM   dbo.Attribute
	WHERE  (id_atr = @id OR @id IS NULL) 

	COMMIT
GO

exec AttributeSelect ;
------------------------------------------------------------

IF OBJECT_ID('dbo.AttributeInsert') IS NOT NULL
BEGIN 
    DROP PROC dbo.AttributeInsert 
END 
GO

CREATE PROC dbo.AttributeInsert 
    @name NVARCHAR(15)
AS 
	SET XACT_ABORT, NOCOUNT ON
	
	BEGIN TRAN
	
	INSERT INTO  dbo.Attribute ( name )
			VALUES( @name )
	
	SELECT id_atr, name
	FROM   dbo.Attribute
	WHERE  id_atr = SCOPE_IDENTITY()
             
	COMMIT
GO

EXEC AttributeInsert 'fd';
------------------------------------------------------------------------------

IF OBJECT_ID('dbo.AttributeUpdate') IS NOT NULL
BEGIN 
    DROP PROC dbo.AttributeUpdate
END 
GO

CREATE PROC dbo.AttributeUpdate 
	@id INT,
	@name NVARCHAR(15)
AS 
	SET XACT_ABORT, NOCOUNT ON

	BEGIN TRAN
		
	UPDATE dbo.Attribute
	SET    name=@name
	WHERE  id_atr = @id
	
	SELECT id_atr, name
	FROM   dbo.Attribute
	WHERE  id_atr = @id	

	COMMIT
GO

EXEC AttributeUpdate 8, 'dfd';
----------------------------------------------------

IF OBJECT_ID('dbo.AttributeDelete') IS NOT NULL
BEGIN 
    DROP PROC dbo.AttributeDelete
END 
GO

CREATE PROC dbo.AttributeDelete 
   @id INT
AS 
	SET XACT_ABORT, NOCOUNT ON
	
	BEGIN TRAN

	DELETE
	FROM  dbo.Attribute
	WHERE  id_atr = @id

	COMMIT
GO

exec AttributeDelete 10;


------------------------------------------------------------------

------District

IF OBJECT_ID('dbo.DistrictSelect') IS NOT NULL
BEGIN 
    DROP PROC dbo.DistrictSelect 
END 
GO

CREATE PROC dbo.DistrictSelect
    @id INT
AS 
	SET XACT_ABORT, NOCOUNT ON

	BEGIN TRAN

	SELECT id_distr, name  
	FROM   dbo.District
	WHERE  (id_distr = @id OR @id IS NULL) 

	COMMIT
GO

exec DistrictSelect null;
------------------------------------------------------------

IF OBJECT_ID('dbo.DistrictInsert') IS NOT NULL
BEGIN 
    DROP PROC dbo.DistrictInsert 
END 
GO

CREATE PROC dbo.DistrictInsert 
    @name NVARCHAR(12)
AS 
	SET XACT_ABORT, NOCOUNT ON
	
	BEGIN TRAN
	
	INSERT INTO  dbo.District ( name )
			VALUES( @name )
	
	SELECT id_distr, name
	FROM   dbo.District
	WHERE  id_distr = SCOPE_IDENTITY()
             
	COMMIT
GO

------------------------------------------------------------------------------

IF OBJECT_ID('dbo.DistrictUpdate') IS NOT NULL
BEGIN 
    DROP PROC dbo.DistrictUpdate
END 
GO

CREATE PROC dbo.DistrictUpdate 
	@id INT,
	@name NVARCHAR(12)
AS 
	SET XACT_ABORT, NOCOUNT ON

	BEGIN TRAN
		
	UPDATE dbo.District
	SET    name=@name
	WHERE  id_distr = @id
	
	SELECT id_distr, name
	FROM   dbo.District
	WHERE  id_distr = @id	

	COMMIT
GO
----------------------------------------------------

IF OBJECT_ID('dbo.DistrictDelete') IS NOT NULL
BEGIN 
    DROP PROC dbo.DistrictDelete
END 
GO

CREATE PROC dbo.DistrictDelete 
   @id INT
AS 
	SET XACT_ABORT, NOCOUNT ON
	
	BEGIN TRAN

	DELETE
	FROM  dbo.District
	WHERE  id_distr = @id

	COMMIT
GO
-----------------------------------------------------------------------
-----------------------------------------------------------------------

-----TypeAddress

IF OBJECT_ID('dbo.TypeAddressSelect') IS NOT NULL
BEGIN 
    DROP PROC dbo.TypeAddressSelect 
END 
GO

CREATE PROC dbo.TypeAddressSelect
    @id INT
AS 
	SET XACT_ABORT, NOCOUNT ON

	BEGIN TRAN

	SELECT id_type, name_type  
	FROM   dbo.TypeAddress
	WHERE  (id_type = @id OR @id IS NULL) 

	COMMIT
GO

exec TypeAddressSelect null;
------------------------------------------------------------

IF OBJECT_ID('dbo.TypeAddressInsert') IS NOT NULL
BEGIN 
    DROP PROC dbo.TypeAddressInsert 
END 
GO

CREATE PROC dbo.TypeAddressInsert 
    @name NVARCHAR(30)
AS 
	SET XACT_ABORT, NOCOUNT ON
	
	BEGIN TRAN
	
	INSERT INTO  dbo.TypeAddress ( name_type )
			VALUES( @name )
	
	SELECT id_type, name_type
	FROM   dbo.TypeAddress
	WHERE  id_type = SCOPE_IDENTITY()
             
	COMMIT
GO

------------------------------------------------------------------------------

IF OBJECT_ID('dbo.TypeAddressUpdate') IS NOT NULL
BEGIN 
    DROP PROC dbo.TypeAddressUpdate
END 
GO

CREATE PROC dbo.TypeAddressUpdate 
	@id INT,
	@name NVARCHAR(30)
AS 
	SET XACT_ABORT, NOCOUNT ON

	BEGIN TRAN
		
	UPDATE dbo.TypeAddress
	SET    name_type=@name
	WHERE  id_type = @id
	
	SELECT id_type, name_type
	FROM   dbo.TypeAddress
	WHERE  id_type = @id	

	COMMIT
GO
----------------------------------------------------

IF OBJECT_ID('dbo.TypeAddressDelete') IS NOT NULL
BEGIN 
    DROP PROC dbo.TypeAddressDelete
END 
GO

CREATE PROC dbo.TypeAddressDelete 
   @id INT
AS 
	SET XACT_ABORT, NOCOUNT ON
	
	BEGIN TRAN

	DELETE
	FROM  dbo.TypeAddress
	WHERE  id_type = @id

	COMMIT
GO
--------------------------------------------------------------------------
--------------------------------------------------------------------------

----SubjectCT

IF OBJECT_ID('dbo.SubjectCTSelect') IS NOT NULL
BEGIN 
    DROP PROC dbo.SubjectCTSelect 
END 
GO

CREATE PROC dbo.SubjectCTSelect
    @id INT
AS 
	SET XACT_ABORT, NOCOUNT ON

	BEGIN TRAN

	SELECT id_subj, name  
	FROM   dbo.SubjectCT
	WHERE  (id_subj = @id OR @id IS NULL) 

	COMMIT
GO

exec SubjectCTSelect null;
------------------------------------------------------------

IF OBJECT_ID('dbo.SubjectCTInsert') IS NOT NULL
BEGIN 
    DROP PROC dbo.SubjectCTInsert 
END 
GO

CREATE PROC dbo.SubjectCTInsert 
    @name NVARCHAR(20)
AS 
	SET XACT_ABORT, NOCOUNT ON
	
	BEGIN TRAN
	
	INSERT INTO  dbo.SubjectCT( name )
			VALUES( @name )
	
	SELECT id_subj, name
	FROM   dbo.SubjectCT
	WHERE  id_subj = SCOPE_IDENTITY()
             
	COMMIT
GO

------------------------------------------------------------------------------

IF OBJECT_ID('dbo.SubjectCTUpdate') IS NOT NULL
BEGIN 
    DROP PROC dbo.SubjectCTUpdate
END 
GO

CREATE PROC dbo.SubjectCTUpdate 
	@id INT,
	@name NVARCHAR(20)
AS 
	SET XACT_ABORT, NOCOUNT ON

	BEGIN TRAN
		
	UPDATE dbo.SubjectCT
	SET    name=@name
	WHERE  id_subj = @id
	
	SELECT id_subj, name
	FROM   dbo.SubjectCT
	WHERE  id_subj = @id	

	COMMIT
GO
----------------------------------------------------

IF OBJECT_ID('dbo.SubjectCTDelete') IS NOT NULL
BEGIN 
    DROP PROC dbo.SubjectCTDelete
END 
GO

CREATE PROC dbo.SubjectCTDelete 
   @id INT
AS 
	SET XACT_ABORT, NOCOUNT ON
	
	BEGIN TRAN

	DELETE
	FROM  dbo.SubjectCT
	WHERE  id_subj = @id

	COMMIT
GO
-------------------------------------------------------------------------
-------------------------------------------------------------------------

-----Lenguage

IF OBJECT_ID('dbo.LenguageSelect') IS NOT NULL
BEGIN 
    DROP PROC dbo.LenguageSelect 
END 
GO

CREATE PROC dbo.LenguageSelect
    @short_name NVARCHAR(4)
AS 
	SET XACT_ABORT, NOCOUNT ON

	BEGIN TRAN

	SELECT short_name, full_name  
	FROM   dbo.Lenguage
	WHERE  (short_name = @short_name OR @short_name IS NULL) 

	COMMIT
GO

exec LenguageSelect null;
------------------------------------------------------------

IF OBJECT_ID('dbo.LenguageInsert') IS NOT NULL
BEGIN 
    DROP PROC dbo.LenguageInsert 
END 
GO

CREATE PROC dbo.LenguageInsert 
	@short_name NVARCHAR(4),
	@full_name NVARCHAR(20)
AS 
	SET XACT_ABORT, NOCOUNT ON
	
	BEGIN TRAN
	
	INSERT INTO  dbo.Lenguage ( short_name, full_name)
			VALUES(@short_name, @full_name )
	
	SELECT short_name, full_name
	FROM   dbo.Lenguage
	WHERE  short_name = @short_name
             
	COMMIT
GO
------------------------------------------------------------------------------

IF OBJECT_ID('dbo.LenguageUpdate') IS NOT NULL
BEGIN 
    DROP PROC dbo.LenguageUpdate
END 
GO

CREATE PROC dbo.LenguageUpdate 
	@short_name NVARCHAR(4),
	@short_name_new NVARCHAR(4),
	@full_name NVARCHAR(20)
AS 
	SET XACT_ABORT, NOCOUNT ON

	BEGIN TRAN
		
	UPDATE dbo.Lenguage
	SET    short_name = @short_name_new, full_name = @full_name
	WHERE  short_name = @short_name
	
	SELECT short_name, full_name
	FROM   dbo.Lenguage
	WHERE  short_name = @short_name_new

	COMMIT
GO
----------------------------------------------------

IF OBJECT_ID('dbo.LenguageDelete') IS NOT NULL
BEGIN 
    DROP PROC dbo.LenguageDelete
END 
GO

CREATE PROC dbo.LenguageDelete 
	@short_name NVARCHAR(4)
AS 
	SET XACT_ABORT, NOCOUNT ON
	
	BEGIN TRAN

	DELETE
	FROM  dbo.Lenguage
	WHERE  short_name = @short_name

	COMMIT
GO
--------------------------------------------------------------------
--------------------------------------------------------------------

----FormProcess

IF OBJECT_ID('dbo.FormProcessSelect') IS NOT NULL
BEGIN 
    DROP PROC dbo.FormProcessSelect 
END 
GO

CREATE PROC dbo.FormProcessSelect
    @id NVARCHAR(2)
AS 
	SET XACT_ABORT, NOCOUNT ON

	BEGIN TRAN

	SELECT id_form, name  
	FROM   dbo.FormProcess
	WHERE  (id_form = @id OR @id IS NULL) 

	COMMIT
GO

exec FormProcessSelect null;
------------------------------------------------------------

IF OBJECT_ID('dbo.FormProcessInsert') IS NOT NULL
BEGIN 
    DROP PROC dbo.FormProcessInsert 
END 
GO

CREATE PROC dbo.FormProcessInsert 
	@id NVARCHAR(2),
	@name NVARCHAR(30)
AS 
	SET XACT_ABORT, NOCOUNT ON
	
	BEGIN TRAN
	
	INSERT INTO  dbo.FormProcess ( id_form, name)
			VALUES(@id, @name )
	
	SELECT id_form, name
	FROM   dbo.FormProcess
	WHERE  id_form= @id
             
	COMMIT
GO
------------------------------------------------------------------------------

IF OBJECT_ID('dbo.FormProcessUpdate') IS NOT NULL
BEGIN 
    DROP PROC dbo.FormProcessUpdate
END 
GO

CREATE PROC dbo.FormProcessUpdate 
	@id NVARCHAR(2),
	@id_new NVARCHAR(2),
	@name NVARCHAR(30)
AS 
	SET XACT_ABORT, NOCOUNT ON

	BEGIN TRAN
		
	UPDATE dbo.FormProcess
	SET    id_form = @id_new, name = @name
	WHERE  id_form = @id
	
	SELECT id_form, name
	FROM   dbo.FormProcess
	WHERE  id_form = @id_new

	COMMIT
GO
----------------------------------------------------

IF OBJECT_ID('dbo.FormProcessDelete') IS NOT NULL
BEGIN 
    DROP PROC dbo.FormProcessDelete
END 
GO

CREATE PROC dbo.FormProcessDelete 
	@id NVARCHAR(2)
AS 
	SET XACT_ABORT, NOCOUNT ON
	
	BEGIN TRAN

	DELETE
	FROM  dbo.FormProcess
	WHERE  id_form = @id

	COMMIT
GO
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
