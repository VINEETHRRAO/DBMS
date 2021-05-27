create database bank;
use bank;

create table branch(branch_name varchar(30) , branch_city varchar(30) , assets real , primary key(branch_name));
create table bankaccount(accno int , branch_name varchar(30) , balance real , primary key(accno) , foreign key(branch_name) references branch(branch_name));
create table bankcustomer(customer_name varchar(30) , customer_street varchar(30) , customer_city varchar(30) , primary key(customer_name));
create table depositor(customer_name varchar(30) , accno int , primary key(customer_name,accno) , foreign key(customer_name) references bankcustomer(customer_name) , foreign key(accno) references bankaccount(accno));
create table loan(loan_number int , branch_name varchar(30) , amount real , primary key(loan_number) , foreign key(branch_name) references branch(branch_name));

show tables;

insert into branch values('SBI_Chamrajpet','Bangalore',50000);
insert into branch values('SBI_ResidencyRoad','Bangalore',10000);
insert into branch values('SBI_ShivajiRoad','Bombay',20000);
insert into branch values('SBI_ParliamentRoad','Delhi',10000);
insert into branch values('SBI_Jantarmantar','Delhi',20000);
select * from branch;

insert into bankaccount values(1,'SBI_Chamrajpet',2000);
insert into bankaccount values(2,'SBI_ResidencyRoad',5000);
insert into bankaccount values(3,'SBI_ShivajiRoad',6000);
insert into bankaccount values(4,'SBI_ParliamentRoad',9000);
insert into bankaccount values(5,'SBI_Jantarmantar',8000);
insert into bankaccount values(6,'SBI_ShivajiRoad',4000);
insert into bankaccount values(7,'SBI_ResidencyRoad',4000);
insert into bankaccount values(8,'SBI_ParliamentRoad',3000);
insert into bankaccount values(9,'SBI_ResidencyRoad',5000);
insert into bankaccount values(10,'SBI_Jantarmantar',2000);
select * from bankaccount;

insert into bankcustomer values('Avinash','Bull_Temple_Road','Bangalore');
insert into bankcustomer values('Dinesh','Bannerghatta_Road','Bangalore');
insert into bankcustomer values('Mohan','National_College_Road','Bangalore');
insert into bankcustomer values('Nikil','Akbar_Road','Delhi');
insert into bankcustomer values('Ravi','Prithviraj_Road','Delhi');
select * from bankcustomer;

insert into depositor values('Avinash',1);
insert into depositor values('Dinesh',2);
insert into depositor values('Nikil',4);
insert into depositor values('Ravi',5);
insert into depositor values('Avinash',7);
insert into depositor values('Nikil',8);
insert into depositor values('Dinesh',9);
insert into depositor values('Nikil',10);
select * from depositor;

insert into loan values(1,'SBI_Chamrajpet',1000);
insert into loan values(2,'SBI_Residencyroad',2000);
insert into loan values(3,'SBI_Shivajiroad',3000);
insert into loan values(4,'SBI_Parliamentroad',4000);
insert into loan values(5,'SBI_Chamrajpet',5000);
select * from loan;

select distinct c.customer_name,b.branch_name from bankcustomer c,bankaccount b where exists(select d.customer_name,count(d.customer_name) from depositor d,bankaccount ba where ba.accno = d.accno and 
c.customer_name = d.customer_name and ba.branch_name = b.branch_name group by d.customer_name having count(d.customer_name)>=2);

select bc.customer_name from bankcustomer bc where not exists ( select branch_name from branch br where br.branch_city = 'Bangalore' and not exists ( select ba.branch_name from depositor dep,bankaccount ba 
where dep.accno = ba.accno and bc.customer_name = dep.customer_name));

delete from bankaccount where branch_name in ( select branch_name from branch where branch_city = 'Bombay');
select * from bankaccount;
commit;
