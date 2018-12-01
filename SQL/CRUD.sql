SET ANSI_NULLS ON;
--------------------CRUD---------------------


----Enrollment
IF OBJECT_ID('dbo.EnrollmentSelect') IS NOT NULL
BEGIN 
    DROP PROC dbo.EnrollmentSelect 
END 
GO

CREATE PROC dbo.EnrollmentSelect
    @number VARCHAR(15)
AS 
	SET XACT_ABORT, NOCOUNT ON

	BEGIN TRAN

	SELECT number, date_sig, signed  
	FROM   dbo.Enrollment 
	WHERE  (number = @number OR @number IS NULL) 

	COMMIT
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
	SET XACT_ABORT, NOCOUNT ON
	
	BEGIN TRAN
	
	INSERT INTO  dbo.Enrollment (number, date_sig, signed)
			VALUES( @number, @date_sig, @signed)
	
	-- Begin Return Select <- do not remove
	SELECT number, date_sig, signed
	FROM   dbo.Enrollment
	WHERE  number = @number
	-- End Return Select <- do not remove
             
	COMMIT
GO

EXEC EnrollmentInsert '2017/18 10-01', '2017-10-01', '״טלאם ִ.ֲ.';
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
	SET XACT_ABORT, NOCOUNT ON

	BEGIN TRAN
		
	UPDATE dbo.Enrollment 
	SET    number = @numbernew, date_sig = @date_sig,  signed = @signed
	WHERE  number = @number
	
	SELECT number, date_sig, signed
	FROM   dbo.Enrollment 
	WHERE  number = @numbernew	

	COMMIT
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
	SET XACT_ABORT, NOCOUNT ON
	
	BEGIN TRAN

	DELETE
	FROM  dbo.Enrollment 
	WHERE  number = @number

	COMMIT
GO

exec EnrollmentDelete '2017/18 01-10';
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------


----Expelled

IF OBJECT_ID('dbo.ExpelledtSelect') IS NOT NULL
BEGIN 
    DROP PROC dbo.ExpelledSelect 
END 
GO

CREATE PROC dbo.ExpelledSelect
    @number VARCHAR(15)
AS 
	SET XACT_ABORT, NOCOUNT ON

	BEGIN TRAN

	SELECT number, date_sig, signed  
	FROM   dbo.Expelled 
	WHERE  (number = @number OR @number IS NULL) 

	COMMIT
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
	SET XACT_ABORT, NOCOUNT ON
	
	BEGIN TRAN
	
	INSERT INTO  dbo.Expelled (number, date_sig, signed)
			VALUES( @number, @date_sig, @signed)
	
	-- Begin Return Select <- do not remove
	SELECT number, date_sig, signed
	FROM   dbo.Expelled
	WHERE  number = @number
	-- End Return Select <- do not remove
             
	COMMIT
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
	SET XACT_ABORT, NOCOUNT ON

	BEGIN TRAN
		
	UPDATE dbo.Expelled 
	SET    number = @numbernew, date_sig = @date_sig,  signed = @signed
	WHERE  number = @number
	
	SELECT number, date_sig, signed
	FROM   dbo.Expelled
	WHERE  number = @numbernew	

	COMMIT
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
	SET XACT_ABORT, NOCOUNT ON
	
	BEGIN TRAN

	DELETE
	FROM  dbo.Expelled
	WHERE  number = @number

	COMMIT
GO

exec ExpelledDelete '2017/18 01-10';
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

----- Mark 
IF OBJECT_ID('dbo.MarkSelect') IS NOT NULL
BEGIN 
    DROP PROC dbo.MarkSelect 
END 
GO

CREATE PROC dbo.MarkSelect
    @id INT
