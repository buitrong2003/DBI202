create database VinaBookDB
use VinaBookDB

create table Account (
	accEmail varchar(50) primary key,
	accPassword varchar(100) not null,
	accFullname nvarchar(100) not null,
	accAddress nvarchar(50) not null,
	accPhoneNo varchar(12) not null,
	accBirthDate date not null,
	accGender varchar(10),
	accRole varchar(15) default 'User'
)
go
--Account Default
ALTER TABLE Account
ADD CONSTRAINT Default_Gender
DEFAULT 'Others' FOR accGender;
go

create table Author (
	auId int identity(1,1) primary key,
	auName nvarchar(50),
	auBirthDate date,
	auGender bit,
)
go
create table Publisher (
	pubId int identity(1,1) primary key,
	pubName nvarchar(50),
	pubAddress nvarchar(50),
	pubPhoneNo varchar(12)
	
)
go
create table Distributor (
	disId int identity(1,1) primary key,
	disName nvarchar(50),
	disAddress nvarchar(50),
	disPhoneNo varchar(12)
)
go
create table Book (
	bkId  varchar(10) primary key,
	bkTitle nvarchar(50) not null,
	bkType nvarchar(50) not null,
	bkPrice money not null,
	bkAvailableQuantity int,
	bkPublisherId int, -- reference to Publisher
	bkDistributorId int --reference to Distributor
)
go
--Book FK
alter table Book
add constraint FK_Book_Publisher 
foreign key (bkPublisherId) references Publisher(pubId) 
on delete cascade 
on update cascade
go
alter table Book
add constraint FK_Book_Distributor 
foreign key (bkDistributorId) references Distributor(disId) 
on delete cascade 
on update cascade
go
-- Book Default 
ALTER TABLE Book
ADD CONSTRAINT Default_bkPrice
DEFAULT 0 FOR bkPrice;
go
ALTER TABLE Book
ADD CONSTRAINT Default_bkAvailableQuantity
DEFAULT 0 FOR bkAvailableQuantity;
go

create table OwnedBy (
	owBookId varchar(10), --reference to Book
	owAuthorId int,		  --reference to Author
	owPublishedDate date not null,
)
go
--OwnedBy FK
alter table OwnedBy
add constraint FK_OwnedBy_Book 
foreign key (owBookId) references Book(bkId) 
on delete cascade 
on update cascade
go
alter table OwnedBy
add constraint FK_OwnedBy_Author 
foreign key (owAuthorId) references Author(auId) 
on delete cascade 
on update cascade
go
-- OwnedBy Unique
create unique nonclustered index UQ_OwnedBy 
on OwnedBy(owBookId,owAuthorId)
go

create table BookDetail (
	bkdBookId varchar(10),
	bkdPageNumbers int,
	bkdLicense nvarchar(50),
	bkdLanguage nvarchar(20),
	bkdFormat nvarchar(20),
	bkdSize varchar(10),
	bkdWeight varchar(10)
)
go
--BookDetail FK
alter table BookDetail
add constraint FK_BookDetail_Book 
foreign key (bkdBookId) references Book(bkId) 
on delete cascade 
on update cascade

go
create table Orders (
	ordId int identity(1,1) primary key,
	ordDate date,
	ordTotal money,
	ordVoucher int,
	ordStatus varchar(15) default 'processing',
	ordAccountEmail varchar(50)
)
go
--Orders FK
alter table Orders
add constraint FK_Orders_Account 
foreign key (ordAccountEmail) references Account(accEmail) 
on delete cascade 
on update cascade
go

