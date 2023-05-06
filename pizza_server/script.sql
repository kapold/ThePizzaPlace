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
    cheese text NOT NULL
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
    VALUES ('customer'), ('deliveryman'), ('admin');
INSERT INTO Pizzas(name, description, price, image)
    VALUES ('Маргарита', 'Бекон, сыры чеддер и пармезан, моцарелла, томаты, соус альфредо, красный лук, чеснок, итальянские травы', 17.90, 'none'),
           ('Аррива', 'Цыпленок, чоризо, соус бургер, томаты, сладкий перец, лук красный, чеснок, моцарелла, соус ранч', 17.90, 'none'),
           ('Дон бекон', 'Томатный соус, цыпленок филе, пикантная пепперони, красный лук, моцарелла, бекон', 20.90, 'none');
INSERT INTO PizzaDetails(size, dough, cheese)
VALUES
    ('25 см', 'Тонкое', 'Без сыра'),
    ('25 см', 'Тонкое', 'С сыром'),
    ('25 см', 'Традиционное', 'Без сыра'),
    ('25 см', 'Традиционное', 'С сыром'),
    ('30 см', 'Тонкое', 'Без сыра'),
    ('30 см', 'Тонкое', 'С сыром'),
    ('30 см', 'Традиционное', 'Без сыра'),
    ('30 см', 'Традиционное', 'С сыром'),
    ('35 см', 'Тонкое', 'Без сыра'),
    ('35 см', 'Тонкое', 'С сыром'),
    ('35 см', 'Традиционное', 'Без сыра'),
    ('35 см', 'Традиционное', 'С сыром');

/* get_users */
CREATE OR REPLACE FUNCTION get_users()
    RETURNS SETOF Users AS $$
BEGIN
    RETURN QUERY SELECT * FROM Users;
END;
$$ LANGUAGE plpgsql;

/* get_pizza_details */
CREATE OR REPLACE FUNCTION get_pizza_details()
    RETURNS SETOF PizzaDetails AS $$
BEGIN
    RETURN QUERY SELECT * FROM PizzaDetails;
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

/* get_user_orders */
CREATE FUNCTION get_user_orders(user_id INTEGER, status TEXT)
    RETURNS SETOF Orders AS $$
BEGIN
    RETURN QUERY SELECT * FROM Orders WHERE Orders.user_id = $1 AND Orders.status = $2;
END;
$$ LANGUAGE plpgsql;
SELECT * FROM get_user_orders(2, 'in progress');

/* get_order_items */
CREATE FUNCTION get_order_items(order_id INTEGER)
    RETURNS SETOF OrderDetails AS $$
BEGIN
    RETURN QUERY SELECT * FROM OrderDetails WHERE OrderDetails.order_id = $1;
END;
$$ LANGUAGE plpgsql;
SELECT * FROM get_order_items(18);

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

/* add_pizza */
CREATE OR REPLACE FUNCTION add_pizza(n_name text, n_description text, n_price numeric(8, 2), n_image text)
    RETURNS void AS $$
BEGIN
    INSERT INTO Pizzas(name, description, price, image) VALUES (n_name, n_description, n_price, n_image);
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
                'role_id', result_row.role_id,
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

/* get_user_by_username */
CREATE OR REPLACE FUNCTION get_user_by_username(name_in text)
    RETURNS json
AS $$
DECLARE
    result_row record;
BEGIN
    SELECT * INTO result_row FROM users WHERE username = name_in LIMIT 1;
    IF found THEN
        RETURN json_build_object(
                'id', result_row.id,
                'role_id', result_row.role_id,
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

/* create_order */
CREATE OR REPLACE FUNCTION create_order(n_user_id INT, n_delivery_id INT, n_status TEXT)
    RETURNS INT AS $$
    DECLARE
        returned_id INT;
BEGIN
    INSERT INTO Orders (user_id, delivery_id, created_at, status)
        VALUES (n_user_id, n_delivery_id, NOW(), n_status)
    RETURNING Orders.id INTO returned_id;
    RETURN returned_id;
END;
$$ LANGUAGE plpgsql;
/*SELECT create_order(2, 4, 'in progress');*/

/* create_order_details */
CREATE OR REPLACE FUNCTION create_order_details(n_order_id INT, n_pizza_details_id INT, n_quantity INT, n_product_id INT)
    RETURNS VOID AS $$
BEGIN
    INSERT INTO OrderDetails (order_id, product_id, pizza_details_id, quantity)
        VALUES (n_order_id, n_product_id, n_pizza_details_id, n_quantity);
END;
$$ LANGUAGE plpgsql;

/* delete_address */
CREATE OR REPLACE FUNCTION delete_address(address_id integer)
    RETURNS void AS $$
BEGIN
    DELETE FROM DeliveryAddresses WHERE id = address_id;
END;
$$ LANGUAGE plpgsql;

/* delete_address */
CREATE OR REPLACE FUNCTION delete_pizza(pizza_id integer)
    RETURNS void AS $$
BEGIN
    DELETE FROM Pizzas WHERE id = pizza_id;
END;
$$ LANGUAGE plpgsql;

SELECT get_user_by_username_and_password('Anton', '12345');
/*CALL update_user(1, 'new_username', 'new_phone_number', '2000-01-01');*/