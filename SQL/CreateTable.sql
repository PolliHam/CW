use Deanery;
--1 Распоряжения о зачислении
CREATE TABLE Enrollment(
	number VARCHAR(15) NOT NULL,                            --номер распоряжения
	date_sig DATE NOT NULL,									--дата подписи
	signed NVARCHAR(15) NOT NULL,							--кто подписал

	CONSTRAINT PK_EnrollmentNumber PRIMARY KEY (number)
);

--2 Распоряжения об отчислении
CREATE TABLE Expelled(
	number VARCHAR(15) NOT NULL,							--номер распоряжения
	date_sig DATE NOT NULL,									--дата подписи
	signed NVARCHAR(15) NOT NULL,							--кто подписал

	CONSTRAINT PK_ExpelledNumber PRIMARY KEY (number)
);

--3 Справочник оценок 
CREATE TABLE Mark(
	id_mark INT IDENTITY(0, 1),								--код оценки
	name NVARCHAR(15) NOT NULL,								--наименование(0-9, зачтено)
	type_mark BIT NOT NULL,									--тип (положительный-1, отрицательный-0)

	CONSTRAINT PK_MarkId PRIMARY KEY (id_mark)
);

--4 Справочник с признаком в зачётке
CREATE TABLE Attribute(
	id_atr INT IDENTITY(1, 1),								--код признака
	name NVARCHAR(15) NOT NULL,								--наименование(зачёт,экзамен, диф зачёт, курсач)

	CONSTRAINT PK_AttributeId PRIMARY KEY (id_atr)
);

--5 Справочник профессий
CREATE TABLE Profession(
	id_prof INT IDENTITY(1, 1),								--код профессии
	name NVARCHAR(30) UNIQUE NOT NULL,						--наименование
	 
	CONSTRAINT PK_ProfessionId PRIMARY KEY (id_prof)
);

--6 Перечень учебных дисциплин
CREATE TABLE Discipline(
	id_disc INT IDENTITY(1, 1),								--код дисциплины
	short_name NVARCHAR(10) UNIQUE NOT NULL,				--сокращённое название
	full_name NVARCHAR(50)  UNIQUE NOT NULL,				--полное название
	link NVARCHAR(500)										--ссылки на ресурсы

	CONSTRAINT PK_DisciplineId PRIMARY KEY (id_disc)
);

--7 Перечень кафедр
CREATE TABLE Pulpit(
	short_name NVARCHAR(10)  NOT NULL,						--сокращённое название
	full_name NVARCHAR(50) UNIQUE  NOT NULL,				--полное название
	link NVARCHAR(300)										--ссылки на ресурсы

	CONSTRAINT PK_PulpitId PRIMARY KEY (short_name)
);

--8 Перечень всех преподвавтелей
CREATE TABLE Teacher(
	id_teach INT IDENTITY(1, 1),							--код преподавателя
	short_fio NVARCHAR(10)  NOT NULL,						--сокращённое имя
	full_fio NVARCHAR(50)  NOT NULL,						--полное имя
	pulpit NVARCHAR(10),									--кафедра
	work BIT NOT NULL,										--работает ли ещё(0-нет, 1-да)

	CONSTRAINT PK_TeacherId PRIMARY KEY (id_teach),
	CONSTRAINT FK_Teacher_To_Pulpit FOREIGN KEY (pulpit) REFERENCES Pulpit (short_name) ON DELETE SET NULL
);

