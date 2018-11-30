USE master;
--обычные студенты
CREATE LOGIN studentdb 
	WITH PASSWORD=N'student',
	DEFAULT_DATABASE=Deanery, 
	DEFAULT_LANGUAGE=[русский];
 
ALTER LOGIN studentdb ENABLE;

--старосты
CREATE LOGIN leaderdb 
	WITH PASSWORD=N'leader',
	DEFAULT_DATABASE=Deanery, 
	DEFAULT_LANGUAGE=[русский];

ALTER LOGIN leaderdb ENABLE;

--админы
CREATE LOGIN admindb 
	WITH PASSWORD=N'admin',
	DEFAULT_DATABASE=Deanery, 
	DEFAULT_LANGUAGE=[русский];

ALTER LOGIN admindb ENABLE;

DROP LOGIN studentdb;
DROP LOGIN leaderdb;
DROP LOGIN admindb;




use Deanery;

CREATE USER student FOR LOGIN studentdb; 
CREATE USER leader FOR LOGIN leaderdb; 
CREATE USER [admin] FOR LOGIN admindb;  


DROP USER student;
DROP USER leader;
DROP USER [admin];

--@"Data Source=DESKTOP-FFV5E68\SQLEXPRESS;Integrated Security=False;User ID=userln;Password=userln;ApplicationIntent=ReadWrite;"))
--@"Data Source=DESKTOP-FFV5E68\SQLEXPRESS;Integrated Security=False;User ID=adminln;Password=adminln;ApplicationIntent=ReadWrite;"))
