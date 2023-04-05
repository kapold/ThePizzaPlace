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

    async addUser() {
        try {
            await this.pool.query('SELECT * FROM get_users()');
        } catch (error) {
            console.error(error);
            throw new Error('Error fetching users');
        }
    }

    // async getProducts() {
    //     try {
    //         const { rows } = await this.pool.query('SELECT * FROM get_products()');
    //         return rows;
    //     } catch (error) {
    //         console.error(error);
    //         throw new Error('Error fetching users');
    //     }
    // }
}

module.exports = DatabaseApi;