--9 Ведомости экзаменов и зачётов
CREATE TABLE ExamCredit(
	number_statement VARCHAR(10) NOT NULL,					--номер ведомости
	attribute INT  NOT NULL,								--признак
	date_sig DATE NOT NULL,									--дата проведения
	discipline INT  NOT NULL,								--код дисциплины
	teacher_1 INT NOT NULL,									--код преподавателя
	teacher_2 INT DEFAULT NULL,								--код второго преподавателя
	teacher_3 INT DEFAULT NULL,								--код третьего преподавателя
	
	CONSTRAINT Pk_ExamCreditNum PRIMARY KEY (number_statement),
	CONSTRAINT FK_ExamCredit_To_Attribute FOREIGN KEY (attribute) REFERENCES  Attribute (id_atr),
	CONSTRAINT FK_ExamCredit_To_Discipline FOREIGN KEY (discipline) REFERENCES Discipline (id_disc),
	CONSTRAINT FK_ExamCredit_To_Teacher1 FOREIGN KEY (teacher_1) REFERENCES Teacher (id_teach),
	CONSTRAINT FK_ExamCredit_To_Teacher2 FOREIGN KEY (teacher_2) REFERENCES Teacher (id_teach),
	CONSTRAINT FK_ExamCredit_To_Teacher3 FOREIGN KEY (teacher_3) REFERENCES Teacher (id_teach)
);

--10 Список областей
CREATE TABLE District(
	id_distr INT IDENTITY(1, 1),							--код области
	name NVARCHAR(12)  UNIQUE,								--наименование

	CONSTRAINT PK_DistrictId PRIMARY KEY (id_distr)
);

--11 Перечень районов
CREATE TABLE Region(
	id_reg INT IDENTITY(1, 1),								--код области
	name NVARCHAR(20),										--наименование
	district INT,											--область

	CONSTRAINT PK_RegionId PRIMARY KEY (id_reg),			
	CONSTRAINT FK_Region_To_District FOREIGN KEY (district) REFERENCES District (id_distr)
);

--12 Справочник для адресов (тип адреса)
CREATE TABLE TypeAddress(
	id_type INT IDENTITY(1, 1),								--код типа
	name_type NVARCHAR(30) UNIQUE NOT NULL,					--наименование типа

	CONSTRAINT PK_TypeAddressId PRIMARY KEY (id_type)
);

--13 Перечень предметов ЦТ
CREATE TABLE SubjectCT(
	id_subj INT IDENTITY(1, 1),								--код предмета
	name NVARCHAR(20) UNIQUE NOT NULL,						--наименование	
									
	CONSTRAINT PK_SubjectCTId PRIMARY KEY (id_subj)
);

--14 Перечень специальностей
CREATE TABLE Speciality(
	kod_special NVARCHAR(13) NOT NULL,						--код специальности
	short_name NVARCHAR(10) UNIQUE  NOT NULL,				--сокращённое название
	full_name NVARCHAR(90) UNIQUE  NOT NULL,				--полное название
	specialization NVARCHAR(35)  NOT NULL,					--специализация
	subject_lenguage1 INT NOT NULL ,						--предмет ЦТ язык
	subject_lenguage2 INT NOT NULL ,						--предмет ЦТ язфк
	subject_2 INT NOT NULL,									--предмет ЦТ (приоритет)
	subject_3 INT NOT NULL,									--предмет ЦТ
	
	CONSTRAINT PK_SpecialityId PRIMARY KEY (kod_special),
	CONSTRAINT FK_SpecialityLen1_To_SubjectCT FOREIGN KEY (subject_lenguage1) REFERENCES SubjectCT (id_subj),
	CONSTRAINT FK_SpecialityLen2_To_SubjectCT FOREIGN KEY (subject_lenguage2) REFERENCES SubjectCT (id_subj),
	CONSTRAINT FK_Speciality2_To_SubjectCT FOREIGN KEY (subject_2) REFERENCES SubjectCT (id_subj),
	CONSTRAINT FK_Speciality3_To_SubjectCT FOREIGN KEY (subject_3) REFERENCES SubjectCT (id_subj)
);


--15 Список групп
CREATE TABLE GroupStudent(
	id_group  NVARCHAR(15) NOT NULL,						--код группы
	course INT NOT NULL,									--курс 
	group_number INT  NOT NULL,								--группа
	kod_special NVARCHAR(13) NOT NULL,						--код специальности
	begin_learning DATE NOT NULL,							--начало обучения
	end_learning DATE NOT NULL,								--конец обучения
	
	CONSTRAINT PK_GroupId PRIMARY KEY (id_group),
	CONSTRAINT FK_Group_To_SubjectCT FOREIGN KEY (kod_special) REFERENCES Speciality (kod_special)
);


