create database task1_11procedur

use task1_11procedur

create table Users(
id int primary key identity,
name varchar(25)not null,
surname varchar (30) default 'XXXX' ,
username varchar(20) not null unique,
password char(15) not null,
gender varchar(10) )

create table Artist (
id int primary key identity,
name varchar(25) not null,
surname varchar (30) default 'XXXX' ,
birthday date ,
gender varchar(10) )

create table Categories (
id int primary key identity,
name varchar(25)not null )

create table Music (
id int primary key identity,
name varchar(25)not null,
duration int check(duration>0),
categoryId int references categories(id))

create table Playlist (
musicId int references music(id),
userId int references users(id) )

create table ArtistMusic (
artistId int references artist(id),
musicId int references music(id) )


insert users (name,surname,username,password,gender) values
('Samama','Quliyeva','cepissmom','cepis345','female' ),--cepis samamanin pisiyidi
('Sebuhi','Camalzade','gym4ever','protein888','male'),
('Zulfiyya','Qurbanova','catlover','masya558','female')--masya menim pisiyimdi


insert artist (name,surname,birthday,gender) values 
('Lana','Del Rey','21.06.1997','female'),
('Sevda','Elekberzade','04.07.1977','female'),
('Miri','Yusif','27.10.1977','male'),
('Elsad','Xose','01.01.1975','male')

insert categories(name) values 
('Alternative-Indi'),
('Pop'),
('Hip-Hop')

insert music (name,duration,categoryId) values 
('Summertime Sadness ' , 266,1),
('Ag Teyyare ' ,240,3),
('Bir sevgim var',234,2),
('Gel danis',292,2)

insert ArtistMusic (artistId,musicId) values
(1,1),(2,3),(3,2),(4,3),(4,4)

 insert into Playlist values
 (3,3),(3,2),(1,3),(2,3),(2,1),(2,2),(4,1)


create view AppleMusic
as
select m.name as MahniAdi, m.Duration as MahnininDavamliligi, c.Name as Kategoriya, CONCAT(a.Name,' ',a.Surname) as Artist
from music as m


join categories as c 
on m.categoryId = c.Id

join ArtistMusic as am 
on m.Id = am.musicId

join artist as a 
on am.artistId = a.Id

select *from AppleMusic

 create procedure usp_CreateMusics
 @MusicName varchar(30),
 @MusicDuration int,
 @CategoryId int
 as
 insert into Music values 
 (@MusicName,@MusicDuration,@CategoryId)

 exec usp_CreateMusics 'Count on me',280,1
 select*from music

 create procedure usp_CreateUsers
 @name  varchar(25),
 @surname varchar (30),
 @username varchar(20),
 @password varchar(40),
 @gender varchar(10)
 as
 insert into Users values(@name,@surname,@username,@password,@gender)

 exec usp_CreateUsers 'ulviyya','qurbanova','ulvgr','05102018','female' 
 select *from users

 create procedure usp_CreateCategory
 @name varchar (25)
 as
 insert into Categories values (@name)

 exec usp_CreateCategory 'Rock and Roll'
 select *from  Categories
 --muellim :,( , artistin name in ne not null vermisem deye view da cixartmir ona gore bir bir selectleri yazmisam

 --bir dene de procedur ona gore yaradiram 

 create procedure usp_CreateArtist
 @name varchar (25),
 @surname varchar(30),
 @birthday date,
 @gender varchar(10)
 as
 insert artist values(@name,@surname,@birthday,@gender) 

 exec usp_CreateArtist 'Bruno','Mars','01.12.1989','male'

 select *from Artist

 select *from AppleMusic --yegin ki, men neyise sehv basa dusmusem burda ,joinde artsitmusic table ile elaqelenir men burda onu eleye bilmirem

 alter table Music add IsDeleted bit default 0

 create trigger delete_music
on Music
instead of delete
as
declare @result bit
declare @id int
select @result=IsDeleted,@id=deleted.Id from deleted
if(@result=0)
 begin
 update Music set IsDeleted=1 where Id=@id
 end
else
begin
 delete from Music where Id=@id
 end

delete from music where id=1



create view ShowUser
as
select u.Id, u.Username, m.Name as SongName, a.Name as Singer
from Playlist p
join Users u on p.UserId = u.Id
join Music m on p.MusicId = m.Id
join ArtistMusic ma on ma.MusicId = m.Id
join Artist a on ma.ArtistId = a.Id

create function GetUsersListenedArtists(@userId int)
returns int
begin
declare @result int
select @result = COUNT(DISTINCT Singer) from ShowUser
where Id = @userId
return @result
end

 select dbo.GetUsersListenedArtists(1) as [count]