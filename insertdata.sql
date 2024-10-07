INSERT INTO users (nickname, user_flag, icon, auth_id)
VALUES 
('User1', false, 'img/user/default.png', null),
('User2', false, 'img/user/default.png', null),
('User3', false, 'img/user/default.png', null),
('User4', false, 'img/user/default.png', null),
('User5', false, 'img/user/default.png', null),
('User6', false, 'img/user/default.png', null),
('User7', false, 'img/user/default.png', null),
('User8', false, 'img/user/default.png', null),
('User9', false, 'img/user/default.png', null),
('User10', false, 'img/user/default.png', null);
-- Messagesテーブルのテストデータ
INSERT INTO messages (address, message_text, recommended_place, location, category, post_timestamp, user_id)
VALUES 
('Address1', 'Message1', 'Place1', ST_GeomFromText('POINT(0 0)', 4326), 'Category1', '2024-07-08 10:00:00', 1),
('Address2', 'Message2', 'Place2', ST_GeomFromText('POINT(1 1)', 4326), 'Category2', '2024-07-08 11:00:00', 2),
('Address3', 'Message3', 'Place3', ST_GeomFromText('POINT(2 2)', 4326), 'Category3', '2024-07-08 12:00:00', 3),
('Address4', 'Message4', 'Place4', ST_GeomFromText('POINT(3 3)', 4326), 'Category4', '2024-07-08 13:00:00', 4),
('Address5', 'Message5', 'Place5', ST_GeomFromText('POINT(4 4)', 4326), 'Category5', '2024-07-08 14:00:00', 5),
('Address6', 'Message6', 'Place6', ST_GeomFromText('POINT(5 5)', 4326), 'Category6', '2024-07-08 15:00:00', 6),
('Address7', 'Message7', 'Place7', ST_GeomFromText('POINT(6 6)', 4326), 'Category7', '2024-07-08 16:00:00', 7),
('Address8', 'Message8', 'Place8', ST_GeomFromText('POINT(7 7)', 4326), 'Category8', '2024-07-08 17:00:00', 8),
('Address9', 'Message9', 'Place9', ST_GeomFromText('POINT(8 8)', 4326), 'Category9', '2024-07-08 18:00:00', 9),
('Address10', 'Message10', 'Place10', ST_GeomFromText('POINT(9 9)', 4326), 'Category10', '2024-07-08 19:00:00', 10);

-- Favoritesテーブルのテストデータ
INSERT INTO favorites (message_id, user_id, registration_date)
VALUES 
(1, 1, '2024-07-08 10:00:00'),
(2, 2, '2024-07-08 11:00:00'),
(3, 3, '2024-07-08 12:00:00'),
(4, 4, '2024-07-08 13:00:00'),
(5, 5, '2024-07-08 14:00:00'),
(6, 6, '2024-07-08 15:00:00'),
(7, 7, '2024-07-08 16:00:00'),
(8, 8, '2024-07-08 17:00:00'),
(9, 9, '2024-07-08 18:00:00'),
(10, 10, '2024-07-08 19:00:00');

-- Bookmarksテーブルのテストデータ
INSERT INTO bookmarks (message_id, user_id, registration_date)
VALUES 
(1, 1, '2024-07-08 10:00:00'),
(2, 2, '2024-07-08 11:00:00'),
(3, 3, '2024-07-08 12:00:00'),
(4, 4, '2024-07-08 13:00:00'),
(5, 5, '2024-07-08 14:00:00'),
(6, 6, '2024-07-08 15:00:00'),
(7, 7, '2024-07-08 16:00:00'),
(8, 8, '2024-07-08 17:00:00'),
(9, 9, '2024-07-08 18:00:00'),
(10, 10, '2024-07-08 19:00:00');

-- Storesテーブルのテストデータ
INSERT INTO stores (store_name, location, postal_code, address)
VALUES 
('Store1', ST_GeomFromText('POINT(0 0)', 4326), '00001', 'Address1'),
('Store2', ST_GeomFromText('POINT(1 1)', 4326), '00002', 'Address2'),
('Store3', ST_GeomFromText('POINT(2 2)', 4326), '00003', 'Address3'),
('Store4', ST_GeomFromText('POINT(3 3)', 4326), '00004', 'Address4'),
('Store5', ST_GeomFromText('POINT(4 4)', 4326), '00005', 'Address5'),
('Store6', ST_GeomFromText('POINT(5 5)', 4326), '00006', 'Address6'),
('Store7', ST_GeomFromText('POINT(6 6)', 4326), '00007', 'Address7'),
('Store8', ST_GeomFromText('POINT(7 7)', 4326), '00008', 'Address8'),
('Store9', ST_GeomFromText('POINT(8 8)', 4326), '00009', 'Address9'),
('Store10', ST_GeomFromText('POINT(9 9)', 4326), '00010', 'Address10');


-- store_detailsテーブルのテストデータ
INSERT INTO store_details (store_id, user_id)
VALUES 
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 8),
(9, 9),
(10, 10);


-- couponsテーブルのテストデータ
INSERT INTO coupons (coupon_name, coupon_image, start_date, end_date, store_id) VALUES
('Coupon 1', 'img/coupon/default_coupon.png', '2023-01-01', '2023-01-31', 1),
('Coupon 2', 'img/coupon/default_coupon.png', '2023-02-01', '2023-02-28', 2),
('Coupon 3', 'img/coupon/default_coupon.png', '2023-03-01', '2023-03-31', 3),
('Coupon 4', 'img/coupon/default_coupon.png', '2023-04-01', '2023-04-30', 4),
('Coupon 5', 'img/coupon/default_coupon.png', '2023-05-01', '2023-05-31', 5),
('Coupon 6', 'img/coupon/default_coupon.png', '2023-06-01', '2023-06-30', 6),
('Coupon 7', 'img/coupon/default_coupon.png', '2023-07-01', '2023-07-31', 7),
('Coupon 8', 'img/coupon/default_coupon.png', '2023-08-01', '2023-08-31', 8),
('Coupon 9', 'img/coupon/default_coupon.png', '2023-09-01', '2023-09-30', 9),
('Coupon 10', 'img/coupon/default_coupon.png', '2023-10-01', '2023-10-31', 10);

-- encountersテーブルのテストデータ
INSERT INTO encounters (user1_id, user2_id, encounter_date, location)
VALUES
(1, 2, '2023-01-01 12:00:00', ST_GeomFromText('POINT(0 0)', 4326)),
(3, 4, '2023-02-01 13:00:00', ST_GeomFromText('POINT(0 0)', 4326)),
(5, 6, '2023-03-01 14:00:00', ST_GeomFromText('POINT(0 0)', 4326)),
(7, 8, '2023-04-01 15:00:00', ST_GeomFromText('POINT(0 0)', 4326)),
(9,10, '2023-05-01 16:00:00', ST_GeomFromText('POINT(0 0)', 4326)),
(2, 3, '2023-06-01 17:00:00', ST_GeomFromText('POINT(0 0)', 4326)),
(4, 5, '2023-07-01 18:00:00', ST_GeomFromText('POINT(0 0)', 4326)),
(6, 7, '2023-08-01 19:00:00', ST_GeomFromText('POINT(0 0)', 4326)),
(8, 9, '2023-09-01 20:00:00', ST_GeomFromText('POINT(0 0)', 4326)),
(10,1, '2023-10-01 21:00:00', ST_GeomFromText('POINT(0 0)', 4326));

