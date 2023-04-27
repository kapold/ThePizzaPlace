const postgres = require('pg');

class DatabaseApi {
    constructor() {
        this.pool = new postgres.Pool({
            user: 'admin',
            host: 'localhost',
            database: 'pizzaria',
            password: 'admin',
            port: 5432,
        });
    }

    async getUsers() {
        try {
            const {rows} = await this.pool.query('SELECT * FROM get_users()');
            return rows;
        } catch (error) {
            console.error(error);
            throw new Error('Error fetching users');
        }
    }

    async getPizzas() {
        try {
            const {rows} = await this.pool.query('SELECT * FROM get_pizzas()');
            return rows;
        } catch (error) {
            console.error(error);
            throw new Error('Error fetching pizzas');
        }
    }

    async addUser(username, password, phoneNumber, birthday) {
        try {
            await this.pool.query('BEGIN');

            const queryText = 'CALL add_user($1, $2, $3, $4)';
            const values = [username, password, phoneNumber, birthday];
            await this.pool.query(queryText, values);

            await this.pool.query('COMMIT');
            console.log('Successfully added user to database');
            return true;
        } catch (e) {
            console.error('Error adding user to database', e);
            await this.pool.query('ROLLBACK');
            return false;
        }
    }

    async addAddress(user_id, address) {
        try {
            await this.pool.query('BEGIN');
            await this.pool.query(`SELECT add_address($1, $2)`, [user_id, address]);
            await this.pool.query('COMMIT');
            console.log('Successfully added address to database');
            return true;
        } catch (e) {
            console.error('Error adding user to database', e);
            await this.pool.query('ROLLBACK');
            return false;
        }
    }


    async updateUser(id, username, phoneNumber, birthday) {
        try {
            const queryText = 'SELECT update_user($1, $2, $3, $4)';
            const values = [id, username, phoneNumber, birthday];
            await this.pool.query(queryText, values);

            console.log('Successfully updated user to database');
            return true;
        } catch (e) {
            console.error('Error updating user to database', e);
             await this.pool.query('ROLLBACK');
            return false;
        }
    }

    async getUserByUsernameAndPassword(username, password) {
        const query = {
            text: 'SELECT get_user_by_username_and_password($1, $2)',
            values: [username, password],
        };
        const result = await this.pool.query(query);
        return result.rows[0];
    }

    async getUserAddresses(userId) {
        try {
            const { rows } = await this.pool.query('SELECT * FROM get_user_addresses($1)', [userId]);
            return rows;
        } catch (error) {
            console.error(error);
            throw new Error('Error fetching user addresses');
        }
    }

    async deleteAddress(addressID) {
        try {
            await this.pool.query('SELECT delete_address($1)', [addressID]);
        } catch (e) {
            throw e;
        }
    }
}

module.exports = DatabaseApi;
