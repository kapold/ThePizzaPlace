/* Utils */
DROP DATABASE pizzaria;
CREATE DATABASE pizzaria WITH OWNER admin;

/* Database creation */
CREATE TABLE Users (
    id serial PRIMARY KEY,
    username text NOT NULL UNIQUE,
    password text NOT NULL,
    phone_number text UNIQUE,
    birthday date
);

INSERT INTO Users(username, password, phone_number, birthday)
    VALUES ('Anton', '12345', '+375298689745', '2003-02-26'),
           ('Dima', '12345', '+375298689746', '2003-02-26');


CREATE OR REPLACE FUNCTION get_users()
    RETURNS SETOF Users AS $$
BEGIN
    RETURN QUERY SELECT * FROM Users;
END;
$$ LANGUAGE plpgsql;


