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


INSERT INTO users (usr, pwd, name, email, city, timezone) VALUES 
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
(486, 'eL7w2Kb5', 'Tina Fey', 'tina@example.com', 'Seattle', -8);




INSERT INTO follows (flwer, flwee, start_date) VALUES 
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


INSERT INTO tweets (tid, writer, tdate, text, replyto) VALUES 
(1, 134, '2023-11-01', 'Just had an amazing meal! #food', NULL),
(2, 482, '2023-11-02', 'Exploring the city lights #travel', NULL),
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


INSERT INTO hashtags (term) VALUES 
('food'),
('travel'),
('fitness'),
('music'),
('photography'),
('art'),
('nature'),
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


INSERT INTO mentions (tid, term) VALUES 
(1, 'food'),
(2, 'travel'),
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


INSERT INTO retweets (usr, tid, rdate) VALUES 
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

INSERT INTO lists (lname, owner) VALUES 
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

INSERT INTO includes (lname, member) VALUES 
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