create table OrderDetail (
	ordtId int identity(1,1) primary key,
	ordtQuantity int,
	ordtPrice money,
	ordtBookId  varchar(10),
	ordtOrderId int, 
)
go
--OrderDetail FK
alter table OrderDetail
add constraint FK_OrderDetail_Orders 
foreign key (ordtOrderId) references Orders(ordId) 
on delete cascade 
on update cascade
go
alter table OrderDetail
add constraint FK_OrderDetail_Book 
foreign key (ordtBookId) references Book(bkId) 
on delete cascade 
on update cascade
go
--unique bookid and orderid
create unique nonclustered index UQ_OrderDetail 
on OrderDetail(ordtBookId,ordtOrderId)
go
create table Feedback (
	fbId int identity(1,1) primary key,
	fbBookId varchar(10),
	fbAccountEmail varchar(50),
	comment nvarchar(200),
	rate int
)
go
alter table Feedback
add constraint FK_Feedback_Book 
foreign key (fbBookId) references Book(bkId) 
on delete cascade 
on update cascade
go
alter table Feedback
add constraint FK_Feedback_Account
foreign key (fbAccountEmail) references Account(accEmail) 
on delete cascade 
on update cascade

create table CustomerSupport (
	csOrderId int,
	csPhoneNo varchar(12)
)
go
alter table CustomerSupport
add constraint FK_CustomerSupport_Orders
foreign key (csOrderId) references Orders(ordId) 
on delete cascade 
on update cascade

create table PreOrder (
	poCustomerName nvarchar(50),
	poCustomerEmail varchar(50),
	poBookType nvarchar(40)
)
go
alter table PreOrder
add constraint FK_PreOrder_Account
foreign key (poCustomerEmail) references Account(accEmail) 
on delete cascade 
on update cascade

--INSERT VALUES
--Account
INSERT INTO Account(accEmail ,accPassword,accFullname,accAddress,accPhoneNo,accBirthDate,accGender,accRole)
VALUES('abcd@gmail.com', '123456',N'abcd', N'5, quận 9, Thành Phố Hồ Chí Minh', '09120312312', '2002-11-11', 'Male', 'User')
go
INSERT INTO Account(accEmail ,accPassword,accFullname,accAddress,accPhoneNo,accBirthDate,accGender,accRole)
VALUES('abcde@gmail.com', '123456',N'abcde', N'6, quận 11, Thành Phố Hồ Chí Minh', '09120312777', '2002-07-13', 'Male', 'User')
go
INSERT INTO Account(accEmail ,accPassword,accFullname,accAddress,accPhoneNo,accBirthDate,accGender,accRole)
VALUES('abcdef@gmail.com', '123456',N'abcdef', N'5, Hà Nội', '09120312313', '2004-11-27', 'Male', 'User')

--Author
INSERT INTO Author(auName,auBirthDate,auGender)
VALUES(N'Trần Ngọc Dũng', '1996-02-27',1)
go
INSERT INTO Author(auName,auBirthDate,auGender)
VALUES(N'Camille Paris', '1856-09-10',1)
go
INSERT INTO Author(auName,auBirthDate,auGender)
VALUES(N'Nguyễn Nhật Ánh', '1955 -05-07',1)
go
INSERT INTO Author(auName,auBirthDate,auGender)
VALUES(N'Trịnh Khắc Mạnh', '1948-10-3',1)
--Publisher

INSERT INTO Publisher(pubName,pubAddress,pubPhoneNo)
VALUES(N'Nxb Khoa học xã hội', N'57 Đ. Sương Nguyệt Anh, Thành phố Hồ Chí Minh',' 02838394948')
go
INSERT INTO Publisher(pubName,pubAddress,pubPhoneNo)
VALUES(N'NXB Hồng Đức', N'65 Tràng Thi, Hàng Bông, Hoàn Kiếm, Hà Nội','02439260024')
go
INSERT INTO Publisher(pubName,pubAddress,pubPhoneNo)
VALUES(N'Nxb Trẻ', N'161B Lý Chính Thắng, Quận 3, Thành phố Hồ Chí Minh',' 02839316289')
go
INSERT INTO Publisher(pubName,pubAddress,pubPhoneNo)
VALUES(N'Nxb Đại Học Quốc Gia Hà Nội', N'16 P. Hàng Chuối, Hai Bà Trưng, Hà Nội',' 02439714896')

