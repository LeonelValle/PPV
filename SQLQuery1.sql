create database PPVdb

use PPVdb

create table level(id_level int primary key identity(1,1), level varchar(100))

create table users(id_user int  primary key identity(1,1), name varchar(255), email varchar(100), username varchar(50), password varchar(50) ,id int, id_level int,
foreign key(id_level) references level(id_level))

create table PPV(id_ppv int primary key identity(1,1), av_price money, new_price money, vendorID int, vendor varchar(100), buyer int, clientID int, 
client varchar(255), reason varchar(100), times varchar(50), OtherChange bit, elaborate varchar(255), leadtime varchar(10), mfgr_name varchar(100),
mfgr_pn varchar(100), explanation varchar(255), change_unit money, change_unit_perc float ,current_total money, new_total money, total_increase money, 
first_auth int, last_auth int,
foreign key(buyer) references users(id_user),
foreign key(first_auth) references users(id_user),
foreign key(last_auth) references users(id_user))

select * from PPV

GO
create trigger ppv_total
on PPV
for insert, update
as begin
declare @current_cost money
declare @new_cost money
declare @id int
declare @qty int
declare @current_total money
declare @new_total money
declare @change money
declare @total_increase money
declare @change_perc float

set @current_cost = (select av_price from inserted)
set @new_cost = (select new_price from inserted)
set @id = (select id_ppv from inserted)
set @qty = (select qty from inserted)
--total result
set @current_total = (@current_cost * @qty)
set @new_total = (@new_cost * @qty)
set @change = (+(@new_cost) - (@current_cost))
set @change_perc = (@change / @current_total)
set @total_increase = (@current_total - @new_total)

update PPV set current_total = @current_total, new_total = @new_total, change_unit = @change, change_unit_perc = @change_perc, total_increase = @total_increase where id_ppv = @id

END


