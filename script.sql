/* Utils */
DROP DATABASE pizzaria;
CREATE DATABASE pizzaria WITH OWNER admin;
DROP TABLE Users;

/* Database creation */
CREATE TABLE Roles (
    id serial PRIMARY KEY,
    name text
);

CREATE TABLE Users (
    id serial PRIMARY KEY,
    role_id integer NOT NULL REFERENCES Roles(id),
    username text NOT NULL UNIQUE,
    password text NOT NULL,
    phone_number text DEFAULT(NULL),
    birthday date DEFAULT(NULL)
);

CREATE TABLE DeliveryAddresses (
    id serial PRIMARY KEY,
    user_id integer NOT NULL REFERENCES Users(id),
    address text NOT NULL
);


CREATE TABLE Pizzas (
    id serial PRIMARY KEY,
    name text NOT NULL UNIQUE,
    description text,
    price numeric(8,2) NOT NULL,
    image text
);


CREATE TABLE Orders (
    id serial PRIMARY KEY,
    user_id integer NOT NULL REFERENCES Users(id),
    delivery_id integer NOT NULL REFERENCES DeliveryAddresses(id),
    created_at timestamp NOT NULL,
    status text NOT NULL
);

CREATE TABLE PizzaDetails (
    id serial PRIMARY KEY,
    size text NOT NULL,
    dough text NOT NULL,
    add_cost numeric(8,2) NOT NULL
);

CREATE TABLE OrderDetails (
    id serial PRIMARY KEY,
    order_id integer NOT NULL REFERENCES Orders(id),
    product_id integer NOT NULL REFERENCES Pizzas(id),
    pizza_details_id integer NOT NULL REFERENCES PizzaDetails(id),
    quantity integer NOT NULL DEFAULT(1)
);

/* INSERTS */
INSERT INTO Roles(name)
    VALUES ('customer'), ('seller');
INSERT INTO Users(role_id, username, password, phone_number, birthday)
    VALUES (1, 'Anton', '12345', '+375298689745', '2003-02-26'),
           (1, 'Dima', '12345', '+375298689746', '2003-02-26');
INSERT INTO Pizzas(name, description, price, image)
    VALUES ('Маргарита', 'Бекон, сыры чеддер и пармезан, моцарелла, томаты, соус альфредо, красный лук, чеснок, итальянские травы', 17.90, 'none'),
           ('Аррива', 'Цыпленок, чоризо, соус бургер, томаты, сладкий перец, лук красный, чеснок, моцарелла, соус ранч', 17.90, 'none'),
           ('Дон бекон', 'Томатный соус, цыпленок филе, пикантная пепперони, красный лук, моцарелла, бекон', 20.90, 'none');

/* get_users */
CREATE OR REPLACE FUNCTION get_users()
    RETURNS SETOF Users AS $$
BEGIN
    RETURN QUERY SELECT * FROM Users;
END;
$$ LANGUAGE plpgsql;

/* get_pizzas */
CREATE OR REPLACE FUNCTION get_pizzas()
    RETURNS SETOF Pizzas AS $$
BEGIN
    RETURN QUERY SELECT * FROM Pizzas;
END;
$$ LANGUAGE plpgsql;

/* get_user_addresses */
CREATE FUNCTION get_user_addresses(user_id INTEGER)
    RETURNS SETOF DeliveryAddresses AS $$
BEGIN
    RETURN QUERY SELECT * FROM DeliveryAddresses WHERE DeliveryAddresses.user_id = $1;
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
    INSERT INTO Users (role_id, username, password, phone_number, birthday)
        VALUES (1, p_username, p_password, p_phone_number, p_birthday);
END;
$$;

/* add_address */
CREATE OR REPLACE FUNCTION add_address(new_user_id integer, new_address text)
    RETURNS void AS $$
BEGIN
    INSERT INTO DeliveryAddresses(user_id, address) VALUES (new_user_id, new_address);
END;
$$ LANGUAGE plpgsql;

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

/* update_user */
CREATE OR REPLACE FUNCTION update_user(
    user_id INTEGER,
    new_username VARCHAR,
    new_phone_number VARCHAR,
    new_birthday DATE
) RETURNS VOID AS $$
BEGIN
UPDATE users SET
                 username = new_username,
                 phone_number = new_phone_number,
                 birthday = new_birthday
WHERE id = user_id;
END;
$$ LANGUAGE plpgsql;

/* delete_address */
CREATE OR REPLACE FUNCTION delete_address(address_id integer)
    RETURNS void AS $$
BEGIN
    DELETE FROM DeliveryAddresses WHERE id = address_id;
END;
$$ LANGUAGE plpgsql;

SELECT get_user_by_username_and_password('Anton', '12345');
/*CALL update_user(1, 'new_username', 'new_phone_number', '2000-01-01');*/