--16 Список всех студентов
CREATE TABLE Student(
	record_book INT NOT NULL,								--номер зачётной книжки
	surname NVARCHAR(15) NOT NULL,							--фамилия
	first_name NVARCHAR(20) NOT NULL,						--имя
	patronymic NVARCHAR(15),								--отчество
	sex NCHAR(1) CHECK (sex in('Ж','М')),					--пол
	date_birth DATE NOT NULL,								--дата рождения
	id_group  NVARCHAR(15) NOT NULL,						--код группы
	form  NCHAR(1) CHECK (form in('П','Б')),				--форма обучения
	dismissed BIT NOT NULL DEFAULT 0,						--был ли отчислен (0-нет, 1-да)
	restored BIT NOT NULL DEFAULT 0,						--был ли восстановлен (0-нет, 1-да)
	leader BIT NOT NULL DEFAULT 0,							--является ли старостой (0-нет, 1-да)
	
	CONSTRAINT PK_StudentId PRIMARY KEY (record_book),
	CONSTRAINT FK_Student_To_Group FOREIGN KEY (id_group) REFERENCES GroupStudent (id_group)
);

--17 Результаты ЦТ каждого студента
CREATE TABLE ResultCT(
	record_book INT NOT NULL,								--номер зачётной книжки
	id_subj INT NOT NULL,									--код предмета ЦТ
	score INT CHECK(score between 0 and 100),				--балл
	year_ct INT NOT NULL,									--год
	
	CONSTRAINT PK_ResultCT PRIMARY KEY (record_book,id_subj),
	CONSTRAINT FK_ResultCT_To_Student FOREIGN KEY (record_book) REFERENCES Student (record_book),
	CONSTRAINT FK_ResultCT_To_SubjectCT FOREIGN KEY (id_subj) REFERENCES  SubjectCT (id_subj)
);

--18 Список зачисленных студентов по распоряжениям
CREATE TABLE ListEnrollment(
	number_enrol VARCHAR(15) NOT NULL,						--номер распоряжения
	record_book INT NOT NULL,								--номер зачётной книжки
	id_group  NVARCHAR(15) NOT NULL,						--код группы
	
	CONSTRAINT PK_ListEnrollment PRIMARY KEY (number_enrol,record_book,id_group),
	CONSTRAINT FK_ListEnrollment_To_SubjectCT FOREIGN KEY (number_enrol) REFERENCES  Enrollment (number),
	CONSTRAINT FK_ListEnrollment_To_Student FOREIGN KEY (record_book) REFERENCES Student (record_book),
	CONSTRAINT FK_ListEnrollment_To_GroupStudent FOREIGN KEY (id_group) REFERENCES  GroupStudent (id_group)
);

--19 Список отчисленных студентов по распоряжениям
CREATE TABLE ListExpelled(
	number_exp VARCHAR(15) NOT NULL,						--номер распоряжения
	record_book INT NOT NULL,								--номер зачётной книжки
	id_group  NVARCHAR(15) NOT NULL,						--код группы
	
	CONSTRAINT PK_ListExpelled PRIMARY KEY (number_exp,record_book,id_group),
	CONSTRAINT FK_ListExpelled_To_SubjectCT FOREIGN KEY (number_exp) REFERENCES  Expelled (number),
	CONSTRAINT FK_ListExpelled_To_Student FOREIGN KEY (record_book) REFERENCES Student (record_book),
	CONSTRAINT FK_ListExpelled_To_GroupStudent FOREIGN KEY (id_group) REFERENCES  GroupStudent (id_group)
);

