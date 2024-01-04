-- Let's drop the tables in case they exist from previous runs
drop table if exists includes;
drop table if exists lists;
drop table if exists retweets;
drop table if exists mentions;
drop table if exists hashtags;
drop table if exists tweets;
drop table if exists follows;
drop table if exists users;

create table users (
  usr         int,
  pwd	      text,
  name        text,
  email       text,
  city        text,
  timezone    float,
  primary key (usr)
);
create table follows (
  flwer       int,
  flwee       int,
  start_date  date,
  primary key (flwer,flwee),
  foreign key (flwer) references users,
  foreign key (flwee) references users
);
create table tweets (
  tid	      int,
  writer      int,
  tdate       date,
  text        text,
  replyto     int,
  primary key (tid),
  foreign key (writer) references users,
  foreign key (replyto) references tweets
);
create table hashtags (
  term        text,
  primary key (term)
);
create table mentions (
  tid         int,
  term        text,
  primary key (tid,term),
  foreign key (tid) references tweets,
  foreign key (term) references hashtags
);
create table retweets (
  usr         int,
  tid         int,
  rdate       date,
  primary key (usr,tid),
  foreign key (usr) references users,
  foreign key (tid) references tweets
);
create table lists (
  lname        text,
  owner        int,
  primary key (lname),
  foreign key (owner) references users
);
create table includes (
  lname       text,
  member      int,
  primary key (lname,member),
  foreign key (lname) references lists,
  foreign key (member) references users
);

-- DATA

-- USERS
--   usr         int,
--   pwd	     text,
--   name        text,
--   email       text,
--   city        text,
--   timezone    float,
--   primary key (usr)

insert into users values (15, "iLoveMessi", "Mazen Khafagy", "mazenkhafagy@gmail.com", "edmonton", -7);
insert into users values (99, "TheLegend", "John Doe", "THEGOAT@gmail.com", "edmonton", -7);
insert into users values (102, "iLoveMessi", "David David", "David@gmail.com", "edmonton", -7);
insert into users values (103, "lightside>darkside", "Obi Wan Kenobi", "thisguy123@gmail.com", "calgary", -9);
insert into users values (104, "michel123", "Barack Obama", "obama@gmail.com", "toronto", -4);
insert into users values (10, "cr7_trash", "Lionel Messi", "messi@gmail.com", "miami", 0);
insert into users values (7, "messi_trash", "Cristiano Ronaldo", "cr7@gmail.com", "riyadh", +6);
insert into users values (12, "I_HATE_EAGLES", "Conner Mcgregor", "proper12@gmail.com", "Las Vegas", -7);
insert into users values (79, "BrownGirlsLovr", "Ishfaq Mostain", "ishfaq@gmail.com", "dubai", +8);
INSERT INTO users VALUES (140, 'k8i9C%Kn(i', 'Jason', 'jason140@gmail.com', 'North Walter', -1);
INSERT INTO users VALUES (311, '@XLTe)Cm63', 'Meagan', 'meagan311@yahoo.com', 'Port Angelastad', -4);
INSERT INTO users VALUES (967, 'u5DE49n4*h', 'Monique', 'monique968@gmail.com', 'Jordanton', 7);
INSERT INTO users VALUES (54, '#2J0EIcrml', 'Sara', 'sara54@gmail.com', 'Barbarashire', 9);
INSERT INTO users VALUES (251, '4yJFAo!s!e', 'Christopher', 'christopher251@gmail.com', 'East James', -4),
(134, '3eJiV827', 'Alice Johnson', 'alice@example.com', 'New York', -5),
(482, '9kV72djs', 'Bob Smith', 'bob@example.com', 'Los Angeles', -8),
(519, 'p82DkjnS', 'Charlie Brown', 'charlie@example.com', 'Chicago', -6),
(203, '1xP93Kmz', 'Diana Prince', 'diana@example.com', 'Houston', -6),
(657, 'aX29dkLm', 'Evan Wright', 'evan@example.com', 'Phoenix', -7),
(323, 'lQm28sP0', 'Fiona Gallagher', 'fiona@example.com', 'Philadelphia', -5),
(491, 'u39Kv72m', 'George King', 'george@example.com', 'San Antonio', -6),
(782, 'rT56nZ31', 'Hannah Abbott', 'hannah@example.com', 'San Diego', -8),
(264, 'mV7a8D3x', 'Ivan Rogers', 'ivan@example.com', 'Dallas', -6),
(870, '3mP82jVn', 'Julia Martinez', 'julia@example.com', 'San Jose', -8),
(357, 'w2Kl5bV7', 'Kyle Xavier', 'kyle@example.com', 'Austin', -6),
(425, 'yG59vKp2', 'Lily Evans', 'lily@example.com', 'Jacksonville', -5),
(968, 'zP93dMk8', 'Michael Johnson', 'michael@example.com', 'San Francisco', -8),
(143, 'xB2v3kLm', 'Nina Oliver', 'nina@example.com', 'Indianapolis', -5),
(597, 'qF28lPm3', 'Oscar Wilde', 'oscar@example.com', 'Columbus', -5),
(210, 'h72KmV39', 'Pam Beesly', 'pam@example.com', 'Fort Worth', -6),
(874, 'sT31nZ56', 'Quentin Cook', 'quentin@example.com', 'Charlotte', -5),
(582, 'jD3xVm7a', 'Rachel Green', 'rachel@example.com', 'Detroit', -5),
(369, 'kVn3mP82', 'Steve Fox', 'steve@example.com', 'El Paso', -7),
(486, 'eL7w2Kb5', 'Tina Fey', 'tina@example.com', 'Seattle', -8),
(999999, 'adminn', 'admin', "admin@admin.com", 'admin city', 0);

