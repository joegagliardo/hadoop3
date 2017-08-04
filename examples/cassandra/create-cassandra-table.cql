create keyspace joey with replication = {'class':'SimpleStrategy', 'replication_factor': 3};
use joey;
create table names (id int PRIMARY KEY, name varchar);
insert into names (id, name) values (1, 'joey');
