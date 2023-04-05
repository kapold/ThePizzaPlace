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
            const { rows } = await this.pool.query('SELECT * FROM get_users()');
            return rows;
        } catch (error) {
            console.error(error);
            throw new Error('Error fetching users');
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
        } catch (e) {
            console.error('Error adding user to database', e);
            await this.pool.query('ROLLBACK');
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
}

module.exports = DatabaseApi;
