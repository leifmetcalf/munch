create table restaurants (
    id uuid primary key default gen_random_uuid(),
    name text not null,
    address text not null
);

create table lists (
    id uuid primary key default gen_random_uuid(),
    name text not null
);

create table items (
    id uuid primary key default gen_random_uuid(),
    list_id uuid not null references lists(id),
    restaurant_id uuid not null references restaurants(id)
);

insert into restaurants (name, address) values ('Chaco Ramen', '123 Main St');
insert into restaurants (name, address) values ('Taco Bell', '456 Main St');
insert into restaurants (name, address) values ('Burger King', '789 Main St');
insert into restaurants (name, address) values ('Tanpopo Ramen', '72 Circular St');
insert into restaurants (name, address) values ('Cantaloupe Gamba', '12 Dials St');
insert into restaurants (name, address) values ('Mappen', '198 Turnpike Rd');
insert into restaurants (name, address) values ('Sushi Hub', '42 Market St');
insert into restaurants (name, address) values ('Guzman y Gomez', '88 Elizabeth St');
insert into restaurants (name, address) values ('Chat Thai', '20 Campbell St');
insert into restaurants (name, address) values ('Mamak', '15 Goulburn St');


insert into lists (name) values ('Ramen restaurants');

insert into items (list_id, restaurant_id)
select l.id, r.id
from lists l, restaurants r
where l.name = 'Ramen restaurants'
and r.name in ('Chaco Ramen', 'Tanpopo Ramen')