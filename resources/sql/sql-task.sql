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
select flight_id ,  (actual_departure - scheduled_departure) as diff
from flights f
where (actual_departure - scheduled_departure) > interval '2 HOUR'

-- 4.Найти последние 10 билетов, купленные в бизнес-классе (fare_conditions = 'Business'), с указанием имени пассажира и контактных данных
select t.ticket_no, passenger_name, contact_data -> 'email' as email, contact_data -> 'phone' as phone
from tickets t
         join ticket_flights tf on t.ticket_no = tf.ticket_no
where fare_conditions = 'Business'
order by t.ticket_no desc
limit 10;

-- 5.Найти все рейсы, у которых нет забронированных мест в бизнес-классе (fare_conditions = 'Business')


-- 6.Получить список аэропортов (airport_name) и городов (city), в которых есть рейсы с задержкой
-- 7.Получить список аэропортов (airport_name) и количество рейсов, вылетающих из каждого аэропорта, отсортированный по убыванию количества рейсов
-- 8.Найти все рейсы, у которых запланированное время прибытия (scheduled_arrival) было изменено и новое время прибытия (actual_arrival) не совпадает с запланированным
-- 9.Вывести код, модель самолета и места не эконом класса для самолета "Аэробус A321-200" с сортировкой по местам
-- 10.Вывести города, в которых больше 1 аэропорта (код аэропорта, аэропорт, город)
-- 11.Найти пассажиров, у которых суммарная стоимость бронирований превышает среднюю сумму всех бронирований
-- 12.Найти ближайший вылетающий рейс из Екатеринбурга в Москву, на который еще не завершилась регистрация
-- 13.Вывести самый дешевый и дорогой билет и стоимость (в одном результирующем ответе)
-- 14.Написать DDL таблицы Customers, должны быть поля id, firstName, LastName, email, phone. Добавить ограничения на поля (constraints)
-- 15.Написать DDL таблицы Orders, должен быть id, customerId, quantity. Должен быть внешний ключ на таблицу customers + constraints
-- 16.Написать 5 insert в эти таблицы
-- 17.Удалить таблицы