INSERT INTO users VALUES (600, '9kV72djs', 'Rebecca Hall', 'rebecca@example.com', 'Denver', -7),
(431, 'p82DkjnS', 'Tom Hiddleston', 'tom@example.com', 'Boston', -5),
(658, 'aX29dkLm', 'Marcus Aurelius', 'marcus@example.com', 'Rome', +1),
(324, 'lQm28sP0', 'Trevor Noah', 'trevor@example.com', 'Johannesburg', +2),
(492, 'u39Kv72m', 'Sophie Turner', 'sophie@example.com', 'London', 0),
(783, 'rT56nZ31', 'Chadwick Boseman', 'chadwick@example.com', 'Los Angeles', -8),
(265, 'mV7a8D3x', 'Zoe Saldana', 'zoe@example.com', 'New Jersey', -5),
(871, '3mP82jVn', 'Idris Elba', 'idris@example.com', 'London', 0),
(358, 'w2Kl5bV7', 'Emma Stone', 'emma@example.com', 'Scottsdale', -7),
(426, 'yG59vKp2', 'Chris Hemsworth', 'chris@example.com', 'Melbourne', +10),
(969, 'zP93dMk8', 'Scarlett Johansson', 'scarlett@example.com', 'New York', -5),
(144, 'xB2v3kLm', 'Ryan Reynolds', 'ryan@example.com', 'Vancouver', -8),
(598, 'qF28lPm3', 'Hugh Jackman', 'hugh@example.com', 'Sydney', +10),
(211, 'h72KmV39', 'Jennifer Lawrence', 'jennifer@example.com', 'Louisville', -5),
(875, 'sT31nZ56', 'Brad Pitt', 'brad@example.com', 'Springfield', -6),
(583, 'jD3xVm7a', 'Angelina Jolie', 'angelina@example.com', 'Los Angeles', -8),
(370, 'kVn3mP82', 'Keanu Reeves', 'keanu@example.com', 'Beirut', +2),
(487, 'eL7w2Kb5', 'Tom Cruise', 'tom@example.com', 'Syracuse', -5),
(999998, 'admin2', 'admin2', 'admin2@admin.com', 'admin city2', 0);