--20 Список адресов 
CREATE TABLE AddressStudent(
	id_address INT IDENTITY(1, 1),							--id
	record_book INT NOT NULL,   							--номер зачётной книжки
	region INT NOT NULL,									--район
	address_st NVARCHAR(150) NOT NULL,						--адресс
	type_addr INT NOT NULL,									--тип адреса
	
	CONSTRAINT PK_AddressStudent PRIMARY KEY (id_address),
	CONSTRAINT FK_AddressStudent_To_Student FOREIGN KEY (record_book) REFERENCES Student (record_book),
	CONSTRAINT FK_AddressStudent_To_Region FOREIGN KEY (region) REFERENCES  Region (id_reg),
	CONSTRAINT FK_AddressStudent_To_TypeAddress FOREIGN KEY (type_addr) REFERENCES  TypeAddress (id_type)
);


--21 План дисциплин 
CREATE TABLE PlanDiscipline(
	discipline INT NOT NULL,								--дисциплина
	speciality NVARCHAR(13) NOT NULL,						--специальность
	semester INT CHECK(semester between 1 and 10),			--семестр
	total INT NOT NULL ,									--всего часов 
	lecture INT NOT NULL DEFAULT 0,							--лекции
	lab INT NOT NULL DEFAULT 0,								--лабораторные 
	practice INT NOT NULL DEFAULT 0,						--практические
	seminar INT NOT NULL DEFAULT 0,							--семинары
	form INT NOT NULL,										--форма аттестации по окончании(экзамен, зачёт)
	
	CONSTRAINT PK_PlanDiscipline PRIMARY KEY (discipline,speciality,semester),
	CONSTRAINT FK_PlanDiscipline_To_Discipline FOREIGN KEY (discipline) REFERENCES  Discipline (id_disc),
	CONSTRAINT FK_PlanDiscipline_To_Speciality FOREIGN KEY (speciality) REFERENCES  Speciality (kod_special),
	CONSTRAINT FK_PlanDiscipline_To_Attribute FOREIGN KEY (form) REFERENCES  Attribute (id_atr)
);

--22 Результаты экзаменов и зачётов
CREATE TABLE ResultExam(
	number_statement VARCHAR(10) NOT NULL,					--номер ведомости,
	record_book INT NOT NULL,								--номер зачётной книжки
	mark INT NOT NULL,  									--код оценки

	CONSTRAINT PK_ResultExam PRIMARY KEY (number_statement, record_book),
	CONSTRAINT FK_ResultExam_To_ExamCredit FOREIGN KEY (number_statement) REFERENCES  ExamCredit (number_statement),
	CONSTRAINT FK_ResultExam_To_Student FOREIGN KEY (record_book) REFERENCES  Student (record_book),
	CONSTRAINT FK_ResultExam_To_Mark FOREIGN KEY (mark) REFERENCES  Mark (id_mark)
);


--23 Лист аттестации
CREATE TABLE Attestation(
	id_attestation INT NOT NULL,							--номер аттестации	
	id_group  NVARCHAR(15) NOT NULL,						--код группы
	date_begin DATE NOT NULL,								--начало аттестации
	date_end DATE NOT NULL,									--конец аттестации
	stat BIT NOT NULL DEFAULT 0,							--статус аттестации( завершена 1, в процессе 0)

	CONSTRAINT PK_Attestation PRIMARY KEY (id_attestation ),
	CONSTRAINT FK_Attestation_To_GroupStudent FOREIGN KEY (id_group) REFERENCES  GroupStudent (id_group)
);

