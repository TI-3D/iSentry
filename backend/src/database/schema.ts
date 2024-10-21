import { createId } from "@paralleldrive/cuid2";
import { mysqlTable, timestamp, varchar } from "drizzle-orm/mysql-core";

export const user = mysqlTable('user', {
  id: varchar('id').$defaultFn(() => createId()),
  username: varchar('username').notNull().unique(),
  password: varchar('password').notNull(),
  salt: varchar('salt', { length: 64 }).notNull(),
  createdAt: timestamp('created_at').defaultNow().notNull()
});

export const table = {
  user
} as const;

export type Table = typeof table