--Distributor
INSERT INTO Distributor(disName,disAddress,disPhoneNo)
VALUES(N'Thư Books', N'640 Hoàng Hoa Thám, Tây Hồ, Hà Nội',' 0973305570')
go
INSERT INTO Distributor(disName,disAddress,disPhoneNo)
VALUES(N'Nxb Trẻ', N'161B Lý Chính Thắng, Quận 3, Thành phố Hồ Chí Minh',' 02839316289')

--Book
INSERT INTO Book (bkId,bkTitle,bkType,bkPrice,bkAvailableQuantity,bkPublisherId,bkDistributorId)
VALUES ('BK01',N'Quan Hệ Anh – Việt Nam (1614-1705)','History',254.000,100,1,1)
go
INSERT INTO Book (bkId,bkTitle,bkType,bkPrice,bkAvailableQuantity,bkPublisherId,bkDistributorId)
VALUES ('BK02',N'Du Ký Trung Kỳ Theo Đường Cái Quan','Documentory',200.000,100,2,1)
go
INSERT INTO Book (bkId,bkTitle,bkType,bkPrice,bkAvailableQuantity,bkPublisherId,bkDistributorId)
VALUES ('BK03',N'Ra Bờ Suối Ngắm Hoa Kèn Hồng','Literary',225.000,100,3,2)
go
INSERT INTO Book (bkId,bkTitle,bkType,bkPrice,bkAvailableQuantity,bkPublisherId,bkDistributorId)
VALUES ('BK04',N'Bảy Bước Tới Mùa Hè','Literary',102.000,100,3,2)
go
INSERT INTO Book (bkId,bkTitle,bkType,bkPrice,bkAvailableQuantity,bkPublisherId,bkDistributorId)
VALUES ('BK05',N'Văn Miếu Việt Nam Khảo Cứu','Culture And Art',304.000,100,4,2)
go
INSERT INTO Book (bkId,bkTitle,bkType,bkPrice,bkAvailableQuantity,bkPublisherId,bkDistributorId)
VALUES ('BK06',N'Chợ Truyền Thống Việt Nam Qua Tư Liệu Văn Bia','History and Geo',368.000,100,4,1)

--BookDetail
INSERT INTO BookDetail(bkdBookId , bkdPageNumbers , bkdLicense , bkdLanguage, bkdFormat, bkdSize, bkdWeight)
VALUES ('BK01',340,N'256/QĐ-NXB KHXH cấp ngày 16/11/2021','VietNamese',N'Bìa cứng','16 x 24 cm','1000 gam')
go
INSERT INTO BookDetail(bkdBookId , bkdPageNumbers , bkdLicense , bkdLanguage, bkdFormat, bkdSize, bkdWeight)
VALUES ('BK02',399,N'94/QĐ-NXBĐN cấp ngày 26/04/2021','VietNamese',N'Bìa mềm',' 22 x 15cm','600.00 gam')
go
INSERT INTO BookDetail(bkdBookId , bkdPageNumbers , bkdLicense , bkdLanguage, bkdFormat, bkdSize, bkdWeight)
VALUES ('BK03',336,N'256/QĐ-NXB KHXH cấp ngày 16/11/2021','VietNamese',N'Bìa mềm','20 x 13 cm','450.00 gam')
go
INSERT INTO BookDetail(bkdBookId , bkdPageNumbers , bkdLicense , bkdLanguage, bkdFormat, bkdSize, bkdWeight)
VALUES ('BK04',288,N' 256/QĐ-NXB KHXH cấp ngày 16/11/2021','VietNamese',N'Bìa mềm','20 x 13 cm','500.00 gam')

--Feedback
INSERT INTO Feedback(fbBookId, fbAccountEmail, comment, rate)
VALUES ('BK04', 'abcd@gmail.com', N'good!', 4)
go
INSERT INTO Feedback(fbBookId, fbAccountEmail, comment, rate)
VALUES ('BK04', 'abcde@gmail.com', N'good!Nice', 3)
go
INSERT INTO Feedback(fbBookId, fbAccountEmail, comment, rate)
VALUES ('BK04', 'abcdef@gmail.com', N'great!', 4)
go
INSERT INTO Feedback(fbBookId, fbAccountEmail, comment, rate)
VALUES ('BK03', 'abcdef@gmail.com', N'nice!', 4)
go
INSERT INTO Feedback(fbBookId, fbAccountEmail, comment, rate)
VALUES ('BK03', 'abcde@gmail.com', N'nice!!!!', 3)
go
INSERT INTO Feedback(fbBookId, fbAccountEmail, comment, rate)
VALUES ('BK01', 'abcd@gmail.com', N'gud', 4)

