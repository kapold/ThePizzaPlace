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
            res.writeHead(500, { 'Content-Type': 'text/plain' });
            res.end('Error loading page');
        } else {
            res.writeHead(200, { 'Content-Type': 'text/html' });
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
        const { username, password, phoneNumber, birthday } = req.body;

        res.status(201).json({ message: 'User added!' });
    } catch (error) {
        console.error(error);
        res.status(500).send('Error fetching users');
    }
});


/* LISTEN */
app.listen(port, () => {
    console.log(`Server listening on port http://localhost:${port}`);
});