--24 Результаты аттестации
CREATE TABLE ResultAttestation(
	id_attestation INT NOT NULL,							--номер аттестации	
	record_book INT NOT NULL,								--номер зачётной книжки
	discipline INT NOT NULL,								--код дисциплины
	teacher INT NOT NULL,									--код преподавателя
	mark INT NOT NULL,										--код оценки
	hours_absent INT NOT NULL,								--часы пропуска
	form NCHAR(2) CHECK(form IN('ЛЗ','ПЗ','КП')),			--форма 
	
	CONSTRAINT PK_ResultAttestation PRIMARY KEY (id_attestation, record_book),
	CONSTRAINT FK_ResultAttestation_To_Attestation FOREIGN KEY (id_attestation) REFERENCES Attestation(id_attestation),
	CONSTRAINT FK_ResultAttestation_To_Student FOREIGN KEY (record_book) REFERENCES  Student (record_book),
	CONSTRAINT FK_ResultAttestation_To_Teacher FOREIGN KEY (teacher) REFERENCES Teacher (id_teach),
	CONSTRAINT FK_ResultAttestation_To_Discipline FOREIGN KEY (discipline) REFERENCES Discipline (id_disc),
	CONSTRAINT FK_ResultAttestation_To_Mark FOREIGN KEY (mark) REFERENCES  Mark (id_mark)
);

--25 Пропуски занятий сводная таблица
CREATE TABLE Absents(
	id_abs BIGINT IDENTITY(1,1),		     				--id
	record_book INT NOT NULL,								--номер зачётной книжки
	discipline INT NOT NULL,								--код дисциплины
	form NCHAR(2) CHECK(form IN('ЛК','ЛЗ','ПЗ','КП')),		--форма 
	date_abs DATE NOT NULL,									--дата
	reason BIT NOT NULL DEFAULT 0,							--причина пропуска(0-неуважительная, 1-уважительная)
	work_out BIT NOT NULL DEFAULT 0,						--отработано ли занятие(0-нет, 1-да)
	
	CONSTRAINT PK_Absenteeism PRIMARY KEY (id_abs),
	CONSTRAINT FK_Absenteeism_To_Student FOREIGN KEY (record_book) REFERENCES  Student (record_book),
	CONSTRAINT FK_Absenteeism_To_Discipline FOREIGN KEY (discipline) REFERENCES Discipline (id_disc)
);


--26 Мессенджеры
CREATE TABLE Messenger(
	record_book INT NOT NULL,								--номер зачётной книжки
	mess NVARCHAR(100) NOT NULL,							--мессенджер

	CONSTRAINT PK_Messenger PRIMARY KEY (record_book,mess),
	CONSTRAINT FK_Messenger_To_Student FOREIGN KEY (record_book) REFERENCES  Student (record_book)
);


--27 Справочник языков
CREATE TABLE Lenguage(
	short_name NVARCHAR(4) UNIQUE NOT NULL ,				--сокращение
	full_name NVARCHAR(100) UNIQUE NOT NULL,				--полное название
	
	CONSTRAINT PK_Lenguage PRIMARY KEY (short_name)
);

--28 Аттестат
CREATE TABLE CertificateSt(
	number INT NOT NULL,									--регистрационный номер аттестата
	record_book INT NOT NULL,								--номер зачётной книжки
	school NVARCHAR(50) NOT NULL,							--учереждение образования
	gpa DECIMAL(2,2) NOT NULL,								--средний балл
	belarusian_language INT CHECK(belarusian_language between 0 and 10),
	belarusian_literature INT CHECK(belarusian_literature between 0 and 10),
	russian_language INT CHECK(russian_language between 0 and 10),
	russian_literature INT CHECK(russian_literature between 0 and 10),
	foreign_language INT CHECK(foreign_language between 0 and 10),
	f_language  NVARCHAR(4),                                 --справочник языков
	mathematics INT CHECK(mathematics between 0 and 10),
	informatics INT CHECK(informatics between 0 and 10),
	history_of_belarus INT CHECK(history_of_belarus between 0 and 10),
	world_history INT CHECK(world_history between 0 and 10),
	social_science INT CHECK(social_science between 0 and 10),
	geography_subj INT CHECK(geography_subj between 0 and 10),
	biology INT CHECK(biology between 0 and 10),
	physics INT CHECK(physics between 0 and 10),
	astronomy INT CHECK(astronomy between 0 and 10),
	chemistry INT CHECK(chemistry between 0 and 10),
	physical_culture INT CHECK(physical_culture between 0 and 10),
	preliminary_medical INT CHECK(preliminary_medical between 0 and 10),
	gold_medal BIT NOT NULL DEFAULT 0,						--наличие золотой медали(0-нет, 1-есть)
	silver_medal BIT NOT NULL  DEFAULT 0,					--наличие серебряной медали(0-нет, 1-есть)

	CONSTRAINT PK_CertificateSt PRIMARY KEY (number),
	CONSTRAINT FK_CertificateSt_To_Student FOREIGN KEY (record_book) REFERENCES  Student (record_book),
	CONSTRAINT FK_CertificateSt_To_Lenguage FOREIGN KEY (f_language) REFERENCES  Lenguage (short_name)
);