--Orders
INSERT INTO Orders(ordDate ,ordTotal ,ordVoucher ,ordAccountEmail)
VALUES ('2022-07-20', 1000.000, 20, 'abcd@gmail.com')
go
INSERT INTO Orders(ordDate ,ordTotal ,ordVoucher ,ordAccountEmail)
VALUES ('2022-07-20', 1200.000, 30, 'abcde@gmail.com')
go
INSERT INTO Orders(ordDate ,ordTotal ,ordVoucher ,ordAccountEmail)
VALUES ('2022-07-20', 1300.000, 20, 'abcdef@gmail.com')

--OrderDetail
INSERT INTO OrderDetail(ordtQuantity, ordtPrice, ordtBookId, ordtOrderId)
VALUES (5, 5*254.000, 'BK01', 1)
go
INSERT INTO OrderDetail(ordtQuantity, ordtPrice, ordtBookId, ordtOrderId)
VALUES (2, 2*200.000, 'BK02', 1)
go
INSERT INTO OrderDetail(ordtQuantity, ordtPrice, ordtBookId, ordtOrderId)
VALUES (3, 3*225.000, 'BK03', 1)

INSERT INTO OrderDetail(ordtQuantity, ordtPrice, ordtBookId, ordtOrderId)
VALUES (5, 5*368.000, 'BK06', 2)
go
INSERT INTO OrderDetail(ordtQuantity, ordtPrice, ordtBookId, ordtOrderId)
VALUES (2, 2*102.000, 'BK04', 2)
go
INSERT INTO OrderDetail(ordtQuantity, ordtPrice, ordtBookId, ordtOrderId)
VALUES (3, 3*225.000, 'BK03', 2)
go

INSERT INTO OrderDetail(ordtQuantity, ordtPrice, ordtBookId, ordtOrderId)
VALUES (6, 6*225.000, 'BK03', 3)
------------------------------
select * from Author
select * from Publisher
select * from Distributor
select * from Book
select * from Account
select * from Feedback
select * from Orders
select * from OrderDetail
------------------------------


--1. Show pubId, pubName, pubAddress and pubPhoneNo with address in HCM
select pubId, pubName, pubAddress, pubPhoneNo 
from Publisher 
where pubAddress like N'%Thành phố Hồ Chí Minh'

--2. Show bkId, bkTitle, bkPrice, bkAvailableQuantity with price >= 150.000d and order by price desc
select bkId, bkTitle, bkPrice, bkAvailableQuantity 
from Book 
where bkPrice >= 150.000
order by bkPrice desc

--3. Show auName, auBirthDate, auGender, BooksNumber(owned books) of each Author
--* run proc_Add_Author_Owned_Books first
select a.auName, a.auBirthDate, a.auGender,count(owBookId) as BooksNumber
from OwnedBy ob
inner join Author a on a.auId = ob.owAuthorId
group by ob.owAuthorId, a.auName, a.auBirthDate, a.auGender

--4 Update 5 star rate of book has most order
update Feedback
set rate = 5
where fbBookId = (select ordtBookId 
					from OrderDetail od
					inner join Feedback f on f.fbBookId = od.ordtBookId
					group by ordtBookId
					having count(ordtId) > all(select count(ordtId) 
											from OrderDetail
											group by ordtBookId))
select * from OrderDetail
select * from Feedback
--Stored Procedure - function - reuse
--1.Create Stored Proc To Update Book Infomation
CREATE PROCEDURE proc_Update_Book_Infomation(
	@bkId varchar(10),
	@bkTitle nvarchar(50),
	@bkType nvarchar(50),
	@bkPrice money,
	@bkAvailableQuantity int)
