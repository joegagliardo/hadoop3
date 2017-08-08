CREATE KEYSPACE equipment with replication = {'class': 'SimpleStrategy', 'replication_factor':'2' };
use equipment;
create table computer
(
 EquipmentID int PRIMARY KEY,
 Manufacturer text,
 Model text,
 RAM bigint,
 ClockSpeed float,
 Cores tinyint,
 Peripherals LIST<text>,
 Purchased date
 );
 
insert into computer (EquipmentID, Manufacturer, Model, RAM, ClockSpeed, Cores, Peripherals, Purchased)
values (1, 'Apple', 'MacBook Pro', 16, 3.8, 4, ['VGA Dongle', 'Thunderbolt Drive'], '2015-01-01');

insert into computer JSON '{"EquipmentID":"2", "Manufacturer":"Dell", "Model":"Inspiron", "RAM":"8",
"ClockSpeed":"3.2", "Cores":"2", "Purchased":"2016-01-02", "Peripherals": ["Mouse", "Monitor", "Keyboard", "Printer"]}';

update computer set Peripherals = Peripherals + ['Mouse'] where EquipmentID = 1;
update computer set Peripherals = Peripherals - ['Mouse'] where EquipmentID = 1;

alter table computer add Timestamp timeUUID;
 
update computer set Timestamp = now() where EquipmentID = 1;
update computer set Timestamp = now() where EquipmentID = 2;

alter table computer add Misc map<text, text>;

update computer set Misc = {'color':'Silver'} where EquipmentID = 1;
update computer set Misc = {'weight':'4.5 lbs'} where EquipmentID = 1;
update computer set Misc = Misc + {'color':'Silver'} where EquipmentID = 1;
update computer set Misc['color'] = 'white' where EquipmentID = 1;

select * from computer where Misc['color'] = 'white' allow filtering;

delete Misc['color'] from computer where EquipmentID = 1;