--29 Список родителей студентов
CREATE TABLE Parents(
	id_parent INT IDENTITY(1, 1),							--id родителя
	record_book INT NOT NULL,								--номер зачётной книжки студента
	fio NVARCHAR(15) NOT NULL,					     		--фамилия имя отчество
	sex NCHAR(1) CHECK (sex in('Ж','М')),					--пол
	date_birth DATE NOT NULL,								--дата рождения
	address_perent NVARCHAR(150) NOT NULL,					--адрес
	messenger NVARCHAR(50) NOT NULL,						--телефон(ы)
	proffesion INT NOT NULL,								--номер профессии
	workplace NVARCHAR(150) NOT NULL,						--место работы
	post NVARCHAR(30) NOT NULL,								--должность

	CONSTRAINT PK_ParentsId PRIMARY KEY (id_parent),
	CONSTRAINT FK_Parents_To_Student FOREIGN KEY (record_book) REFERENCES  Student (record_book),
	CONSTRAINT FK_Parents_To_Profession FOREIGN KEY (proffesion) REFERENCES Profession (id_prof)
);

--30 Дополнительная инфа о студентах
CREATE TABLE AdditionalInfo(
	id_addit INT IDENTITY(1, 1),							--id доп инфы
	record_book INT NOT NULL,								--номер зачётной книжки студента
	hostel BIT  NOT NULL  DEFAULT 0,						--общежитие (0-нет, 1-есть)
	orphan_state_support  BIT  NOT NULL DEFAULT 0,			--сирота на гос обеспечении (0-нет, 1-есть)
	orphan_with_guardians BIT  NOT NULL DEFAULT 0,			--сирота с опекунами (0-нет, 1-есть)
	invalid BIT  NOT NULL DEFAULT 0,						--инвалид (0-нет, 1-есть)
	lost_parent BIT  NOT NULL DEFAULT 0,					--потерял последнего из родителей во время учёбы (0-нет, 1-есть)
	incomplete_family BIT  NOT NULL DEFAULT 0,				--неполная семья (0-нет, 1-есть)
	large_family  BIT  NOT NULL DEFAULT 0,				    --многодетная семья (0-нет, 1-есть)
	invalid_parent BIT  NOT NULL DEFAULT 0,				    --родитель инвалид (0-нет, 1-есть)
	victims_of_the_Chernobyl_accident BIT  NOT NULL DEFAULT 0,	    --пострадавший от аварии на ЧАЭС (0-нет, 1-есть)
	refugee_family BIT  NOT NULL DEFAULT 0,				    --семья беженцев (0-нет, 1-есть)
	on_internal_control BIT  NOT NULL DEFAULT 0,			--состоящие на внутреннем контроле (0-нет, 1-есть)
	underachieving_students BIT  NOT NULL DEFAULT 0,		--неуспевающий студент (0-нет, 1-есть)
	create_family BIT  NOT NULL DEFAULT 0,					--студент, создавший семью (0-нет, 1-есть)
	have_children BIT  NOT NULL DEFAULT 0,					--имеет детей (0-нет, 1-есть)
	serious_chronic_disease BIT  NOT NULL DEFAULT 0,		--тяжёлое хроническое заболевание (0-нет, 1-есть)
	activist BIT  NOT NULL DEFAULT 0,						--активист молодёжных общественных организаций (0-нет, 1-есть)

	CONSTRAINT PK_AdditionalInfoId PRIMARY KEY (id_addit),
	CONSTRAINT FK_AdditionalInfo_To_Student FOREIGN KEY (record_book) REFERENCES  Student (record_book)
);