AS
	Update Book
	Set bkTitle = @bkTitle, 
		bkType = @bkType,
		bkPrice = @bkPrice,
		bkAvailableQuantity=@bkAvailableQuantity
	Where bkId = @bkId;
go

INSERT INTO Book (bkId,bkTitle,bkType,bkPrice,bkAvailableQuantity,bkPublisherId,bkDistributorId)
VALUES ('Test_01',N'Update_Book_Infomation','History',254.000,0,2,1)
go
exec proc_Update_Book_Infomation 'Test_01',N'Test Update_Book_Infomation Success', 'History', 299.000, 100
go 
select * from Book

--2.Create Stored Proc To Delete Book Have Quantity = 0
CREATE PROCEDURE proc_Delete_Book_Not_Available
AS
	Delete From Book
	Where bkAvailableQuantity=0
go
INSERT INTO Book (bkId,bkTitle,bkType,bkPrice,bkAvailableQuantity,bkPublisherId,bkDistributorId)
VALUES ('Test_02',N'Test Delete_Book_Not_Available','History',254.000,0,2,1)
go
exec proc_Delete_Book_Not_Available
go 
select * from Book

--3.Create Stored Proc To Add Books Owned By Author 
CREATE PROCEDURE proc_Add_Author_Owned_Books(
	@owBookId varchar(10), 
	@owAuthorId int,		 
	@owPublishedDate date
)
AS
	Insert Into OwnedBy (owBookId, owAuthorId, owPublishedDate)
	Values (@owBookId,@owAuthorId,@owPublishedDate)
go
exec proc_Add_Author_Owned_Books 'BK01', 1, '2021-12-12'
go
exec proc_Add_Author_Owned_Books 'BK02', 2, '2021-01-01'
go 
exec proc_Add_Author_Owned_Books 'BK03', 3, '2022-05-24'
go 
exec proc_Add_Author_Owned_Books 'BK04', 3, '2021-06-25'
go
exec proc_Add_Author_Owned_Books 'BK05', 4, '2021-07-01'
go 
exec proc_Add_Author_Owned_Books 'BK06', 4, '2015-04-06'
go
select * from OwnedBy

--Trigger	
-- 1. create trigger reduce available quantity in storage when order detail inserted
CREATE TRIGGER tr_Book_Quantity_Update ON OrderDetail
AFTER INSERT AS
BEGIN
	DECLARE @OrderQuantity int, @AvailableQuantity int, @check int
	select @OrderQuantity=ordtQuantity,  @AvailableQuantity = bkAvailableQuantity
	from inserted
	join Book on Book.bkId = inserted.ordtBookId

	Set @check = @AvailableQuantity - @OrderQuantity
	IF (@check<0)
	BEGIN
		RAISERROR('Order Quantity > Available Quantity',16,1)
		ROLLBACK TRANSACTION
	END
	IF(@check>=0)
	BEGIN
		Update Book 
		Set bkAvailableQuantity = bkAvailableQuantity - (select ordtQuantity 
															from inserted 
															where ordtBookId = Book.bkId)
		From Book
		join inserted on Book.bkId = inserted.ordtBookId
	END
END
go
Insert into OrderDetail(ordtQuantity, ordtPrice, ordtBookId, ordtOrderId)
values (101, 254.000, 'BK02', 3)
go
Insert into OrderDetail(ordtQuantity, ordtPrice, ordtBookId, ordtOrderId)
values (10, 254.000, 'BK04', 1)
go
select * from Book

-- 2. create trigger increase available quantity in storage when cancel order
CREATE TRIGGER tr_Book_Quantity_Update_Increase ON OrderDetail
AFTER DELETE AS
BEGIN
	Update Book 
	Set bkAvailableQuantity = bkAvailableQuantity + (select ordtQuantity 
														from deleted 
														where ordtBookId = Book.bkId)
	From Book
	join deleted on Book.bkId = deleted.ordtBookId
END
go

delete from OrderDetail where ordtId = 9
select * from Book
select * from OrderDetail


