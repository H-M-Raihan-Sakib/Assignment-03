create database next_level;

create table users (
    user_id int primary key,
    full_name varchar(100),
    email varchar(150) unique,
    role varchar(30) check (role in ('Ticket Manager', 'Football Fan')),
    phone_number varchar(20)
);

create table matches (
    match_id int primary key,
    fixture varchar(100),
    tournament_category varchar(100),
    base_ticket_price decimal(10,2) check (base_ticket_price >= 0),
    match_status varchar(30) check (match_status in ('Available', 'Selling Fast', 'Sold Out', 'Postponed'))
);

create table bookings (
    booking_id int primary key,
    user_id int,
    match_id int,
    seat_number varchar(20),
    payment_status varchar(20) check (payment_status in ('Pending', 'Confirmed', 'Cancelled', 'Refunded')),
    total_cost decimal(10,2) check (total_cost >= 0),

    foreign key (user_id) references users(user_id),
    foreign key (match_id) references matches(match_id)
);

insert into users values
(1,'Tanvir Rahman','tanvir@mail.com','Football Fan','+8801711111111'),
(2,'Asif Haque','asif@mail.com','Football Fan','+8801722222222'),
(3,'Sajjad Rahman','sajjad@mail.com','Ticket Manager','+8801733333333'),
(4,'Jannat Ara','jannat@mail.com','Football Fan',null);

insert into matches values
(101,'Real Madrid vs Barcelona','Champions League',150,'Available'),
(102,'Man City vs Liverpool','Premier League',120,'Selling Fast'),
(103,'Bayern Munich vs PSG','Champions League',130,'Available'),
(104,'AC Milan vs Inter Milan','Serie A',90,'Sold Out'),
(105,'Juventus vs Roma','Serie A',80,'Available');

insert into bookings values
(501,1,101,'A-12','Confirmed',150),
(502,1,102,'B-04','Confirmed',120),
(503,2,101,'A-13','Confirmed',150),
(504,2,101,null,null,150),
(505,3,102,'C-20','Pending',120);


select match_id, fixture, base_ticket_price from matches where tournament_category = 'Champions League' 
  and match_status = 'Available';

select user_id, full_name, email from users where full_name ilike 'Tanvir%' or full_name ilike '%Haque%';

select booking_id, user_id, match_id, coalesce(payment_status,'Action Required') as systematic_status from bookings
  where payment_status is null;

select b.booking_id, u.full_name, m.fixture, b.total_cost from bookings b inner join users u on b.user_id = u.user_id 
  inner join matches m on b.match_id = m.match_id;

select u.user_id, u.full_name, b.booking_id from users u left join bookings b on u.user_id = b.user_id;

select booking_id, match_id, total_cost from bookings where total_cost >( select avg(total_cost) from bookings);

select match_id, fixture, base_ticket_price from matches order by base_ticket_price desc limit 2 offset 1;