--31 Отработки неаттестаций
CREATE TABLE ListNotAttestation(
	id_notattest INT IDENTITY(1, 1),					    --номер неаттестации
	record_book INT NOT NULL,								--номер зачётной книжки студента
	discipline INT NOT NULL,								--код дисциплины
	teacher INT NOT NULL,									--код преподавателя
	mark INT NOT NULL,										--код оценки
	date_start DATE NOT NULL,								--дата выдачи листа
	date_end DATE NOT NULL,									--дата сдачи листа

	CONSTRAINT PK_ListNotAttestationId PRIMARY KEY (id_notattest),
	CONSTRAINT FK_ListNotAttestation_To_Discipline FOREIGN KEY (discipline) REFERENCES Discipline (id_disc),
	CONSTRAINT FK_ListNotAttestation_To_Teacher FOREIGN KEY (teacher) REFERENCES Teacher (id_teach),
	CONSTRAINT FK_ListNotAttestation_To_Mark FOREIGN KEY (mark) REFERENCES  Mark (id_mark),
);

--32 Описания форм учебного процесса
CREATE TABLE FormProcess(
	id_form NCHAR(2) NOT NULL,								-- 'ОС','ЗЭ','ЗК','ВС','ЛЭ','ПР','ЛК'
	name NVARCHAR(30) UNIQUE NOT NULL,						-- название

	CONSTRAINT PK_FormProcessId PRIMARY KEY (id_form)
);

--33 График учебного процесса  
CREATE TABLE EducationalProcess(
	id INT IDENTITY(1, 1),					                --id 
	academic_year CHAR(9) NOT NULL,							--номер учебного года
	form NCHAR(2) NOT NULL,									--описание
	course INT CHECK(course  between 1 and 4),				--курс
	date_start DATE NOT NULL,								--дата начала
	date_end DATE NOT NULL,									--дата конца

	CONSTRAINT PK_EducationalProcessId PRIMARY KEY (id),
	CONSTRAINT FK_EducationalProcess_To_Discipline FOREIGN KEY (form) REFERENCES FormProcess(id_form)
);


--34 Пользователи
CREATE TABLE Users(
    id INT IDENTITY(1, 1),					                --id 
	user_login NVARCHAR(16) UNIQUE NOT NULL,				--логин
	user_password NVARCHAR(20) NOT NULL,					--пароль
    user_admin BIT NOT NULL DEFAULT 0,						--не студент?(0-студент, 1-админ)

	CONSTRAINT PK_UsersId PRIMARY KEY (id)
);


DROP TABLE Enrollment;
DROP TABLE Expelled;
DROP TABLE Mark;
DROP TABLE Attribute;
DROP TABLE Profession;
DROP TABLE Discipline;
DROP TABLE Pulpit;
DROP TABLE Teacher;
DROP TABLE ExamCredit;
DROP TABLE District;
DROP TABLE Region;
DROP TABLE TypeAddress;
DROP TABLE SubjectCT;
DROP TABLE Speciality;
DROP TABLE GroupStudent;
DROP TABLE Student;
DROP TABLE ResultCT;
DROP TABLE ListEnrollment;
DROP TABLE ListExpelled;
DROP TABLE AddressStudent;
DROP TABLE PlanDiscipline;
DROP TABLE ResultExam;
DROP TABLE Attestation;
DROP TABLE ResultAttestation;
DROP TABLE Absents;
DROP TABLE Messenger;
DROP TABLE Lenguage;
DROP TABLE CertificateSt;
DROP TABLE Parents;
DROP TABLE AdditionalInfo;
DROP TABLE ListNotAttestation;
DROP TABLE FormProcess;
DROP TABLE EducationalProcess;
DROP TABLE Users;
	
	