-- 1.Вывести к каждому самолету класс обслуживания и количество мест этого класса
select model -> 'ru', fare_conditions, count(*)
from aircrafts_data ad
         join seats s on ad.aircraft_code = s.aircraft_code
group by model, fare_conditions
order by model;

-- 2.Найти 3 самых вместительных самолета (модель + кол-во мест)
select model -> 'ru', count(*) as seats
from aircrafts_data ad
         join seats s on ad.aircraft_code = s.aircraft_code
group by model
order by seats desc
limit 3;

-- 3.Найти все рейсы, которые задерживались более 2 часов
select flight_id , (actual_departure - scheduled_departure) as diff
from flights f
where (actual_departure - scheduled_departure) > interval '2 HOUR';

-- 4.Найти последние 10 билетов, купленные в бизнес-классе (fare_conditions = 'Business'), с указанием имени пассажира и контактных данных
select t.ticket_no, passenger_name, contact_data -> 'email' as email, contact_data -> 'phone' as phone
from tickets t
         join ticket_flights tf on t.ticket_no = tf.ticket_no and fare_conditions = 'Business'
         join bookings b on t.book_ref = b.book_ref
group by t.ticket_no, b.book_date
order by b.book_date desc
limit 10;

-- 5.Найти все рейсы, у которых нет забронированных мест в бизнес-классе (fare_conditions = 'Business')
select f.flight_id, flight_no, scheduled_departure
from flights f
         left join ticket_flights tf on f.flight_id = tf.flight_id and tf.fare_conditions = 'Business'
where tf.ticket_no  is null
order by f.flight_id;

-- 6.Получить список аэропортов (airport_name) и городов (city), в которых есть рейсы с задержкой
select airport_name -> 'ru' as airport, city -> 'ru' as  city
from flights f
         join airports_data ad on f.departure_airport = ad.airport_code
where f.status = 'Delayed'
group by airport_name, city
order by city;

-- 7.Получить список аэропортов (airport_name) и количество рейсов, вылетающих из каждого аэропорта, отсортированный по убыванию количества рейсов
select airport_name -> 'ru', count(*)
from flights f
         join airports_data ad on f.departure_airport = ad.airport_code
group by airport_name
order by count desc;

-- 8.Найти все рейсы, у которых запланированное время прибытия (scheduled_arrival) было изменено и новое время прибытия (actual_arrival) не совпадает с запланированным
select flight_id, scheduled_arrival, actual_arrival
from flights f
where actual_arrival != scheduled_arrival;

-- 9.Вывести код, модель самолета и места не эконом класса для самолета "Аэробус A321-200" с сортировкой по местам
select s.aircraft_code , model -> 'ru', seat_no
from seats s
         join aircrafts_data ad on s.aircraft_code = ad.aircraft_code
where model ->> 'ru' = 'Аэробус A321-200'
         and s.fare_conditions != 'Economy'
order by seat_no;

-- 10.Вывести города, в которых больше 1 аэропорта (код аэропорта, аэропорт, город)
select airport_code  , airport_name -> 'ru', city -> 'ru'
from airports_data ad2
where city in (
    select city
    from airports_data ad2
    group by city
    having count(*) > 1)
order by city;

-- 11.Найти пассажиров, у которых суммарная стоимость бронирований превышает среднюю сумму всех бронирований
select passenger_name , sum(total_amount) as summa
from tickets t
         join bookings b on t.book_ref =b.book_ref
group by passenger_name
having sum(total_amount) > (select avg(total_amount)
                            from bookings)
order by passenger_name;

-- 12.Найти ближайший вылетающий рейс из Екатеринбурга в Москву, на который еще не завершилась регистрация
select *
from flights f
where departure_airport in
      (select airport_code
       from airports_data ad
       where city ->> 'ru' = 'Екатеринбург')
  and
        arrival_airport  in
        (select airport_code
         from airports_data ad
         where city ->> 'ru' = 'Москва')
  and
        status in ('Scheduled', 'On Time', 'Delayed')
order by scheduled_departure
limit 1;

-- 13.Вывести самый дешевый и дорогой билет и стоимость (в одном результирующем ответе)
(select ticket_no, amount
 from ticket_flights
 order by amount desc
 limit 1)
union
(select ticket_no, amount
 from ticket_flights
 order by amount asc
 limit 1);

-- 14.Написать DDL таблицы Customers, должны быть поля id, firstName, LastName, email, phone. Добавить ограничения на поля (constraints)
create table customers
(
    id        serial primary key,
    firstName varchar(30) not null,
    lastName  varchar(30) not null,
    email     varchar(30) unique,
    phone     varchar(30) unique
);

-- 15.Написать DDL таблицы Orders, должен быть id, customerId, quantity. Должен быть внешний ключ на таблицу customers + constraints
create table orders
(
    id         bigserial primary key,
    customerId integer references customers (id) on delete cascade,
    quantity   integer not null check ( quantity >= 0 )
);

-- 16.Написать 5 insert в эти таблицы
insert into customers (firstName, lastName, email, phone)
values ('Yuriy', 'Pinchuk', 'email1@email.com', '+375291112233'),
       ('Olga', 'Sugak', 'email2@email.com', '+375291112234'),
       ('Yuliya', 'Dolgacheva', 'email3@email.com', '+375291112235'),
       ('Petr', 'Eroshenko', 'email4@email.com', '+375291112236'),
       ('Evgenii', 'Bazylev', 'email5@email.com', '+375291112237');

insert into orders (customerId, quantity)
values (1, 1),
       (2, 3),
       (3, 6),
       (4, 8),
       (5, 2);

-- 17.Удалить таблицы
drop table orders;
drop table customers;