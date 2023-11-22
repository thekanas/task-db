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
         join ticket_flights tf on t.ticket_no = tf.ticket_no
where fare_conditions = 'Business'
order by t.ticket_no desc
limit 10;

-- 5.Найти все рейсы, у которых нет забронированных мест в бизнес-классе (fare_conditions = 'Business')
select f.flight_id, flight_no, scheduled_departure
from flights f
         join ticket_flights tf on f.flight_id = tf.flight_id
where f.flight_id not in (
    select flight_id
    from ticket_flights tf
    where fare_conditions = 'Business')
group by f.flight_id
order by f.flight_id;

-- 6.Получить список аэропортов (airport_name) и городов (city), в которых есть рейсы с задержкой
select airport_name -> 'ru', city -> 'ru'
from flights f
         join airports_data ad on f.departure_airport = ad.airport_code
where (actual_departure - scheduled_departure) > interval '1 SECOND'
group by airport_name, city
order by city

-- 7.Получить список аэропортов (airport_name) и количество рейсов, вылетающих из каждого аэропорта, отсортированный по убыванию количества рейсов
select airport_name -> 'ru', count(*)
from flights f
         join airports_data ad on f.departure_airport = ad.airport_code
group by airport_name
order by airport_name;

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
-- 12.Найти ближайший вылетающий рейс из Екатеринбурга в Москву, на который еще не завершилась регистрация
-- 13.Вывести самый дешевый и дорогой билет и стоимость (в одном результирующем ответе)
-- 14.Написать DDL таблицы Customers, должны быть поля id, firstName, LastName, email, phone. Добавить ограничения на поля (constraints)
-- 15.Написать DDL таблицы Orders, должен быть id, customerId, quantity. Должен быть внешний ключ на таблицу customers + constraints
-- 16.Написать 5 insert в эти таблицы
-- 17.Удалить таблицы
