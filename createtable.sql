CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    nickname VARCHAR(255),
    email_address VARCHAR(255),
    password VARCHAR(255),
    user_flag BOOLEAN,
    icon BYTEA,
    location_info GEOMETRY,
    history JSONB,
    auth_id INTEGER,
    FOREIGN KEY (auth_id) REFERENCES auth_users(id)
);

CREATE TABLE messages (
    message_id SERIAL PRIMARY KEY,
    address VARCHAR(255),
    message_text TEXT,
    recommended_place VARCHAR(255),
    location_info GEOMETRY,
    attributes JSONB,
    post_date TIMESTAMP,
    posting_user INTEGER,
    FOREIGN KEY (posting_user) REFERENCES users(user_id)
);

CREATE TABLE favorites (
    message_id INTEGER,
    user_id INTEGER,
    registration_date TIMESTAMP,
    PRIMARY KEY (message_id, user_id),
    FOREIGN KEY (message_id) REFERENCES messages(message_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE bookmarks (
    message_id INTEGER,
    user_id INTEGER,
    registration_date TIMESTAMP,
    PRIMARY KEY (message_id, user_id),
    FOREIGN KEY (message_id) REFERENCES messages(message_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);



CREATE TABLE stores (
    store_id SERIAL PRIMARY KEY,
    store_name VARCHAR(255),
    location_info GEOMETRY,
    postal_code VARCHAR(10),
    address VARCHAR(255)
);

CREATE TABLE store_details (
    store_id INTEGER,
    user_id INTEGER,
    PRIMARY KEY (store_id, user_id),
    FOREIGN KEY (store_id) REFERENCES stores(store_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE coupons (
    coupon_id SERIAL PRIMARY KEY,
    coupon_name VARCHAR(255),
    coupon_image BYTEA,
    start_date TIMESTAMP,
    end_date TIMESTAMP,
    store_id INTEGER,
    FOREIGN KEY (store_id) REFERENCES stores(store_id)
);

CREATE TABLE encounters (
    encounter_id SERIAL PRIMARY KEY,
    user1_id INTEGER,
    user2_id INTEGER,
    encounter_date TIMESTAMP,
    location_info GEOMETRY,
    FOREIGN KEY (user1_id) REFERENCES users(user_id),
    FOREIGN KEY (user2_id) REFERENCES users(user_id)
);