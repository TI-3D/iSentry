//import prisma client
import prisma from "../../prisma/client";

/**
 * Getting all system log
 */
export async function getSystemLogs() {
    try {
        //get all system log
        const systemLogs = await prisma.system_Log.findMany({
            orderBy: { id: "asc" },
        });

        //return response json
        return {
            success: true,
            message: "List Data System Log!",
            data: systemLogs,
        };
    } catch (e: unknown) {
        console.error(`Error getting system log: ${e}`);
    }
}

/**
 * Creating a system log
 */
export async function createSystemLog(options: { message: string }) {
    try {
        const systemLogs = await prisma.system_Log.create({
            data: {
                message: options.message,
            },
        });
        return {
            success: true,
            message: "System Log Created Successfully!",
            data: systemLogs,
        };
    } catch (e: unknown) {
        console.error(`Error creating system log: ${e}`);
    }
}

/**
 * Getting a system log by ID
 */
export async function getSystemLogById(id: string) {
    try {
        const systemLogId = parseInt(id);
        const systemLogs = await prisma.system_Log.findUnique({
            where: { id: systemLogId },
        });

        if (!systemLogs) {
            return {
                success: false,
                message: "System Log Not Found!",
                data: null,
            };
        }

        return {
            success: true,
            message: `System Log Details for ID: ${id}`,
            data: systemLogs,
        };
    } catch (e: unknown) {
        console.error(`Error getting system log: ${e}`);
        return { success: false, message: "Internal Server Error" };
    }
}

/**
 * Updating a system log
 */
export async function updateSystemLog(
    id: string,
    options: {
        message?: string;
    }
) {
    try {
        const systemLogId = parseInt(id);
        const { message } = options;

        const systemLogs = await prisma.system_Log.update({
            where: { id: systemLogId },
            data: {
                ...(message ? { message } : {}),
            },
        });

        return {
            success: true,
            message: "System Log Updated Successfully!",
            data: systemLogs,
        };
    } catch (e: unknown) {
        console.error(`Error updating identity: ${e}`);
    }
}

/**
 * Deleting a system log
 */
export async function deleteSystemLog(id: string) {
    try {
        const systemLogId = parseInt(id);
        await prisma.system_Log.delete({ where: { id: systemLogId } });

        return {
            success: true,
            message: "System Log Deleted Successfully!",
        };
    } catch (e: unknown) {
        console.error(`Error deleting System Log: ${e}`);
    }
}
