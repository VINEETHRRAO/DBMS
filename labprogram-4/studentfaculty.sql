create database studentfaculty;
use studentfaculty;

create table student(snum int , sname varchar(20) , major varchar(10) , lvl varchar(5) , age int , primary key(snum));
create table faculty(fid int , fname varchar(20) , deptid int , primary key(fid));
create table class(cname varchar(10) , meets_at timestamp , room varchar(10) , fid int , primary key(cname) , foreign key(fid) references faculty(fid));
create table enrolled(snum int , cname varchar(10) , foreign key(snum) references student(snum) , foreign key(cname) references class(cname));

insert into student values(1, 'John', 'CS', 'Sr', 19);
insert into student values(2, 'Smith', 'CS', 'Jr', 20);
insert into student values(3 , 'Jacob', 'CV', 'Sr', 20);
insert into student values(4, 'Tom ', 'CS', 'Jr', 20);
insert into student values(5, 'Rahul', 'CS', 'Jr', 20);
insert into student values(6, 'Rita', 'CS', 'Sr', 21);

insert into faculty values(11, 'Harish', 1000);
insert into faculty values(12, 'MV', 1000);
insert into faculty values(13 , 'Mira', 1001);
insert into faculty values(14, 'Shiva', 1002);
insert into faculty values(15, 'Nupur', 1000);

insert into class values('class1', '12/11/15 10:15:16', 'R1', 14);
insert into class values('class10', '12/11/15 10:15:16', 'R128', 14);
insert into class values('class2', '12/11/15 10:15:20', 'R2', 12);
insert into class values('class3', '12/11/15 10:15:25', 'R3', 11);
insert into class values('class4', '12/11/15 20:15:20', 'R4', 14);
insert into class values('class5', '12/11/15 20:15:20', 'R3', 15);
insert into class values('class6', '12/11/15 13:20:20', 'R2', 14);
insert into class values('class7', '12/11/15 10:10:10', 'R3', 14);

insert into enrolled values(1, 'class1');
insert into enrolled values(2, 'class1');
insert into enrolled values(3, 'class3');
insert into enrolled values(4, 'class3');
insert into enrolled values(5, 'class4');
insert into enrolled values(1, 'class5');
insert into enrolled values(2, 'class5');
insert into enrolled values(3, 'class5');
insert into enrolled values(4, 'class5');
insert into enrolled values(5, 'class5');

select * from student;
select * from faculty;
select * from class;
select * from enrolled;

select s.sname from student s , faculty f , class c , enrolled e where s.snum = e.snum and f.fid = c.fid and e.cname = c.cname and f.fname = 'Harish' and s.lvl = 'Jr';

select c.cname from class c where room='R128' or c.cname in (select e.cname from enrolled e group by e.cname having count(e.cname)>=5);

select distinct s.sname from student s where s.snum in (select e1.snum from enrolled e1 , enrolled e2 , class c1 , class c2 where e1.snum = e2.snum and e1.cname != e2.cname and e1.cname = c1.cname
and e2.cname = c2.cname and c1.meets_at = c2.meets_at);

select distinct f.fname from faculty f where not exists((select c.room from class c where c.room not in (select c1.room from class c1 where c1.fid = f.fid)));

select distinct f.fname from faculty f left join class c on f.fid = c.fid where 5 > (select count(*) from enrolled e where e.cname = c.cname);

select s.sname from student s where s.snum not in (select e.snum from enrolled e);

select s.age , s.lvl from student s group by s.age , s.lvl having s.lvl in ( select s1.lvl from student s1 where s1.age = s.age group by s1.lvl , s1.age having count(*) >= all (select count(*) from
student s2 where s1.age = s2.age group by s2.age , s2.lvl));