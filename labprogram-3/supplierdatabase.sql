create database supplierdatabase;
use supplierdatabase;

create table supplier(sid int , sname varchar(20) , address varchar(40) , primary key(sid));
create table parts(pid int , pname varchar(30) , color varchar(15) , primary key(pid));
create table catalog(sid int , pid int , cost real , foreign key(sid) references supplier(sid) , foreign key(pid) references parts(pid));

insert into supplier values(10001 , 'Acme Widget' , 'Bangalore');
insert into supplier values(10002 , 'Johns' , 'Kolkata');
insert into supplier values(10003 , 'Vimal' , 'Mumbai');
insert into supplier values(10004 , 'Reliance' , 'Delhi');

insert into parts values(20001 , 'Book' , 'Red');
insert into parts values(20002 , 'Pen' , 'Red');
insert into parts values(20003 , 'Pencil' , 'Green');
insert into parts values(20004 , 'Mobile' , 'Red');
insert into parts values(20005 , 'Charger' , 'Black');

insert into catalog values(10001,20001,10);
insert into catalog values(10001,20002,10);
insert into catalog values(10001,20003,30);
insert into catalog values(10001,20004,10);
insert into catalog values(10001,20005,10);
insert into catalog values(10002,20001,10);
insert into catalog values(10002,20002,20);
insert into catalog values(10003,20003,30);
insert into catalog values(10004,20003,40);

select * from supplier;
select * from parts;
select * from catalog;

select pname from parts where parts.pid in (select pid from catalog);

select sname from supplier s where ((select count(*) from catalog where catalog.sid = s.sid) = (select count(*) from parts));

select s.sname from supplier s where exists ((select p.pid from parts p where p.color = 'Red' and p.pid in (select c.pid from catalog c,parts p where c.sid=s.sid and c.pid=p.pid and p.color='Red')));

select p.pname from parts p, supplier s where s.sname = 'Acme Widget' and p.pname not in (select p1.pname from parts p1 , supplier s1 , catalog c where s1.sname!='Acme Widget' and p1.pid=c.pid and s1.sid=c.sid);

select c.sid from catalog c where c.cost > (select avg(cost) from catalog where pid = c.pid);

select p.pid , s.sname from parts p , supplier s , catalog c where p.pid = c.pid and s.sid = c.sid and c.cost = (select max(cost) from catalog where pid = p.pid);

select distinct s.sid from supplier s , parts p , catalog c where s.sid = c.sid and p.pid = c.pid and p.color = 'Red' and s.sid not in (select distinct s1.sid from supplier s1 , parts p1 , catalog c1 where s1.sid = c1.sid and p1.pid = c1.pid and p1.color != 'Red');

commit;