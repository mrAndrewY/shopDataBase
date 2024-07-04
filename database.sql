create schema if not exists shop;

create table if not exists shop.category (
    id serial primary key,
    name_category varchar(50) not null unique
);

create table if not exists shop.goods (
    id serial primary key,
    category_id int references shop.category,
    article varchar(8),
    model varchar(30),
    article_manufacture varchar(30),
    name_good varchar(30),
    country_of_origin varchar(15),
    trade_mark varchar(15),
    description varchar(100),
    material varchar(50),
    weight real,
    height real,
    width real,
    len real,
    color varchar(20)
);

create table if not exists shop.price_owner (
    id serial primary key,
    goods_id int references shop.goods,
    price money
);

create table if not exists shop.price_seller (
    id serial primary key,
    goods_id int references shop.goods,
    price money
);

create table if not exists shop.attribute (
    id serial primary key,
    name_attribute varchar(40)
);

create table if not exists shop.category_attribute (
    id serial primary key,
    category_id int references shop.category,
    attribute_id int references shop.attribute
);

create table if not exists shop.goods_attribute (
    id serial primary key,
    attribute_id int references shop.attribute,
    goods_id int references shop.goods,
    value_attribute varchar(50)
);

create table if not exists shop.client (
    id serial primary key,
    firstname varchar(40) not null,
    lastname varchar(40) not null,
    phone varchar(18) not null,
    phone_extra varchar(18),
    email varchar(40) not null unique,
    address varchar(200),
    create_at timestamp not null,
    updated_at timestamp,
    notes varchar(1000),
    last_order_date date,
    total_orders int,
    total_spent money
);

create table if not exists shop.employee (
    id serial primary key,
    firstname varchar(40) not null,
    lastname varchar(40) not null,
    email varchar(40) not null,
    phone varchar(14) not null,
    unique (firstname, lastname)
);

create table if not exists shop.order (
    id serial primary key,
    cash_payment boolean,
    client_id int references shop.client,
    employee_id int references shop.employee,
    client_notes varchar(200),
    need_delivery boolean,
    goods_value money,
    delivery_price money,
    total money
);

create table if not exists shop.step (
    id serial primary key,
    description varchar(40) not null
);

insert into shop.step values (default, 'payment');
insert into shop.step values (default, 'transporting');
insert into shop.step values (default, 'delivery');

create table if not exists shop.step_order (
    id serial primary key,
    step_id int references shop.step,
    order_id int references shop.order,
    date_begin date,
    date_end date
);

create table if not exists shop.goods_order (
    id serial primary key,
    order_id int references shop.order,
    goods_id int references shop.goods
);

create table if not exists shop.goods_count (
    id serial primary key,
    goods_id int references shop.goods,
    sold int,
    reserved int,
    available int
);

create table if not exists shop.client_basket (
    id serial primary key,
    client_id int references shop.client,
    goods_id int references shop.goods,
    count int
);

drop schema shop cascade;
