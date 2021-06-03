create database aeroplane;
use aeroplane;

create table flights(flno int primary key , from_ varchar(30) , to_ varchar(30) , distance int , departs timestamp , arrives timestamp , price int);
create table aircraft(aid int primary key , aname varchar(30) , cruisingrange int);
create table employee(eid int primary key , ename varchar(30) , salary int);
create table certified(eid int, aid int , primary key(eid , aid) , foreign key(eid) references employee(eid) , foreign key(aid) references aircraft(aid));

insert into flights values(101,'Bangalore','Delhi',2500,TIMESTAMP '2005-05-13 07:15:31',TIMESTAMP '2005-05-13 17:15:31',5000);
insert into flights values(102,'Bangalore','Lucknow',3000,TIMESTAMP '2005-05-13 07:15:31',TIMESTAMP '2005-05-13 11:15:31',6000);
insert into flights values(103,'Lucknow','Delhi',500,TIMESTAMP '2005-05-13 12:15:31',TIMESTAMP ' 2005-05-13 17:15:31',3000);
insert into flights values(107,'Bangalore','Frankfurt',8000,TIMESTAMP '2005-05-13  07:15:31',TIMESTAMP '2005-05-13 22:15:31',60000);
insert into flights values(104,'Bangalore','Frankfurt',8500,TIMESTAMP '2005-05-13 07:15:31',TIMESTAMP '2005-05-13 23:15:31',75000);
insert into flights values(105,'Kolkata','Delhi',3400,TIMESTAMP '2005-05-13 07:15:31',TIMESTAMP  '2005-05-13 09:15:31',7000);

insert into aircraft values(101 , '747' , 3000);
insert into aircraft values(102,'Boeing',900);
insert into aircraft values(103,'647',800);
insert into aircraft values(104,'Dreamliner',10000);
insert into aircraft values(105,'Boeing',3500);
insert into aircraft values(106,'707',1500);
insert into aircraft values(107,'Dream', 120000);

insert into employee values(701,'A',50000);
insert into employee values(702,'B',100000);
insert into employee values(703,'C',150000);
insert into employee values(704,'D',90000);
insert into employee values(705,'E',40000);
insert into employee values(706,'F',60000);
insert into employee values(707,'G',90000);

insert into certified values(701,101);
insert into certified values(701,102);
insert into certified values(701,106);
insert into certified values(701,105);
insert into certified values(702,104);
insert into certified values(703,104);
insert into certified values(704,104);
insert into certified values(702,107);
insert into certified values(703,107);
insert into certified values(704,107);
insert into certified values(702,101);
insert into certified values(703,105);
insert into certified values(704,105);
insert into certified values(705,103);

select * from aircraft;
select * from flights;
select * from employee;
select * from certified;

select distinct a.aname from aircraft a , employee e , certified c where a.aid = c.aid and e.eid = c.eid and e.salary >= 80000;

select c.eid , max(a.cruisingrange) from certified c , aircraft a where a.aid = c.aid group by c.eid having count(*) > 3;

select e.ename from employee e where e.salary < (select min(price) from flights where from_ = 'Bangalore' and to_ = 'Frankfurt');

select a.aname , avg(e.salary) from aircraft a , employee e , certified c where a.aid = c.aid and e.eid = c.eid and a.cruisingrange > 1000 group by a.aname;

select distinct e.ename from employee e , aircraft a , certified c where a.aid = c.aid and e.eid = c.eid and a.aname = 'Boeing';

select a.aid from aircraft a where a.cruisingrange >= (select min(distance) from flights where from_ = 'Bangalore' and to_ = 'Frankfurt');

select F.departs from Flights F where F.flno IN ( ( select F0.flno from Flights F0 where F0.from_ = 'Bangalore' and F0.to_ = 'Delhi' and extract(hour from F0.arrives) < 18 )
union ( select F0.flno from Flights F0, Flights F1 where F0.from_ = 'Bangalore' AND F0.to_ <> 'Delhi' and F0.to_ = F1.from_ AND F1.to_ = 'Delhi' and F1.departs > F0.arrives and extract(hour from F1.arrives) < 18)
union ( select F0.flno from Flights F0, Flights F1, Flights F2 where F0.from_ = 'Bangalore' and F0.to_ = F1.from_ and F1.to_ = F2.from_ and F2.to_ = 'Delhi' and F0.to_ <> 'Delhi' and F1.to_ <> 'Delhi'
and F1.departs > F0.arrives and F2.departs > F1.arrives and extract(hour from F2.arrives) < 18));

select e.ename , e.salary from employee e where e.salary > (select avg(distinct e1.salary) from employee e1 , certified c where e1.eid = c.eid) and 
e.eid not in (select distinct eid from certified); 