INSERT INTO users VALUES (501, 'z2F49mNl', 'Olivia Benson', 'olivia@example.com', 'New York', -5),
(502, 'jL9pQ83h', 'Elliot Stabler', 'elliot@example.com', 'New York', -5),
(503, 'hT3mP8aV', 'Amanda Rollins', 'amanda@example.com', 'Atlanta', -5),
(504, 'nQ6sT0zK', 'Odafin Tutuola', 'fin@example.com', 'New York', -5),
(505, 'vJ4rE9s1', 'John Munch', 'john@example.com', 'Baltimore', -5),
(506, 'wY3pD7eM', 'Donald Cragen', 'donald@example.com', 'New York', -5),
(507, 'xL1sV9dP', 'Rafael Barba', 'rafael@example.com', 'New York', -5),
(508, 'yM5sR0eN', 'Dominick Carisi', 'dominick@example.com', 'New York', -5),
(509, 'zM7sW6dH', 'Melinda Warner', 'melinda@example.com', 'New York', -5),
(510, 'aF3sQ9vB', 'George Huang', 'george@example.com', 'San Francisco', -8),
(511, 'bG2sX8cJ', 'Monique Jeffries', 'monique@example.com', 'Philadelphia', -5),
(512, 'cH4sY7bK', 'Chester Lake', 'chester@example.com', 'New York', -5),
(513, 'dI5sZ6aL', 'Nick Amaro', 'nick@example.com', 'New York', -5),
(514, 'eJ6sA5zM', 'Mike Dodds', 'mike@example.com', 'New York', -5),
(515, 'fK7sB4yN', 'Peter Stone', 'peter@example.com', 'Chicago', -6),
(516, 'gL8sC3xO', 'Kat Tamin', 'kat@example.com', 'New York', -5),
(517, 'hM9sD2wP', 'Ed Tucker', 'ed@example.com', 'New York', -5),
(518, 'iN0sE1vQ', 'Phoebe Baker', 'phoebe@example.com', 'New York', -5),
(519, 'jO1sF0uR', 'Lucy Huston', 'lucy@example.com', 'New York', -5),
(520, 'kP2sG9tS', 'Garland', 'garland@example.com', 'New York', -5);



-- FOLLOWS
--   flwer       int,
--   flwee       int,
--   start_date  date,
--   primary key (flwer,flwee),
--   foreign key (flwer) references users,
--   foreign key (flwee) references users

insert into follows values (15, 99, '2023-09-11');      --Mazen -> john
insert into follows values (15, 10, '2023-09-12');      --Mazen -> messi
insert into follows values (15, 7, '2023-09-12');       --Mazen -> cr7
insert into follows values (15, 102, '2022-07-03');     --Mazen -> david
insert into follows values (15, 12, '2023-07-03');      --Mazen -> conner
insert into follows values (102, 10, '2021-01-09');     --David -> messi 
insert into follows values (102, 7, '2021-01-09');      --David -> cr7
insert into follows values (102, 12, '2022-04-20');     --David -> conner
insert into follows values (102, 104, '2016-05-08'),--David -> messi
(134, 482, '2023-10-01'),
(482, 519, '2023-10-02'),
(519, 203, '2023-10-03'),
(203, 657, '2023-10-04'),
(657, 323, '2023-10-05'),
(323, 491, '2023-10-06'),
(491, 782, '2023-10-07'),
(782, 264, '2023-10-08'),
(264, 870, '2023-10-09'),
(870, 357, '2023-10-10'),
(357, 425, '2023-10-11'),
(425, 968, '2023-10-12'),
(968, 143, '2023-10-13'),
(143, 597, '2023-10-14'),
(597, 210, '2023-10-15'),
(210, 874, '2023-10-16'),
(874, 582, '2023-10-17'),
(582, 369, '2023-10-18'),
(369, 486, '2023-10-19'),
(486, 134, '2023-10-20');

-- TWEETS
--   tid	       int,
--   writer      int,
--   tdate       date,
--   text        text,
--   replyto     int,
--   primary key (tid),
--   foreign key (writer) references users,
--   foreign key (replyto) references tweets

insert into tweets values (1, 10, '2023-10-30', "Ballon D'or 8 #cr7 #trash", null);
insert into tweets values (2, 15, '2023-10-20', "Good soccer match today", null),
(155, 134, '2023-11-01', 'Just had an amazing meal! #food', NULL),
(255, 482, '2023-11-02', 'Exploring the city lights #travel', NULL),
(3, 519, '2023-11-03', 'Crushed my workout today #fitness', NULL),
(4, 203, '2023-11-04', 'New album dropped! #music', NULL),
(5, 657, '2023-11-05', 'Captured a stunning sunset #photography', NULL),
(6, 323, '2023-11-06', 'Finished a new piece of art #art', NULL),
(7, 491, '2023-11-07', 'Enjoying the beauty of nature #nature', NULL),
(8, 782, '2023-11-08', 'Tech conference was insightful #technology', NULL),
(9, 264, '2023-11-09', 'Game night with friends #sports', NULL),
(10, 870, '2023-11-10', 'Learning never stops #education', NULL),
(11, 357, '2023-11-11', 'Health is wealth #health', NULL),
(12, 425, '2023-11-12', 'Obsessed with this new style #fashion', NULL),
(13, 968, '2023-11-13', 'Lets discuss policy changes #politics', NULL),
(14, 143, '2023-11-14', 'Entrepreneur life #business', NULL),
(15, 597, '2023-11-15', 'Science is fascinating #science', NULL),
(16, 210, '2023-11-16', 'Feeling blessed #love', NULL),
(17, 874, '2023-11-17', 'Daily dose of motivation #motivation', NULL),
(18, 582, '2023-11-18', 'Living my best life #lifestyle', NULL),
(19, 369, '2023-11-19', 'Gaming session was epic #gaming', NULL),
(20, 486, '2023-11-20', 'Reflecting on history #history', NULL);

