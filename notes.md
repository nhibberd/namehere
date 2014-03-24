dbname=toasterdb host=localhost user=toaster password=password port=5432



PostgreSQL setup
----------------

psql

create user toaster with password 'password';
create database toasterdb;
grant all privilegest on database toasterdb to toaster;