AS 
	SET XACT_ABORT, NOCOUNT ON

	BEGIN TRAN

	SELECT id_mark, name, type_mark  
	FROM   dbo.Mark
	WHERE  (id_mark = @id OR @id IS NULL) 

	COMMIT
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
	SET XACT_ABORT, NOCOUNT ON
	
	BEGIN TRAN
	
	INSERT INTO  dbo.Mark ( name, type_mark)
			VALUES( @name, @type_mark)
	
	-- Begin Return Select <- do not remove
	SELECT id_mark, name, type_mark
	FROM   dbo.Mark
	WHERE  id_mark = SCOPE_IDENTITY()
	-- End Return Select <- do not remove
             
	COMMIT
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
	SET XACT_ABORT, NOCOUNT ON

	BEGIN TRAN
		
	UPDATE dbo.Mark
	SET    name=@name, type_mark=@type_mark
	WHERE  id_mark = @id
	
	SELECT id_mark, name, type_mark
	FROM   dbo.Mark
	WHERE  id_mark = @id	

	COMMIT
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
	SET XACT_ABORT, NOCOUNT ON
	
	BEGIN TRAN

	DELETE
	FROM  dbo.Mark
	WHERE  id_mark = @id

	COMMIT
GO

exec MarkDelete 18;
------------------------------------------------------------
------------------------------------------------------------

-----Attribute

IF OBJECT_ID('dbo.AttributeSelect') IS NOT NULL
BEGIN 
    DROP PROC dbo.AttributeSelect 
END 
GO

CREATE PROC dbo.AttributeSelect
    @id INT
AS 
	SET XACT_ABORT, NOCOUNT ON

	BEGIN TRAN

	SELECT id_atr, name  
	FROM   dbo.Attribute
	WHERE  (id_atr = @id OR @id IS NULL) 

	COMMIT
GO

exec AttributeSelect null;
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
	
	-- Begin Return Select <- do not remove
	SELECT id_atr, name
	FROM   dbo.Attribute
	WHERE  id_atr = SCOPE_IDENTITY()
	-- End Return Select <- do not remove
             
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
-------------------------------------------------------------------
-------------------------------------------------------------------

----Profession
IF OBJECT_ID('dbo.ProfessionSelect') IS NOT NULL
BEGIN 
    DROP PROC dbo.ProfessionSelect 
END 
GO

CREATE PROC dbo.ProfessionSelect
    @id INT
AS 
	SET XACT_ABORT, NOCOUNT ON

	BEGIN TRAN

	SELECT id_prof, name  
	FROM   dbo.Profession
	WHERE  (id_prof = @id OR @id IS NULL) 

	COMMIT
GO

exec ProfessionSelect null;
------------------------------------------------------------

IF OBJECT_ID('dbo.ProfessionInsert') IS NOT NULL
BEGIN 
    DROP PROC dbo.ProfessionInsert 
END 
GO

CREATE PROC dbo.ProfessionInsert 
    @name NVARCHAR(30)
AS 
	SET XACT_ABORT, NOCOUNT ON
	
	BEGIN TRAN
	
	INSERT INTO  dbo.Profession ( name )
			VALUES( @name )
	
	-- Begin Return Select <- do not remove
	SELECT id_prof, name
	FROM   dbo.Profession
	WHERE  id_prof= SCOPE_IDENTITY()
	-- End Return Select <- do not remove
             
	COMMIT
GO
------------------------------------------------------------------------------

IF OBJECT_ID('dbo.ProfessionUpdate') IS NOT NULL
BEGIN 
    DROP PROC dbo.ProfessionUpdate
END 
GO

CREATE PROC dbo.ProfessionUpdate 
	@id INT,
	@name NVARCHAR(30)
AS 
	SET XACT_ABORT, NOCOUNT ON

	BEGIN TRAN
		
	UPDATE dbo.Profession
	SET    name=@name
	WHERE  id_prof = @id
	
	SELECT id_prof, name
	FROM   dbo.Profession
	WHERE  id_prof = @id	

	COMMIT
GO
----------------------------------------------------

IF OBJECT_ID('dbo.ProfessionDelete') IS NOT NULL
BEGIN 
    DROP PROC dbo.ProfessionDelete
END 
GO

CREATE PROC dbo.ProfessionDelete 
   @id INT
AS 
	SET XACT_ABORT, NOCOUNT ON
	
	BEGIN TRAN

	DELETE
	FROM  dbo.Profession
	WHERE  id_prof = @id

	COMMIT
GO
---------------------------------------------------------------------
---------------------------------------------------------------------

-----Discipline