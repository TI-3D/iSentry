import mysql from "mysql2/promise";
import { drizzle, MySql2Database } from "drizzle-orm/mysql2";

let dbInstance: MySql2Database | null = null;

async function connect() {
    if (!dbInstance) {
        try {
            const connection = await mysql.createConnection({
                host: process.env.DATABASE_HOST,
                port: Number(process.env.DATABASE_PORT),
                user: process.env.DATABASE_USER,
                password: process.env.DATABASE_PASS,
            });
            dbInstance = drizzle({ client: connection });
        } catch (error) {
            console.error("Error connecting to the database:", error);
            throw error;
        }
    }
    return dbInstance;
}

export { connect };
