-- Enable PostGIS extension
CREATE EXTENSION IF NOT EXISTS postgis;

-- Users Table
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    nickname VARCHAR(255) NOT NULL,
    user_flag BOOLEAN NOT NULL DEFAULT false,
    icon TEXT NOT NULL DEFAULT 'img/user/default.png',
    location GEOMETRY(Point, 4326) NOT NULL,
    auth_id UUID REFERENCES auth.users (id) ON DELETE CASCADE,
    -- error_count INTEGER NOT NULL DEFAULT 0,
    -- last_error_timestamp TIMESTAMP,
    -- notification_frequency INTEGER NOT NULL,
    FOREIGN KEY (auth_id) REFERENCES auth.users(id)
);

-- Messages Table
CREATE TABLE messages (
    message_id SERIAL PRIMARY KEY,
    address VARCHAR(255),
    message_text TEXT,
    recommended_place VARCHAR(255),
    location GEOMETRY,
    category VARCHAR(50),
    post_timestamp TIMESTAMP,
    user_id INTEGER,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Favorites Table
CREATE TABLE favorites (
    message_id INTEGER,
    user_id INTEGER,
    registration_date TIMESTAMP,
    PRIMARY KEY (message_id, user_id),
    FOREIGN KEY (message_id) REFERENCES messages(message_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Bookmarks Table
CREATE TABLE bookmarks (
    message_id INTEGER,
    user_id INTEGER,
    registration_date TIMESTAMP,
    PRIMARY KEY (message_id, user_id),
    FOREIGN KEY (message_id) REFERENCES messages(message_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Stores Table
CREATE TABLE stores (
    store_id SERIAL PRIMARY KEY,
    store_name VARCHAR(255),
    location GEOMETRY,
    postal_code VARCHAR(10),
    address VARCHAR(255)
);

-- Store Details Table
CREATE TABLE store_details (
    store_id INTEGER,
    user_id INTEGER,
    PRIMARY KEY (store_id, user_id),
    FOREIGN KEY (store_id) REFERENCES stores(store_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Coupons Table
CREATE TABLE coupons (
    coupon_id SERIAL PRIMARY KEY,
    coupon_name VARCHAR(255) NOT NULL,
    coupon_image TEXT NOT NULL DEFAULT 'img/coupon/default.png',
    start_date TIMESTAMP NOT NULL,
    end_date TIMESTAMP NOT NULL,
    store_id INTEGER,
    FOREIGN KEY (store_id) REFERENCES stores(store_id)
);

-- Encounters Table
CREATE TABLE encounters (
    encounter_id SERIAL PRIMARY KEY,
    user1_id INTEGER,
    user2_id INTEGER,
    encounter_date TIMESTAMP,
    location GEOMETRY,
    FOREIGN KEY (user1_id) REFERENCES users(user_id),
    FOREIGN KEY (user2_id) REFERENCES users(user_id)
);
