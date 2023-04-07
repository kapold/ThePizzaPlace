const express = require('express');
const bodyParser = require('body-parser');
const fs = require('fs');
const DatabaseApi = require('./DatabaseApi');
const app = express();
const db = new DatabaseApi();
const port = 3000;
app.use(bodyParser.json());

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


/* POST */
app.post('/users', async (req, res) => {
    try {
        const {username, password, phoneNumber, birthday} = req.body;
        const result = await db.addUser(username, password, phoneNumber, birthday);

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


app.post('/login', async (req, res) => {
    const {username, password} = req.body;
    const user = await db.getUserByUsernameAndPassword(username, password);
    if (user) {
        res.json(user.get_user_by_username_and_password);
    } else {
        res.status(401).json({message: 'Invalid credentials'});
    }
});


/* LISTEN */
app.listen(port, () => {
    console.log(`Server listening on port http://localhost:${port}`);
});