-- HASHTAGS (just text)

insert into hashtags values ('soccer');
insert into hashtags values ('nature');
insert into hashtags values ('gym'),
('food'),
('travel'),
('fitness'),
('music'),
('photography'),
('art'),
('technology'),
('sports'),
('education'),
('health'),
('fashion'),
('politics'),
('business'),
('science'),
('love'),
('motivation'),
('lifestyle'),
('gaming'),
('history');

-- MENTIONS
--   tid         int,
--   term        text,
--   primary key (tid,term),
--   foreign key (tid) references tweets,
--   foreign key (term) references hashtags

insert into mentions values (1, 'soccer');
insert into mentions values (2, 'soccer'),
(155, 'food'),
(255, 'travel'),
(3, 'fitness'),
(4, 'music'),
(5, 'photography'),
(6, 'art'),
(7, 'nature'),
(8, 'technology'),
(9, 'sports'),
(10, 'education'),
(11, 'health'),
(12, 'fashion'),
(13, 'politics'),
(14, 'business'),
(15, 'science'),
(16, 'love'),
(17, 'motivation'),
(18, 'lifestyle'),
(19, 'gaming'),
(20, 'history');
  
-- RETWEETS
--   usr         int,
--   tid         int,
--   rdate       date,

insert into retweets values (15, 1, '2023-10-30'),
(134, 20, '2023-11-02'),
(482, 19, '2023-11-03'),
(519, 18, '2023-11-04'),
(203, 17, '2023-11-05'),
(657, 16, '2023-11-06'),
(323, 15, '2023-11-07'),
(491, 14, '2023-11-08'),
(782, 13, '2023-11-09'),
(264, 12, '2023-11-10'),
(870, 11, '2023-11-11'),
(357, 10, '2023-11-12'),
(425, 9, '2023-11-13'),
(968, 8, '2023-11-14'),
(143, 7, '2023-11-15'),
(597, 6, '2023-11-16'),
(210, 5, '2023-11-17'),
(874, 4, '2023-11-18'),
(582, 3, '2023-11-19'),
(369, 2, '2023-11-20'),
(486, 1, '2023-11-21');

-- LISTS
--   lname        text,
--   owner        int,

insert into lists values ('Soccer Players', 15),
('Tech Enthusiasts', 134),
('Food Lovers', 482),
('Travel Buffs', 519),
('Fitness Maniacs', 203),
('Music Fans', 657),
('Art Admirers', 323),
('Nature Watchers', 491),
('Startup Founders', 782),
('Sports Fanatics', 264),
('Bookworms', 870),
('Health Gurus', 357),
('Fashion Forward', 425),
('Political Debaters', 968),
('Business Minds', 143),
('Science Geeks', 597),
('Love & Life', 210),
('Motivation Speakers', 874),
('Lifestyle Influencers', 582),
('Gaming Squad', 369),
('History Buffs', 486);

-- INCLUDES
--   lname       text,
--   member      int,

insert into includes values ('Soccer Players', 10);
insert into includes values ('Soccer Players', 7),
('Tech Enthusiasts', 134),
('Tech Enthusiasts', 203),
('Food Lovers', 482),
('Food Lovers', 519),
('Travel Buffs', 657),
('Fitness Maniacs', 323),
('Music Fans', 491),
('Art Admirers', 782),
('Nature Watchers', 264),
('Startup Founders', 870),
('Sports Fanatics', 357),
('Bookworms', 425),
('Health Gurus', 968),
('Fashion Forward', 143),
('Political Debaters', 597),
('Business Minds', 210),
('Science Geeks', 874),
('Love & Life', 582),
('Motivation Speakers', 369),
('Lifestyle Influencers', 486);
