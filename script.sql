/* Utils */
DROP DATABASE pizzaria;
CREATE DATABASE pizzaria WITH OWNER admin;

/* Database creation */
CREATE TABLE Users (
    id serial PRIMARY KEY,
    username text NOT NULL UNIQUE,
    password text NOT NULL,
    phone_number text DEFAULT(NULL),
    birthday date DEFAULT(NULL)
);

INSERT INTO Users(username, password, phone_number, birthday)
    VALUES ('Anton', '12345', '+375298689745', '2003-02-26'),
           ('Dima', '12345', '+375298689746', '2003-02-26');

/* get_users */
CREATE OR REPLACE FUNCTION get_users()
    RETURNS SETOF Users AS $$
BEGIN
    RETURN QUERY SELECT * FROM Users;
END;
$$ LANGUAGE plpgsql;


/* add_user */
CREATE OR REPLACE PROCEDURE add_user(
    IN p_username VARCHAR,
    IN p_password VARCHAR,
    IN p_phone_number VARCHAR,
    IN p_birthday DATE
)
    LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO Users (username, password, phone_number, birthday)
        VALUES (p_username, p_password, p_phone_number, p_birthday);
END;
$$;

/* get_user_by_username_and_password */
CREATE OR REPLACE FUNCTION get_user_by_username_and_password(name_in text, password_in text)
    RETURNS json
AS $$
DECLARE
    result_row record;
BEGIN
    SELECT * INTO result_row FROM users WHERE username = name_in AND password = password_in LIMIT 1;
    IF found THEN
        RETURN json_build_object(
                'id', result_row.id,
                'username', result_row.username,
                'password', result_row.password,
                'phone_number', result_row.phone_number,
                'birthday', result_row.birthday
            );
    ELSE
        RETURN NULL;
    END IF;
END;
$$ LANGUAGE plpgsql;

SELECT get_user_by_username_and_password('Anton', '12345')