const express = require('express');
const crypto = require('crypto');
const cors = require('cors');
const bodyParser = require('body-parser');
const fs = require('fs');
const DatabaseApi = require('./DatabaseApi');
const app = express();
const db = new DatabaseApi();
const port = 3000;

app.use(bodyParser.json());
app.use(cors({ origin: '*' }));

/* GET */
app.get('/', (req, res) => {
    fs.readFile('hello.html', (err, data) => {
        if (err) {
            res.writeHead(500, {'Content-Type': 'text/plain'});
            res.end('Error loading page');
        } else {
            res.writeHead(200, {'Content-Type': 'text/html'});
            res.end(data);
        }
    });
});

app.get('/users', async (req, res) => {
    try {
        const rows = await db.getUsers();
        res.send(rows);
    } catch (error) {
        console.error(error);
        res.status(500).send('Error fetching users');
    }
});

app.get('/pizzas', async (req, res) => {
    try {
        const rows = await db.getPizzas();
        res.send(rows);
    } catch (error) {
        console.error(error);
        res.status(500).send('Error fetching pizzas');
    }
});

app.get('/addresses/:user_id', async (req, res) => {
    const userId = req.params.user_id;
    try {
        const rows = await db.getUserAddresses(userId);
        res.send(rows);
    } catch (error) {
        console.error(error);
        res.status(500).send('Error fetching user addresses');
    }
});

app.get('/orders', async (req, res) => {
    const { user_id, status } = req.query;
    try {
        const rows = await db.getUserOrders(user_id, status);
        res.send(rows);
    } catch (error) {
        console.error(error);
        res.status(500).send('Error fetching user orders');
    }
});

app.get('/all_orders', async (req, res) => {
    const { status } = req.query;
    try {
        const rows = await db.getOrders(status);
        res.send(rows);
    } catch (error) {
        console.error(error);
        res.status(500).send('Error fetching all orders');
    }
});

app.get('/order_details', async (req, res) => {
    const { order_id } = req.query;
    try {
        const rows = await db.getOrderItems(order_id);
        res.send(rows);
    } catch (error) {
        console.error(error);
        res.status(500).send('Error fetching order items');
    }
});

app.get('/all_order_details', async (req, res) => {
    try {
        const rows = await db.getAllOrderItems();
        res.send(rows);
    } catch (error) {
        console.error(error);
        res.status(500).send('Error fetching ALL order items');
    }
});

app.get('/pizza_details', async (req, res) => {
    try {
        const rows = await db.getPizzaDetails();
        res.send(rows);
    } catch (error) {
        console.error(error);
        res.status(500).send('Error fetching pizza details');
    }
});


/* POST */
app.post('/users', async (req, res) => {
    try {
        const {username, password, phone_number, birthday} = req.body;
        const passwordHash = crypto.createHash('sha256').update(password).digest('hex');
        const result = await db.addUser(username, passwordHash, phone_number, birthday);

        if (result) {
            res.status(201).send('User added successfully');
            console.log('User added successfully 201')
        } else {
            res.status(500).send('Error adding user');
            console.log('Error adding user 500')
        }
    } catch (error) {
        console.error(error);
        res.status(500).send('Error adding user');
    }
});

app.post('/addresses', async (req, res) => {
    try {
        const {user_id, address} = req.body;
        const result = await db.addAddress(user_id, address);

        if (result) {
            res.status(201).send('Address added successfully');
            console.log('Address added successfully 201')
        } else {
            res.status(500).send('Error adding Address');
            console.log('Error adding Address 500')
        }
    } catch (error) {
        console.error(error);
        res.status(500).send('Error adding Address');
    }
});

app.post('/login', async (req, res) => {
    const {username, password} = req.body;
    const passwordHash = crypto.createHash('sha256').update(password).digest('hex');
    const user = await db.getUserByUsernameAndPassword(username, passwordHash);
    if (user) {
        res.json(user.get_user_by_username_and_password);
    } else {
        res.status(401).json({message: 'Invalid credentials'});
    }
});

app.post('/orders', async (req, res) => {
    const { user_id, delivery_id, status } = req.body;

    try {
        const order = await db.addOrder(user_id, delivery_id, status);
        res.status(200).json(order);
    }
    catch (e) {
        res.status(200).json({message: e});
    }
});

app.post('/pizzas', async (req, res) => {
    const { name, description, price, image } = req.body;
    try {
        await db.addPizza(name, description, price, image);
        res.status(200).json("OK");
    }
    catch (e) {
        res.status(200).json({message: e});
    }
});

app.post('/order_details', async (req, res) => {
    const { order_id, pizza_details_id, quantity, product_id } = req.body;

    try {
        await db.addOrderDetails(order_id, pizza_details_id, quantity, product_id);
        res.status(200);
    }
    catch (e) {
        res.status(200).json({message: e});
    }
});

/* PUT */
app.put('/users', async (req, res) => {
    try {
        const {id, username, phone_number, birthday} = req.body;
        const result = await db.updateUser(id, username, phone_number, birthday);

        if (result) {
            res.status(201).send('User updated successfully');
            console.log('User updated successfully 201')
        } else {
            res.status(500).send('Error updating user');
            console.log('Error updating user 500')
        }
    } catch (error) {
        console.error(error);
        res.status(500).send('Error updating user');
    }
});

app.put('/orders', async (req, res) => {
    try {
        const {order_id, status} = req.body;
        const result = await db.updateOrderStatus(order_id, status);

        if (result) {
            res.status(201);
            console.log('Status updated 201')
        } else {
            res.status(500);
            console.log('Error updating status 500')
        }
    } catch (error) {
        console.error(error);
        res.status(500).send('Error updating status');
    }
});

/* DELETE */
app.delete('/addresses/:id', async (req, res) => {
    const address_id = req.params.id;
    console.log("Address id: " + address_id);
    try {
        await db.deleteAddress(address_id);
        res.sendStatus(201);
    } catch (e) {
        console.error(e);
        res.sendStatus(500);
    }
});

app.delete('/pizzas/:id', async (req, res) => {
    const pizza_id = req.params.id;
    console.log("Pizza id: " + pizza_id);
    try {
        await db.deletePizza(pizza_id);
        res.sendStatus(201);
    } catch (e) {
        console.error(e);
        res.sendStatus(500);
    }
});

/* LISTEN */
app.listen(port, () => {
    console.log(`Server listening on port http://localhost:${port}`);
});