create keyspace classroom with replication={'class':'SimpleStrategy', 'replication_factor':'1'};
describe keyspaces
describe keyspace classroom
use classroom ;
create table People(PersonID int PRIMARY KEY, FirstName text);
describe tables;
describe table people;
insert into people (PersonID, Firstname) values (1, 'joey');
select * from people;
update people set firstname = 'Joey' where personid = 1;
select * from people;
insert people values (2, 'mike');
insert people (personid, firstname) values (2, 'mike');
insert into people (personid, firstname) values (2, 'mike');
insert into people (personid, firstname) values (2, 'mary');
insert into people (personid, firstname) values (2, 'susan') if not exists;
select * from people;
update people set firstname = 'jack' where personid = 2;
select * from people;

create table student (id int PRIMARY KEY, first_name text, last_name text, email_addresses set<text>);
describe student;
insert into student (id, first_name, last_name, email_addresses) values (1, 'joey', 'gagliardo', {'joey@me.com', 'joegagliardo@yahoo.com'});
select * from student;

update student set first_name = 'Joseph', email_addresses = {'joey@me.com'} where id = 1;
select * from student;
update student set email_addresses = email_addresses + {'joeg@me.com'} where id = 1;
select * from student;
update student set email_addresses = email_addresses + {'joeg@me.com'} where id = 1;
select * from student;
update student set email_addresses = email_addresses - {'joeg@me.com'} where id = 1;
select * from student;

insert into student (id, first_name, last_name, email_addresses) values (2, 'aaa', 'bbb', {'a@a.com', 'b@b.com', 'c@c.com'});
select * from student;
select json * from student ;
insert into student json '{"last_name":"ddd", "first_name":"ccc", "id":4 }';
select * from student;
insert into student json '{"last_name":"ddd", "first_name":"ccc", "id":5, "whatever":1 }';

select * from people;
copy people to 'people1.txt';
copy people to 'people2.txt' with  header='TRUE';

create table people1 (
personid int PRIMARY KEY,
firstname text
);

copy people1 from 'people2.txt' with header='TRUE';
select * from people1;
