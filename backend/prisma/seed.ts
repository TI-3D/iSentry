import { PrismaClient } from "@prisma/client";

const prisma = new PrismaClient();

async function main() {
    // turn off foreign key checks
    await prisma.$executeRawUnsafe(`SET FOREIGN_KEY_CHECKS = 0;`);

    // truncate table
    await prisma.$executeRawUnsafe(`TRUNCATE TABLE galleryitems;`);
    await prisma.$executeRawUnsafe(`TRUNCATE TABLE detectionlogs;`);
    await prisma.$executeRawUnsafe(`TRUNCATE TABLE systemlogs;`);
    await prisma.$executeRawUnsafe(`TRUNCATE TABLE identities;`);
    await prisma.$executeRawUnsafe(`TRUNCATE TABLE faces;`);
    await prisma.$executeRawUnsafe(`TRUNCATE TABLE users;`);

    // turn on foreign key checks
    await prisma.$executeRawUnsafe(`SET FOREIGN_KEY_CHECKS = 1;`);

    // user
    const user1 = await prisma.user.create({
        data: {
            name: "Budi",
            email: "budi@gmail.com",
            password: "12345678",
            role: "OWNER",
        },
    });
    const user2 = await prisma.user.create({
        data: {
            name: "Joko",
            email: "joko@gmail.com",
            password: "12345678",
            role: "RESIDENT",
        },
    });

    // system log
    const systemLog1 = await prisma.system_Log.create({
        data: {
            message: "user1 created",
        },
    });
    const systemLog2 = await prisma.system_Log.create({
        data: {
            message: "user2 created",
        },
    });

    // identity
    const identity1 = await prisma.identity.create({
        data: {
            name: "Yoan",
        },
    });
    const identity2 = await prisma.identity.create({
        data: {
            name: "Joko",
        },
    });

    // gallery item
    const galleryItem1 = await prisma.gallery_Item.create({
        data: {
            capture_method: "AUTO",
            type: "VIDEO",
            path: "http://example.com/video1.mp4",
        },
    });
    const galleryItem2 = await prisma.gallery_Item.create({
        data: {
            capture_method: "MANUAL",
            type: "PICTURE",
            path: "http://example.com/picture1.jpg",
        },
    });

    // face
    const face1 = await prisma.face.create({
        data: {
            identity: identity1.id,
            landmarks: Buffer.from([0, 1, 2, 3, 4, 5, 255]),
            picture_full: galleryItem1.id,
            picture_single: galleryItem2.id,
            bounding_box: Buffer.from([0, 1, 2, 3, 4, 5, 255]),
        },
    });
    const face2 = await prisma.face.create({
        data: {
            identity: identity2.id,
            landmarks: Buffer.from([0, 1, 2, 3, 4, 5, 255]),
            picture_full: galleryItem2.id,
            picture_single: galleryItem1.id,
            bounding_box: Buffer.from([0, 1, 2, 3, 4, 5, 255]),
        },
    });

    // detection_log
    const detectionLog1 = await prisma.detection_Log.create({
        data: {
            face: face1.id,
        },
    });
    const detectionLog2 = await prisma.detection_Log.create({
        data: {
            face: face2.id,
        },
    });

    console.log("Data seeded successfully!");
}

main()
    .catch((e) => {
        console.error(e);
        process.exit(1);
    })
    .finally(async () => {
        await prisma.$disconnect();
    });
