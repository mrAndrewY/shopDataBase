create schema if not exists shop;

create table if not exists shop.category (
    id serial primary key,
    name_category varchar(50) not null unique
);

create table if not exists shop.goods_description (
    id serial primary key,
    id_category int references shop.category(id),
    art_shop varchar(8),
    category varchar(30),
    type varchar(30),
    model_manufacturer varchar(30),
    art_manufacturer varchar(30),
    name_manufacturer varchar(30),
    country_of_origin varchar(15),
    trade_mark varchar(15),
    common_description varchar(100),
    material varchar(50),
    weight_kq real,
    size_height_meters real,
    size_wide_meters real,
    size_deep_meters real,
    color varchar(20)
);

create table if not exists shop.price_owner (
    id serial primary key,
    goods_id int references shop.goods_description(id),
    price money
);

create table if not exists shop.sellers_price (
    id serial primary key,
    goods_id int references shop.goods_description(id),
    price money
);

create table if not exists shop.attributes (
    id serial primary key,
    attribute_name varchar(40)
);

create table if not exists shop.attributes_goods (
    id serial primary key,
    id_attribute int references shop.attributes(id),
    id_goods int references shop.goods_description(id)
);

create table if not exists shop.client (
    id serial primary key,
    client_first_name varchar(40) not null,
    client_last_name varchar(40) not null,
    client_mob_phone1 varchar(12) not null,
    client_mob_phone2 varchar(12),
    client_mail varchar(40) not null,
    delivery_address varchar(200),
    unique (client_first_name, client_last_name)
);

create table if not exists shop.employee (
    id serial primary key,
    employee_first_name varchar(40) not null,
    employee_last_name varchar(40) not null,
    employee_email varchar(40) not null,
    employee_phone varchar(14) not null,
    unique (employee_first_name, employee_last_name)
);

create table if not exists shop.order (
    id serial primary key,
    cash_payment boolean,
    client_id int references shop.client(id),
    employee_id int references shop.employee(id),
    client_notes varchar(200),
    need_delivery boolean,
    goods_value money,
    delivery_price money,
    total money
);

create table if not exists shop.step (
    id serial primary key,
    step_name varchar(40) not null
);

insert into shop.step(step_name) values ('payment');
insert into shop.step(step_name) values ('transporting');
insert into shop.step(step_name) values ('delivery');

create table if not exists shop.step_order (
    id serial primary key,
    step_id int references shop.step(id),
    order_id int references shop.order(id),
    date_begin date,
    date_end date
);

create table if not exists shop.order_goods (
    id serial primary key,
    order_id int references shop.order(id),
    goods_id int references shop.goods_description(id)
);

drop schema shop cascade;
