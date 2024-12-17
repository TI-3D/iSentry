import { PrismaClient } from "@prisma/client";
import { faker } from "@faker-js/faker";

const prisma = new PrismaClient();

async function main() {
    // turn off foreign key checks
    await prisma.$executeRawUnsafe(`SET FOREIGN_KEY_CHECKS = 0;`);

    // truncate table
    await prisma.$executeRawUnsafe(`TRUNCATE TABLE medias;`);
    await prisma.$executeRawUnsafe(`TRUNCATE TABLE detectionLogs;`);
    await prisma.$executeRawUnsafe(`TRUNCATE TABLE systemLogs;`);
    await prisma.$executeRawUnsafe(`TRUNCATE TABLE identities;`);
    await prisma.$executeRawUnsafe(`TRUNCATE TABLE faces;`);
    await prisma.$executeRawUnsafe(`TRUNCATE TABLE users;`);
    await prisma.$executeRawUnsafe(`TRUNCATE TABLE tokens;`);

    // turn on foreign key checks
    await prisma.$executeRawUnsafe(`SET FOREIGN_KEY_CHECKS = 1;`);

    // identity
    const identity1 = await prisma.identity.create({
        data: {
            name: "Barack Obama",
        },
    });
    const identity2 = await prisma.identity.create({
        data: {
            name: "Dalia Grybauskaite",
        },
    });
    const identity3 = await prisma.identity.create({
        data: {
            name: "Tamim bin Hamad Al Thani",
        },
    });
    const identity4 = await prisma.identity.create({
        data: {
            name: "Gjorge Ivanov",
        },
    });
    const identity5 = await prisma.identity.create({
        data: {
            name: "Joko Widodo",
        },
    });
    const identity6 = await prisma.identity.create({
        data: {
            name: "Joe Biden",
        },
    });
    const identity7 = await prisma.identity.create({
        data: {
            name: "Xi Jinping",
        },
    });
    const identity8 = await prisma.identity.create({
        data: {
            name: "Justin Trudeau",
        },
    });
    const identity9 = await prisma.identity.create({
        data: {
            name: "Rishi Sunak",
        },
    });
    const identity10 = await prisma.identity.create({
        data: {
            name: "Giorgia Meloni",
        },
    });
    const identity11 = await prisma.identity.create({
        data: {
            name: "Alberto Fernandez",
        },
    });
    const identity12 = await prisma.identity.create({
        data: {
            name: "Anthony Albanese",
        },
    });
    const identity13 = await prisma.identity.create({
        data: {
            name: "Narendra Modi",
        },
    });
    const identity14 = await prisma.identity.create({
        data: {
            name: "Cyril Ramaphosa",
        },
    });
    const identity15 = await prisma.identity.create({
        data: {
            name: "Fumio Kishida",
        },
    });
    const identity16 = await prisma.identity.create({
        data: {
            name: "Olaf Scholz",
        },
    });
    const identity17 = await prisma.identity.create({
        data: {
            name: "Emmanuel Macron",
        },
    });
    const identity18 = await prisma.identity.create({
        data: {
            name: "Charles Michael",
        },
    });
    const identity19 = await prisma.identity.create({
        data: {
            name: "Yoon Suk-yeol",
        },
    });
    const identity20 = await prisma.identity.create({
        data: {
            name: "Ahmad Taufiq Hidayatullah",
        },
    });

    // user
    const user1 = await prisma.user.create({
        data: {
            username: "isentry",
            name: "Team OP",
            password: await Bun.password.hash("op091024"),
            identityId: null,
            role: "OWNER",
        },
    });
    const user2 = await prisma.user.create({
        data: {
            username: "grybauskaitedalia ",
            name: "Dalia Grybauskaite",
            password: await Bun.password.hash("12345678"),
            identityId: identity2.id,
            role: "RESIDENT",
            ownerId: identity1.id,
        },
    });
    const user3 = await prisma.user.create({
        data: {
            username: "hamadalthani",
            name: "Tamim bin Hamad Al Thani",
            password: await Bun.password.hash("12345678"),
            identityId: identity3.id,
            role: "RESIDENT",
            ownerId: identity1.id,
        },
    });
    const user4 = await prisma.user.create({
        data: {
            username: "ivanovgjorge",
            name: "Gjorge Ivanov",
            password: await Bun.password.hash("12345678"),
            identityId: identity4.id,
            role: "RESIDENT",
            ownerId: identity1.id,
        },
    });
    const user5 = await prisma.user.create({
        data: {
            username: "widodojoko",
            name: "Joko Widodo",
            password: await Bun.password.hash("12345678"),
            identityId: identity5.id,
            role: "RESIDENT",
            ownerId: identity1.id,
        },
    });
    const user6 = await prisma.user.create({
        data: {
            username: "bidenjoe",
            name: "Joe Biden",
            password: await Bun.password.hash("12345678"),
            identityId: identity6.id,
            role: "RESIDENT",
            ownerId: identity1.id,
        },
    });
    const user7 = await prisma.user.create({
        data: {
            username: "jinpingxi",
            name: "Xi Jinping",
            password: await Bun.password.hash("12345678"),
            identityId: identity7.id,
            role: "RESIDENT",
            ownerId: identity1.id,
        },
    });
    const user8 = await prisma.user.create({
        data: {
            username: "trudeaujustin",
            name: "Justin Trudeau",
            password: await Bun.password.hash("12345678"),
            identityId: identity8.id,
            role: "RESIDENT",
            ownerId: identity1.id,
        },
    });
    const user9 = await prisma.user.create({
        data: {
            username: "sunakrishi",
            name: "Rishi Sunak",
            password: await Bun.password.hash("12345678"),
            identityId: identity9.id,
            role: "RESIDENT",
            ownerId: identity1.id,
        },
    });
    const user10 = await prisma.user.create({
        data: {
            username: "melonigiorgia",
            name: "Giorgia Meloni",
            password: await Bun.password.hash("12345678"),
            identityId: identity10.id,
            role: "RESIDENT",
            ownerId: identity1.id,
        },
    });
    const user11 = await prisma.user.create({
        data: {
            username: "fernandezalberto",
            name: "Alberto Fernandez",
            password: await Bun.password.hash("12345678"),
            identityId: identity11.id,
            role: "RESIDENT",
            ownerId: identity1.id,
        },
    });
    const user12 = await prisma.user.create({
        data: {
            username: "albaneseanthony",
            name: "Anthony Albanese",
            password: await Bun.password.hash("12345678"),
            identityId: identity12.id,
            role: "RESIDENT",
            ownerId: identity1.id,
        },
    });
    const user13 = await prisma.user.create({
        data: {
            username: "modinarendra",
            name: "Narendra Modi",
            password: await Bun.password.hash("12345678"),
            identityId: identity13.id,
            role: "RESIDENT",
            ownerId: identity1.id,
        },
    });
    const user14 = await prisma.user.create({
        data: {
            username: "ramaphosacyril",
            name: "Cyril Ramaphosa",
            password: await Bun.password.hash("12345678"),
            identityId: identity14.id,
            role: "RESIDENT",
            ownerId: identity1.id,
        },
    });
    const user15 = await prisma.user.create({
        data: {
            username: "kishidafumio",
            name: "Fumio Kishida",
            password: await Bun.password.hash("12345678"),
            identityId: identity15.id,
            role: "RESIDENT",
            ownerId: identity1.id,
        },
    });
    const user16 = await prisma.user.create({
        data: {
            username: "scholzolaf",
            name: "Olaf Scholz",
            password: await Bun.password.hash("12345678"),
            identityId: identity16.id,
            role: "RESIDENT",
            ownerId: identity1.id,
        },
    });
    const user17 = await prisma.user.create({
        data: {
            username: "macronemmanuel",
            name: "Emmanuel Macron",
            password: await Bun.password.hash("12345678"),
            identityId: identity17.id,
            role: "RESIDENT",
            ownerId: identity1.id,
        },
    });
    const user18 = await prisma.user.create({
        data: {
            username: "michaelcharles",
            name: "Charles Michael",
            password: await Bun.password.hash("12345678"),
            identityId: identity18.id,
            role: "RESIDENT",
            ownerId: identity1.id,
        },
    });
    const user19 = await prisma.user.create({
        data: {
            username: "sukyeolyoon",
            name: "Yoon Suk-yeol",
            password: await Bun.password.hash("12345678"),
            identityId: identity19.id,
            role: "RESIDENT",
            ownerId: identity1.id,
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
    const systemLog3 = await prisma.system_Log.create({
        data: {
            message: "user3 created",
        },
    });
    const systemLog4 = await prisma.system_Log.create({
        data: {
            message: "user4 created",
        },
    });
    const systemLog5 = await prisma.system_Log.create({
        data: {
            message: "user5 created",
        },
    });
    const systemLog6 = await prisma.system_Log.create({
        data: {
            message: "user6 created",
        },
    });
    const systemLog7 = await prisma.system_Log.create({
        data: {
            message: "user7 created",
        },
    });
    const systemLog8 = await prisma.system_Log.create({
        data: {
            message: "user8 created",
        },
    });
    const systemLog9 = await prisma.system_Log.create({
        data: {
            message: "user9 created",
        },
    });
    const systemLog10 = await prisma.system_Log.create({
        data: {
            message: "user10 created",
        },
    });
    const systemLog11 = await prisma.system_Log.create({
        data: {
            message: "user11 created",
        },
    });
    const systemLog12 = await prisma.system_Log.create({
        data: {
            message: "user12 created",
        },
    });
    const systemLog13 = await prisma.system_Log.create({
        data: {
            message: "user13 created",
        },
    });
    const systemLog14 = await prisma.system_Log.create({
        data: {
            message: "user14 created",
        },
    });
    const systemLog15 = await prisma.system_Log.create({
        data: {
            message: "user15 created",
        },
    });
    const systemLog16 = await prisma.system_Log.create({
        data: {
            message: "user16 created",
        },
    });
    const systemLog17 = await prisma.system_Log.create({
        data: {
            message: "user17 created",
        },
    });
    const systemLog18 = await prisma.system_Log.create({
        data: {
            message: "user18 created",
        },
    });
    const systemLog19 = await prisma.system_Log.create({
        data: {
            message: "user19 created",
        },
    });

    // gallery item
    const homepath =
        process.env.HOME ??
        process.env.HOMEPATH ??
        process.env.USERPROFILE ??
        "";

    // gallery item
    const video1 = await prisma.media.create({
        data: {
            capture_method: "AUTO",
            type: "VIDEO",
            path: Bun.resolveSync("./isentry/medias/video1.mp4", homepath),
        },
    });
    const picturefull1 = await prisma.media.create({
        data: {
            capture_method: "AUTO",
            type: "PICTURE",
            path: Bun.resolveSync(
                "./isentry/medias/e1eedd7d-b61a-45df-af8d-8ed20910ca0e.jpg",
                homepath
            ),
        },
    });
    const picturefull2 = await prisma.media.create({
        data: {
            capture_method: "AUTO",
            type: "PICTURE",
            path: Bun.resolveSync(
                "./isentry/medias/775cb60f-d4b7-4cbd-968e-37d3d112bd0f.jpg",
                homepath
            ),
        },
    });
    const picturefull3 = await prisma.media.create({
        data: {
            capture_method: "AUTO",
            type: "PICTURE",
            path: Bun.resolveSync(
                "./isentry/medias/70ea0044-5680-444e-b7c6-3f507f39db27.jpg",
                homepath
            ),
        },
    });
    const picturefull4 = await prisma.media.create({
        data: {
            capture_method: "AUTO",
            type: "PICTURE",
            path: Bun.resolveSync(
                "./isentry/medias/80571cd9-098e-480a-be36-45f52fc3439d.jpg",
                homepath
            ),
        },
    });
    const picturefull5 = await prisma.media.create({
        data: {
            capture_method: "AUTO",
            type: "PICTURE",
            path: Bun.resolveSync(
                "./isentry/medias/fbef80d3-5447-4e41-83ab-b214d7ec0471.jpg",
                homepath
            ),
        },
    });
    const picturefull6 = await prisma.media.create({
        data: {
            capture_method: "AUTO",
            type: "PICTURE",
            path: Bun.resolveSync(
                "./isentry/medias/55404325-4b45-4a85-8066-1f2386946735.jpg",
                homepath
            ),
        },
    });
    const picturefull7 = await prisma.media.create({
        data: {
            capture_method: "AUTO",
            type: "PICTURE",
            path: Bun.resolveSync(
                "./isentry/medias/b0fca000-0e31-49a6-8aaf-97dd47356ce9.jpg",
                homepath
            ),
        },
    });
    const picturesingle1 = await prisma.media.create({
        data: {
            capture_method: "AUTO",
            type: "PICTURE",
            path: Bun.resolveSync(
                "./isentry/medias/fb698524-b1f8-4b4c-a9bf-c0b4f40e7983.jpg",
                homepath
            ),
        },
    });
    const picturesingle2 = await prisma.media.create({
        data: {
            capture_method: "AUTO",
            type: "PICTURE",
            path: Bun.resolveSync(
                "./isentry/medias/41baa19a-15e8-433d-a076-2107cea3a522.jpg",
                homepath
            ),
        },
    });
    const picturesingle3 = await prisma.media.create({
        data: {
            capture_method: "AUTO",
            type: "PICTURE",
            path: Bun.resolveSync(
                "./isentry/medias/8a303786-44f9-430a-9d16-c7a52f238228.jpg",
                homepath
            ),
        },
    });
    const picturesingle4 = await prisma.media.create({
        data: {
            capture_method: "AUTO",
            type: "PICTURE",
            path: Bun.resolveSync(
                "./isentry/medias/8ef27278-ae12-45f8-bce6-4aadb625a429.jpg",
                homepath
            ),
        },
    });
    const picturesingle5 = await prisma.media.create({
        data: {
            capture_method: "AUTO",
            type: "PICTURE",
            path: Bun.resolveSync(
                "./isentry/medias/61a0d35a-13cb-44c5-89b4-4d30e646ddcc.jpg",
                homepath
            ),
        },
    });
    const picturesingle6 = await prisma.media.create({
        data: {
            capture_method: "AUTO",
            type: "PICTURE",
            path: Bun.resolveSync(
                "./isentry/medias/718b47c2-f56f-4031-818a-c5c2eedae502.jpg",
                homepath
            ),
        },
    });
    const picturesingle7 = await prisma.media.create({
        data: {
            capture_method: "AUTO",
            type: "PICTURE",
            path: Bun.resolveSync(
                "./isentry/medias/219c018d-773d-4e45-adb7-84080a57a7f8.jpg",
                homepath
            ),
        },
    });
    const picturesingle8 = await prisma.media.create({
        data: {
            capture_method: "AUTO",
            type: "PICTURE",
            path: Bun.resolveSync(
                "./isentry/medias/6a7c1eff-fadd-4a6e-b615-c6b84ce7f3d9.jpg",
                homepath
            ),
        },
    });
    const picturesingle9 = await prisma.media.create({
        data: {
            capture_method: "AUTO",
            type: "PICTURE",
            path: Bun.resolveSync(
                "./isentry/medias/1367c96c-b24b-4f38-b642-283b13325f49.jpg",
                homepath
            ),
        },
    });
    const picturesingle10 = await prisma.media.create({
        data: {
            capture_method: "AUTO",
            type: "PICTURE",
            path: Bun.resolveSync(
                "./isentry/medias/d3af6b68-9efa-416f-9302-038853a69aa1.jpg",
                homepath
            ),
        },
    });
    const picturesingle11 = await prisma.media.create({
        data: {
            capture_method: "AUTO",
            type: "PICTURE",
            path: Bun.resolveSync(
                "./isentry/medias/e5b5f0ad-2550-46a8-9f51-bc449a3cc47c.jpg",
                homepath
            ),
        },
    });
    const picturesingle12 = await prisma.media.create({
        data: {
            capture_method: "AUTO",
            type: "PICTURE",
            path: Bun.resolveSync(
                "./isentry/medias/f04c209e-1085-4fa9-8f6c-be89c1c293e0.jpg",
                homepath
            ),
        },
    });
    const picturesingle13 = await prisma.media.create({
        data: {
            capture_method: "AUTO",
            type: "PICTURE",
            path: Bun.resolveSync(
                "./isentry/medias/fe69a327-ef61-4006-9e55-fa75f7d7198d.jpg",
                homepath
            ),
        },
    });
    const picturesingle14 = await prisma.media.create({
        data: {
            capture_method: "AUTO",
            type: "PICTURE",
            path: Bun.resolveSync(
                "./isentry/medias/d7e8e8b9-1e26-4292-a95b-45f1c39fd756.jpg",
                homepath
            ),
        },
    });
    const picturesingle15 = await prisma.media.create({
        data: {
            capture_method: "AUTO",
            type: "PICTURE",
            path: Bun.resolveSync(
                "./isentry/medias/8aa2e6cd-558e-43dd-86ab-a663aa0b8ed5.jpg",
                homepath
            ),
        },
    });
    const picturesingle16 = await prisma.media.create({
        data: {
            capture_method: "AUTO",
            type: "PICTURE",
            path: Bun.resolveSync(
                "./isentry/medias/babd3f33-7e8e-4e02-aa47-29a5e599ef50.jpg",
                homepath
            ),
        },
    });
    const picturesingle17 = await prisma.media.create({
        data: {
            capture_method: "AUTO",
            type: "PICTURE",
            path: Bun.resolveSync(
                "./isentry/medias/6e6a29dd-ecd1-48de-b767-2857aab4c4f2.jpg",
                homepath
            ),
        },
    });
    const picturesingle18 = await prisma.media.create({
        data: {
            capture_method: "AUTO",
            type: "PICTURE",
            path: Bun.resolveSync(
                "./isentry/medias/ffcab562-d6e5-45c6-86ca-c1479793e046.jpg",
                homepath
            ),
        },
    });
    const picturesingle19 = await prisma.media.create({
        data: {
            capture_method: "AUTO",
            type: "PICTURE",
            path: Bun.resolveSync(
                "./isentry/medias/d353c7ee-29ca-4f3e-bf27-558c9e69dae4.jpg",
                homepath
            ),
        },
    });
    const picturesingle20 = await prisma.media.create({
        data: {
            capture_method: "AUTO",
            type: "PICTURE",
            path: Bun.resolveSync(
                "./isentry/medias/b1d69673-e7a7-484d-826c-9b78c313f449.jpg",
                homepath
            ),
        },
    });
    const picturesingle21 = await prisma.media.create({
        data: {
            capture_method: "AUTO",
            type: "PICTURE",
            path: Bun.resolveSync(
                "./isentry/medias/247fa30d-ece1-4519-ae11-0b18cecce73c.jpg",
                homepath
            ),
        },
    });
    const picturesingle22 = await prisma.media.create({
        data: {
            capture_method: "AUTO",
            type: "PICTURE",
            path: Bun.resolveSync(
                "./isentry/medias/9a46b601-0abd-4f17-beb6-527aaf6d4347.jpg",
                homepath
            ),
        },
    });
    const picturesingle23 = await prisma.media.create({
        data: {
            capture_method: "AUTO",
            type: "PICTURE",
            path: Bun.resolveSync(
                "./isentry/medias/f6675286-91b2-44c5-86d4-f2ca9381c963.jpg",
                homepath
            ),
        },
    });
    const picturesingle24 = await prisma.media.create({
        data: {
            capture_method: "AUTO",
            type: "PICTURE",
            path: Bun.resolveSync(
                "./isentry/medias/df484056-d9bb-4faa-a542-0cb87bd48869.jpg",
                homepath
            ),
        },
    });

    // face
    const face1 = await prisma.face.create({
        data: {
            identity: identity1.id,
            embedding: Buffer.from(
                new Float64Array([
                    -0.13799574971199036, 0.12931737303733826,
                    0.05311412364244461, -0.09013247489929199,
                    0.032342035323381424, 0.010894534178078175,
                    -0.1009485274553299, -0.13908006250858307,
                    0.154620960354805, -0.0979652851819992, 0.21280159056186676,
                    0.0710022822022438, -0.22560906410217285,
                    -0.17748112976551056, 0.05091163143515587,
                    0.09698756039142609, -0.19650869071483612,
                    -0.11350249499082565, -0.0960228219628334,
                    -0.08527983725070953, 0.03640901669859886,
                    -0.0030917886178940535, 0.08907918632030487,
                    0.06549383699893951, -0.16401532292366028,
                    -0.35095280408859253, -0.0619942769408226,
                    -0.18394425511360168, -0.021139010787010193,
                    -0.09850013256072998, -0.0997002050280571,
                    -0.028194576501846313, -0.1998075693845749,
                    -0.07119768857955933, -0.03016972541809082,
                    -0.01610116846859455, 0.009154709987342358,
                    0.01200133003294468, 0.1797744482755661,
                    0.07249584048986435, -0.12913745641708374,
                    0.08704731613397598, -0.026243673637509346,
                    0.19835200905799866, 0.2824828326702118,
                    0.07353774458169937, 0.024333499372005463,
                    -0.071603924036026, 0.08938062936067581,
                    -0.23429180681705475, 0.05767464637756348,
                    0.1789425015449524, 0.05602100118994713,
                    0.018628859892487526, 0.09855084866285324,
                    -0.2081761658191681, -0.009841573424637318,
                    0.053075529634952545, -0.12273737788200378,
                    0.07337874919176102, 0.010775212198495865,
                    -0.10026440024375916, -0.03642582148313522,
                    0.054873328655958176, 0.18886065483093262,
                    0.09038834273815155, -0.11257962882518768,
                    -0.05806197598576546, 0.1634509265422821,
                    -0.03518536314368248, 0.01545474212616682,
                    0.04741227999329567, -0.16481900215148926,
                    -0.19967150688171387, -0.22742223739624023,
                    0.0773051455616951, 0.3600012958049774, 0.17701567709445953,
                    -0.21762849390506744, 0.015341994352638721,
                    -0.2428089678287506, 0.02706465683877468,
                    0.06443759053945541, 0.0011829417198896408,
                    -0.07353396713733673, -0.09208063036203384,
                    -0.0412413589656353, 0.034461311995983124,
                    0.10884049534797668, 0.08099843561649323,
                    -0.02244667150080204, 0.26833346486091614,
                    -0.003807293251156807, 0.055617280304431915,
                    0.046018462628126144, 0.02571488730609417,
                    -0.10654239356517792, -0.03529071807861328,
                    -0.11746480315923691, -0.029418937861919403,
                    0.006527675781399012, -0.092979297041893,
                    0.026963891461491585, 0.11480218917131424,
                    -0.24574607610702515, 0.07698576152324677,
                    0.025042301043868065, -0.030280906707048416,
                    0.007058677263557911, 0.07153413444757462,
                    -0.06757987290620804, -0.026487166061997414,
                    0.09202223271131516, -0.28175345063209534,
                    0.24166685342788696, 0.2804490327835083,
                    0.06760714203119278, 0.15420599281787872,
                    0.07223441451787949, 0.01853294111788273,
                    -0.022939682006835938, -0.02484704554080963,
                    -0.14992479979991913, -0.06341933459043503,
                    0.05566531792283058, 0.023367460817098618,
                    0.054854560643434525, 0.035899072885513306,
                ]).buffer
            ),
            picture_full: picturefull1.id,
            picture_single: picturesingle1.id,
            bounding_box: Buffer.from(
                new Int32Array([1093, 336, 309, 310]).buffer
            ),
        },
    });
    const face2 = await prisma.face.create({
        data: {
            identity: identity2.id,
            embedding: Buffer.from(
                new Float64Array([
                    -0.10376253724098206, 0.019351691007614136,
                    0.10523641109466553, -0.13031265139579773,
                    -0.09995251148939133, -0.1463620960712433,
                    -0.030177565291523933, -0.13780774176120758,
                    0.24041585624217987, -0.16122543811798096,
                    0.1076442077755928, 0.00941881351172924,
                    -0.21048328280448914, -0.009431606158614159,
                    -0.05291803181171417, 0.18272484838962555,
                    -0.1804085373878479, -0.2269163578748703,
                    -0.15945793688297272, -0.0577840618789196,
                    0.015541542321443558, 0.03353292495012283,
                    -0.017710186541080475, -0.0011229272931814194,
                    -0.08291326463222504, -0.2971500754356384,
                    -0.10834211856126785, -0.037393100559711456,
                    0.1106945276260376, -0.00930237676948309,
                    -0.004605686292052269, 0.08947543799877167,
                    -0.22600990533828735, -0.10373330116271973,
                    0.037742797285318375, 0.055432677268981934,
                    -0.06898007541894913, -0.11863546818494797,
                    0.24691510200500488, 0.02577698789536953,
                    -0.22348840534687042, -0.05021336302161217,
                    0.031746771186590195, 0.16962072253227234,
                    0.24040216207504272, 0.0316445492208004,
                    0.10498160868883133, -0.17144769430160522,
                    0.15848176181316376, -0.30440789461135864,
                    0.016816090792417526, 0.19079120457172394,
                    0.039036355912685394, 0.09130875766277313,
                    0.06658618897199631, -0.15509332716464996,
                    0.03971786051988602, 0.1613711416721344,
                    -0.2602556347846985, 0.0892522782087326,
                    0.12907202541828156, -0.12314807623624802,
                    -0.09352830052375793, -0.05368432030081749,
                    0.14786264300346375, 0.05657682195305824,
                    -0.07623159140348434, -0.18298812210559845,
                    0.3209269344806671, -0.1950816810131073,
                    -0.03796122968196869, 0.05660642683506012,
                    -0.07439808547496796, -0.15395666658878326,
                    -0.2657533884048462, -0.06989952176809311,
                    0.3907903730869293, 0.13687890768051147,
                    -0.052145928144454956, 0.0928279235959053,
                    -0.15892544388771057, -0.05831627920269966,
                    -0.009578453376889229, -0.022237060591578484,
                    -0.06779417395591736, -0.03949958458542824,
                    -0.06667862832546234, 0.017952246591448784,
                    0.2828637361526489, -0.0044173309579491615,
                    0.04855439066886902, 0.19960808753967285,
                    0.05229534953832626, -0.04671913757920265,
                    -0.009147441945970058, 0.06432472914457321,
                    -0.1028721034526825, -0.022174827754497528,
                    -0.1525820642709732, -0.024641601368784904,
                    0.024513378739356995, -0.04638168588280678,
                    0.030946193262934685, 0.10183341056108475,
                    -0.14364761114120483, 0.1813150942325592,
                    -0.037759050726890564, -0.025367535650730133,
                    -0.060384996235370636, -0.06833720952272415,
                    -0.11006467044353485, -0.059133805334568024,
                    0.1648326963186264, -0.14804138243198395,
                    0.18913067877292633, 0.20444287359714508,
                    0.04717906564474106, 0.12097965180873871,
                    0.052536651492118835, 0.07106681168079376,
                    -0.007133877836167812, -0.07814322412014008,
                    -0.1850462406873703, -0.12040457874536514,
                    0.03905186802148819, 0.024299941956996918,
                    0.04349727928638458, 0.09963424503803253,
                ]).buffer
            ),
            picture_full: picturefull1.id,
            picture_single: picturesingle2.id,
            bounding_box: Buffer.from(
                new Int32Array([2882, 749, 309, 309]).buffer
            ),
        },
    });
    const face3 = await prisma.face.create({
        data: {
            identity: identity3.id,
            embedding: Buffer.from(
                new Float64Array([
                    -0.09982564300298691, 0.09846256673336029,
                    -0.007148487493395805, -0.08221100270748138,
                    0.0029439309146255255, -0.05826885998249054,
                    0.005046917125582695, -0.08460202068090439,
                    0.21288467943668365, -0.04568156227469444,
                    0.1589965671300888, -0.10878100246191025,
                    -0.2533104717731476, 0.03472486883401871,
                    -0.05231046304106712, 0.08109890669584274,
                    -0.09263698011636734, -0.13573910295963287,
                    -0.12924470007419586, -0.1310703009366989,
                    0.05696863681077957, 0.01849261298775673,
                    -0.0023232754319906235, 0.06505376845598221,
                    -0.20837830007076263, -0.23203228414058685,
                    -0.04688910394906998, -0.19771437346935272,
                    0.03109559789299965, -0.17847509682178497,
                    -0.08239902555942535, 0.018412841483950615,
                    -0.19963794946670532, -0.07865484058856964,
                    -0.008777700364589691, 0.07942881435155869,
                    0.022181134670972824, -0.055954985320568085,
                    0.1819630116224289, 0.037333931773900986,
                    -0.1504075676202774, 0.035008735954761505,
                    0.09493985772132874, 0.24998459219932556,
                    0.15668217837810516, 0.040278978645801544,
                    -0.004855241626501083, -0.03391677886247635,
                    0.09391295909881592, -0.23051777482032776,
                    0.13849525153636932, 0.05635277181863785,
                    0.11354240775108337, 0.05026159808039665,
                    0.1804727464914322, -0.24281613528728485,
                    -0.04950246959924698, 0.06651654839515686,
                    -0.15183185040950775, 0.14175352454185486,
                    0.09449488669633865, 0.06410607695579529,
                    -0.1283990889787674, -0.05599847063422203,
                    0.16768412292003632, 0.10789134353399277,
                    -0.13502395153045654, -0.06186014413833618,
                    0.14392097294330597, -0.12148600071668625,
                    0.0012611309066414833, 0.09354209899902344,
                    -0.06995048373937607, -0.14759768545627594,
                    -0.18856175243854523, 0.12634772062301636,
                    0.4216427803039551, 0.10358455777168274,
                    -0.17068278789520264, 0.03474632650613785,
                    -0.026906276121735573, -0.07002581655979156,
                    0.019852086901664734, -0.017184749245643616,
                    -0.11549384891986847, 0.05435045063495636,
                    -0.06749147921800613, 0.07652387022972107,
                    0.14877675473690033, 0.05338149890303612,
                    -0.01911526918411255, 0.15449006855487823,
                    -0.09539908170700073, -0.016023660078644753,
                    -0.01190156675875187, 0.09859594702720642,
                    -0.20686395466327667, -0.022163737565279007,
                    -0.09730483591556549, -0.04715070128440857,
                    0.15980857610702515, -0.11638012528419495,
                    -0.08712708950042725, 0.1219559982419014,
                    -0.18990570306777954, 0.07518430054187775,
                    -0.021658435463905334, -0.08442854881286621,
                    -0.04538801312446594, 0.10272099077701569,
                    -0.08997451514005661, 0.019467035308480263,
                    0.14271427690982819, -0.2520540952682495,
                    0.14566582441329956, 0.1432514190673828,
                    -0.014585420489311218, 0.06289973109960556,
                    0.040924929082393646, 0.003191724419593811,
                    0.10994890332221985, 0.09320907294750214,
                    -0.21295753121376038, -0.14656060934066772,
                    0.044222380965948105, -0.010225516743957996,
                    0.020085640251636505, 0.050737980753183365,
                ]).buffer
            ),
            picture_full: picturefull1.id,
            picture_single: picturesingle3.id,
            bounding_box: Buffer.from(
                new Int32Array([1712, 267, 310, 310]).buffer
            ),
        },
    });
    const face4 = await prisma.face.create({
        data: {
            identity: identity4.id,
            embedding: Buffer.from(
                new Float64Array([
                    -0.05341430753469467, 0.10285549610853195,
                    -0.039583079516887665, -0.013372882269322872,
                    -0.06639016419649124, -0.06005244702100754,
                    -0.014151589944958687, -0.21626606583595276,
                    0.17679047584533691, -0.076510950922966,
                    0.11858463287353516, 0.0027768267318606377,
                    -0.2507795989513397, -0.024254273623228073,
                    0.06900828331708908, 0.0790092870593071,
                    -0.13754592835903168, -0.20271027088165283,
                    -0.1900390386581421, -0.1917143315076828,
                    0.0006854846142232418, -0.024831896647810936,
                    0.025990527123212814, 0.045339539647102356,
                    -0.17188075184822083, -0.20396685600280762,
                    -0.09720110893249512, -0.12272942066192627,
                    0.10273398458957672, 0.030381791293621063,
                    0.005537006072700024, -0.029598895460367203,
                    -0.250101238489151, -0.17370884120464325,
                    0.05741141363978386, -0.05632106959819794,
                    -0.03137049078941345, -0.113109290599823,
                    0.23754511773586273, -0.00538274273276329,
                    -0.12214123457670212, -0.021036602556705475,
                    0.0915459543466568, 0.21247991919517517,
                    0.19244277477264404, 0.05195411667227745,
                    0.04063902422785759, -0.11709348112344742,
                    0.18861538171768188, -0.25873270630836487,
                    0.0777202919125557, 0.14863114058971405,
                    0.13458587229251862, 0.10548428446054459,
                    0.08794624358415604, -0.12865079939365387,
                    0.08607815206050873, 0.12840935587882996,
                    -0.2717352509498596, 0.12074951082468033,
                    0.1227058693766594, -0.06198890507221222,
                    -0.10657242685556412, -0.08840855956077576,
                    0.19859299063682556, 0.16742002964019775,
                    -0.03659147024154663, -0.18156129121780396,
                    0.19254466891288757, -0.2016611397266388,
                    -0.1404193788766861, 0.025360602885484695,
                    -0.10673271119594574, -0.14017058908939362,
                    -0.38988444209098816, 0.0061779506504535675,
                    0.40848955512046814, 0.19967520236968994,
                    -0.12630420923233032, 0.029176976531744003,
                    -0.031844839453697205, 0.010064744390547276,
                    0.06784004718065262, 0.013254611752927303,
                    -0.1339820772409439, -0.07204636186361313,
                    -0.007926609367132187, 0.028849316760897636,
                    0.25319501757621765, 0.0051030563190579414,
                    -0.09624574333429337, 0.20231103897094727,
                    0.021903909742832184, -0.022162064909934998,
                    0.0454728789627552, 0.087081678211689, -0.1180422306060791,
                    -0.06296002864837646, -0.1330844908952713,
                    0.01444375328719616, 0.08148922026157379,
                    -0.005144020542502403, 0.09577089548110962,
                    0.14035755395889282, -0.16172288358211517,
                    0.11435052007436752, -0.06284374743700027,
                    -0.03998139873147011, -0.03801960498094559,
                    0.0101784598082304, -0.10747864842414856,
                    -0.05734524875879288, 0.11708308756351471,
                    -0.20682092010974884, 0.20503182709217072,
                    0.17990271747112274, -0.002558715408667922,
                    0.0611138679087162, -0.00944526121020317,
                    0.04418469965457916, -5.134381353855133e-6,
                    0.07359939813613892, -0.17821228504180908,
                    -0.16788358986377716, 0.05735057219862938,
                    -0.008488263003528118, 0.034569427371025085,
                    0.07858999818563461,
                ]).buffer
            ),
            picture_full: picturefull1.id,
            picture_single: picturesingle4.id,
            bounding_box: Buffer.from(
                new Int32Array([2229, 652, 258, 258]).buffer
            ),
        },
    });
    const face5 = await prisma.face.create({
        data: {
            identity: null,
            embedding: Buffer.from(
                new Float64Array([
                    -0.03760019317269325, 0.09740620851516724,
                    0.12425415962934494, 0.006169874686747789,
                    -0.006999166216701269, -0.06016260385513306,
                    -0.11302608996629715, -0.15927179157733917,
                    0.10032819956541061, -0.11941970884799957,
                    0.2583784759044647, -0.02919805608689785,
                    -0.10212970525026321, -0.1441616415977478,
                    -0.03393460065126419, 0.16435208916664124,
                    -0.1924755871295929, -0.09663637727499008,
                    -0.09195677191019058, 0.02042130008339882,
                    0.02787010185420513, -0.0023203871678560972,
                    0.08968450874090195, -0.04855857789516449,
                    -0.12340851128101349, -0.3334030508995056,
                    -0.09964421391487122, -0.08946512639522552,
                    0.003336000256240368, -0.021959541365504265,
                    -0.1371401846408844, -0.012968826107680798,
                    -0.18137195706367493, -0.046421244740486145,
                    0.012197905220091343, 0.05114440247416496,
                    -0.01695813238620758, -0.008944539353251457,
                    0.14745326340198517, 0.0174110047519207,
                    -0.21766816079616547, 0.16720247268676758,
                    -0.0162128284573555, 0.218241348862648, 0.28946173191070557,
                    0.014939362183213234, 0.015419559553265572,
                    -0.11574701964855194, 0.12687678635120392,
                    -0.16911044716835022, -0.006685636937618256,
                    0.14368081092834473, 0.09620978683233261,
                    0.05225613713264465, 0.05225595459342003,
                    -0.06822343170642853, 0.000728704035282135,
                    0.08272764831781387, -0.04996715113520622,
                    0.007219379767775536, 0.09337157756090164,
                    -0.03565597906708717, -0.0025167539715766907,
                    -0.04082930460572243, 0.13779601454734802,
                    0.044480111449956894, -0.1457432210445404,
                    -0.11953383684158325, 0.05215037614107132,
                    -0.08256721496582031, -0.023665769025683403,
                    0.03603512793779373, -0.16478638350963593,
                    -0.18424169719219208, -0.3011445701122284,
                    0.008152592927217484, 0.4247422516345978,
                    0.06085857003927231, -0.2432910054922104,
                    0.0063310950063169, -0.10892008990049362,
                    0.04061608016490936, 0.12609727680683136,
                    0.0834796354174614, -0.0036910083144903183,
                    -0.0004216087982058525, -0.08198226243257523,
                    -0.014284513890743256, 0.1952412873506546,
                    -0.08184546232223511, -0.01662464812397957,
                    0.19073812663555145, -0.03637321665883064,
                    0.09366609156131744, -0.004692050628364086,
                    0.031863532960414886, -0.01784084551036358,
                    0.05833177641034126, -0.10761955380439758,
                    0.07236243039369583, -0.018129892647266388,
                    -0.09966429322957993, -0.03340103104710579,
                    0.05750315263867378, -0.16374638676643372,
                    0.12034390866756439, 0.03930673375725746,
                    0.07192481309175491, 0.06392897665500641,
                    0.05712689086794853, -0.089640311896801,
                    -0.034560784697532654, 0.10228550434112549,
                    -0.2767890393733978, 0.21907579898834229,
                    0.2562641203403473, 0.020451854914426804,
                    0.09034566581249237, 0.09871355444192886,
                    0.07548351585865021, -0.05842060595750809,
                    0.06587241590023041, -0.14728766679763794,
                    -0.07632128894329071, -0.0038176150992512703,
                    0.015610123984515667, 0.03496403619647026,
                    0.015460900962352753,
                ]).buffer
            ),
            picture_full: picturefull2.id,
            picture_single: picturesingle5.id,
            bounding_box: Buffer.from(
                new Int32Array([277, 245, 72, 72]).buffer
            ),
        },
    });
    const face6 = await prisma.face.create({
        data: {
            identity: identity6.id,
            embedding: Buffer.from(
                new Float64Array([
                    -0.05833764001727104, 0.18662235140800476,
                    0.07581771910190582, -0.0012684876564890146,
                    -0.09653089940547943, 0.0488702654838562,
                    -0.06666110455989838, -0.07388439029455185,
                    0.10571779310703278, -0.017759306356310844,
                    0.21496780216693878, -0.025855349376797676,
                    -0.24284608662128448, -0.00858637411147356,
                    0.04269237071275711, 0.15515001118183136,
                    -0.1413203924894333, -0.0851663127541542,
                    -0.19088247418403625, -0.06303435564041138,
                    -0.00422369409352541, -0.01551185455173254,
                    0.06473524868488312, -0.04610520228743553,
                    -0.20217521488666534, -0.26193422079086304,
                    -0.0464327372610569, -0.131241574883461,
                    -0.06782571971416473, -0.14714324474334717,
                    0.06144099682569504, -0.07471083849668503,
                    -0.17621414363384247, -0.05780377611517906,
                    -0.0202794186770916, -0.005570787936449051,
                    -0.06904076784849167, -0.08884421736001968,
                    0.1708325743675232, -0.032521747052669525,
                    -0.1565123051404953, 0.0999360978603363,
                    0.006044923327863216, 0.19524741172790527,
                    0.22956672310829163, 0.014556917361915112,
                    0.06548111140727997, -0.08249345421791077,
                    0.1360015720129013, -0.20333664119243622,
                    0.008448505774140358, 0.0662793219089508,
                    0.1499151736497879, 0.08364791423082352,
                    0.07236950844526291, -0.07530538737773895,
                    0.03790564835071564, 0.2137438952922821,
                    -0.17956571280956268, 0.07703603804111481,
                    0.028420772403478622, -0.0678572878241539,
                    0.03163093328475952, -0.01960616558790207,
                    0.18706747889518738, 0.13136115670204163,
                    -0.04710221290588379, -0.12557430565357208,
                    0.1837054044008255, -0.06801266968250275,
                    -0.09967950731515884, 0.03201751410961151,
                    -0.11035748571157455, -0.19003501534461975,
                    -0.31527987122535706, -0.01149166002869606,
                    0.2986786365509033, 0.05138126015663147,
                    -0.2910231649875641, -0.10056951642036438,
                    -0.04800960049033165, 0.02017156034708023,
                    -0.018424417823553085, 0.04335743188858032,
                    -0.055622514337301254, -0.13758790493011475,
                    -0.0896020382642746, -0.025401413440704346,
                    0.32320356369018555, -0.10344346612691879,
                    -0.030479228124022484, 0.19606201350688934,
                    0.04329851642251015, -0.10410623997449875,
                    0.023478353396058083, 0.021428892388939857,
                    -0.11097332090139389, -0.007746041286736727,
                    -0.09854075312614441, -0.014507115818560123,
                    -0.016732297837734222, -0.11912135034799576,
                    -0.055985696613788605, 0.09904906898736954,
                    -0.1994350403547287, 0.15253904461860657,
                    -0.023592974990606308, -0.048897579312324524,
                    -0.06637189537286758, 0.026388047263026237,
                    -0.042757853865623474, -0.008226372301578522,
                    0.22611592710018158, -0.20297545194625854,
                    0.2419908195734024, 0.24468214809894562,
                    -0.03494764864444733, 0.081352598965168,
                    -0.003929035272449255, 0.09566216915845871,
                    -0.03329439461231232, 0.10703561455011368,
                    -0.14235325157642365, -0.1381777971982956,
                    0.014052122831344604, 0.012983733788132668,
                    0.010236678645014763, 0.07753422111272812,
                ]).buffer
            ),
            picture_full: picturefull2.id,
            picture_single: picturesingle6.id,
            bounding_box: Buffer.from(
                new Int32Array([189, 237, 72, 72]).buffer
            ),
        },
    });
    const face7 = await prisma.face.create({
        data: {
            identity: identity7.id,
            embedding: Buffer.from(
                new Float64Array([
                    -0.05201776698231697, 0.07304259389638901,
                    0.05994251370429993, 0.04070796072483063,
                    -0.050923969596624374, -0.0103739770129323,
                    -0.059278104454278946, -0.22952505946159363,
                    0.1750572919845581, -0.12338133156299591,
                    0.20045916736125946, -0.03483949601650238,
                    -0.1634855568408966, -0.11131645739078522,
                    0.03620074689388275, 0.1721903681755066,
                    -0.15588787198066711, -0.14434368908405304,
                    -0.12266559898853302, -0.054839860647916794,
                    -0.03470711410045624, -0.05071350932121277,
                    0.04166974872350693, -0.02543186955153942,
                    -0.06825664639472961, -0.34494584798812866,
                    -0.12867799401283264, -0.09788405895233154,
                    0.09161607176065445, 0.007506766822189093,
                    -0.0430893748998642, 0.016258912160992622,
                    -0.20109497010707855, -0.1379058063030243,
                    0.05330832675099373, 0.07488776743412018,
                    -0.030107621103525162, -0.04088862985372543,
                    0.19208042323589325, -0.08574587106704712,
                    -0.19374176859855652, 0.0741025060415268,
                    0.03370645269751549, 0.18827885389328003,
                    0.16645394265651703, 0.06895596534013748,
                    0.05723538249731064, -0.15257760882377625,
                    0.17250704765319824, -0.11351482570171356,
                    -0.0276027899235487, 0.16102154552936554,
                    0.12944766879081726, 0.0536976158618927,
                    0.025535859167575836, -0.07438597828149796,
                    0.03232771158218384, 0.0973975881934166,
                    -0.15182766318321228, 0.00633673369884491,
                    0.14039023220539093, -0.017543956637382507,
                    -0.06408969312906265, -0.039343252778053284,
                    0.22937151789665222, 0.061921484768390656,
                    -0.11988026648759842, -0.16114404797554016,
                    0.11470601707696915, -0.09118622541427612,
                    -0.02339862659573555, 0.02851906418800354,
                    -0.16860155761241913, -0.170116126537323,
                    -0.28851017355918884, -0.007477875798940659,
                    0.48457691073417664, 0.0216242466121912,
                    -0.17877039313316345, 0.04930371046066284,
                    -0.121660515666008, 0.009465806186199188,
                    0.07806407660245895, 0.08994254469871521,
                    -0.026816390454769135, -0.001686379313468933,
                    -0.03674967959523201, 0.0007094135507941246,
                    0.2135802060365677, -0.07567711174488068,
                    0.00776827335357666, 0.147875115275383,
                    -0.013160246424376965, 0.057501476258039474,
                    -0.028858251869678497, 0.06484527885913849,
                    -0.06721377372741699, 0.02641073614358902,
                    -0.12222153693437576, -0.02998269349336624,
                    0.0807805061340332, 0.024612776935100555,
                    0.07458129525184631, 0.054801762104034424,
                    -0.16519559919834137, 0.17678911983966827,
                    0.01589297503232956, 0.09055062383413315,
                    0.10135021060705185, 0.0300652664154768,
                    -0.0903637558221817, -0.06138686463236809,
                    0.1596069186925888, -0.26890960335731506,
                    0.19749076664447784, 0.1770767718553543, -0.056512251496315,
                    0.07537520676851273, 0.07464314252138138,
                    0.1228596642613411, -0.03735066577792168,
                    0.05318083241581917, -0.20224200189113617,
                    -0.10476071387529373, 0.052249982953071594,
                    0.0019177710637450218, 0.04588835686445236,
                    0.006285421084612608,
                ]).buffer
            ),
            picture_full: picturefull2.id,
            picture_single: picturesingle7.id,
            bounding_box: Buffer.from(
                new Int32Array([453, 245, 72, 72]).buffer
            ),
        },
    });
    const face8 = await prisma.face.create({
        data: {
            identity: identity8.id,
            embedding: Buffer.from(
                new Float64Array([
                    -0.21197572350502014, 0.103890560567379,
                    0.026550529524683952, -0.029335763305425644,
                    -0.10368805378675461, 0.06785079091787338,
                    0.0011158473789691925, -0.05463959276676178,
                    0.12562312185764313, -0.0775764212012291,
                    0.1427113562822342, -0.009370507672429085,
                    -0.18783468008041382, 0.032912060618400574,
                    0.003702828660607338, 0.10327298939228058,
                    -0.06035718321800232, -0.16516007483005524,
                    -0.19199995696544647, -0.10279446840286255,
                    0.009610777720808983, 0.03317751735448837,
                    -0.0837005153298378, 0.017114408314228058,
                    -0.22184623777866364, -0.30948683619499207,
                    -0.13973142206668854, -0.02178395725786686,
                    0.011273295618593693, -0.12989689409732819,
                    0.011719046160578728, -0.04466525465250015,
                    -0.20406761765480042, -0.054238658398389816,
                    0.06726275384426117, 0.10814938694238663,
                    -0.07423175126314163, -0.07743357121944427,
                    0.1993054747581482, 0.012877696193754673,
                    -0.1571972370147705, 0.08480310440063477,
                    0.10953324288129807, 0.29299622774124146,
                    0.1636098474264145, 0.059050172567367554,
                    -0.029393445700407028, -0.06019052863121033,
                    0.10592833906412125, -0.22676318883895874,
                    0.14405471086502075, 0.14840790629386902,
                    0.1054551973938942, 0.11077909171581268,
                    0.12352637201547623, -0.09776301681995392,
                    -0.039301298558712006, 0.2180764377117157,
                    -0.14320120215415955, 0.05744257569313049,
                    0.012400425970554352, -0.07494322210550308,
                    -0.11755579710006714, -0.13857153058052063,
                    0.17245948314666748, 0.20563024282455444,
                    -0.14157886803150177, -0.16648773849010468,
                    0.18494883179664612, -0.11069181561470032,
                    -0.05718610808253288, -0.01764376275241375,
                    -0.07320217043161392, -0.16782912611961365,
                    -0.2683483064174652, 0.14897212386131287,
                    0.4009844660758972, 0.15333135426044464,
                    -0.2407570630311966, 0.03039337322115898,
                    -0.006850830279290676, 0.0003041038289666176,
                    0.05868840217590332, 0.09359810501337051,
                    -0.09776291251182556, -0.06680908799171448,
                    0.02721472829580307, 0.05873610079288483,
                    0.2077694535255432, 0.07255634665489197,
                    -0.03714408725500107, 0.15220960974693298,
                    0.002122301608324051, -0.024171562865376472,
                    0.04983997344970703, 0.04715079441666603,
                    -0.13987688720226288, -0.07278146594762802,
                    -0.10524225234985352, -0.018689056858420372,
                    0.08775046467781067, -0.02757146582007408,
                    0.0037536360323429108, 0.16830691695213318,
                    -0.14675047993659973, 0.20882157981395721,
                    0.012905364856123924, -0.015763651579618454,
                    0.02075060084462166, 0.04810280725359917,
                    -0.10152240842580795, -0.008320057764649391,
                    0.12051292508840561, -0.3031185567378998,
                    0.21707794070243835, 0.1295241117477417,
                    -0.12371097505092621, 0.12341174483299255,
                    0.13666686415672302, 0.08787870407104492,
                    0.07420988380908966, 0.1084553450345993,
                    -0.21633540093898773, -0.1115451529622078,
                    0.09514778107404709, -0.02703775092959404,
                    0.04011540114879608, 0.039152760058641434,
                ]).buffer
            ),
            picture_full: picturefull2.id,
            picture_single: picturesingle8.id,
            bounding_box: Buffer.from(new Int32Array([13, 237, 72, 72]).buffer),
        },
    });
    const face9 = await prisma.face.create({
        data: {
            identity: identity9.id,
            embedding: Buffer.from(
                new Float64Array([
                    -0.09724626690149307, 0.06961951404809952,
                    0.048644743859767914, -0.03749648481607437,
                    -0.06462357938289642, 0.0181146040558815,
                    -0.08677978068590164, -0.1008836105465889,
                    0.09174834936857224, -0.06300631165504456,
                    0.21612799167633057, 0.020570512861013412,
                    -0.2069445103406906, -0.0034745566081255674,
                    -0.10831906646490097, 0.0520859956741333,
                    -0.11892252415418625, -0.08408919721841812,
                    -0.08715549111366272, -0.03352738171815872,
                    0.010926702991127968, 0.023897353559732437,
                    0.08752301335334778, 0.025814875960350037,
                    -0.11449877917766571, -0.28234878182411194,
                    -0.04235127568244934, -0.12999297678470612,
                    0.1346675157546997, -0.07921455055475235,
                    -0.11826122552156448, -0.042597655206918716,
                    -0.19323985278606415, -0.037743452936410904,
                    0.021066471934318542, 0.08282485604286194,
                    0.061884284019470215, 0.009135475382208824,
                    0.1914936602115631, 0.09399436414241791,
                    -0.15351922810077667, 0.10074926167726517,
                    -0.004539288580417633, 0.30118754506111145,
                    0.18803511559963226, 0.07047023624181747,
                    0.016329068690538406, -0.08382926136255264,
                    0.05584648251533508, -0.23007884621620178,
                    0.11419468373060226, 0.12430402636528015,
                    0.18618445098400116, -0.01338970847427845,
                    0.054046016186475754, -0.1925918310880661,
                    -0.010734112933278084, 0.05099787563085556,
                    -0.15499113500118256, 0.1858731508255005,
                    0.10109979659318924, 0.02212470769882202,
                    -0.005477218888700008, -0.04697469249367714,
                    0.2101524919271469, 0.08849450200796127,
                    -0.1550566554069519, -0.08792928606271744,
                    0.12091556936502457, -0.1358269453048706,
                    0.022209100425243378, 0.04299995303153992,
                    -0.06928999722003937, -0.16031485795974731,
                    -0.15778449177742004, 0.06508275866508484,
                    0.41609999537467957, 0.20729781687259674,
                    -0.2525654137134552, 0.018419908359646797,
                    -0.17777155339717865, -0.04195323586463928,
                    0.04965367913246155, 0.021437637507915497,
                    -0.07865803688764572, 0.031429316848516464,
                    -0.08137586712837219, -0.012948512099683285,
                    0.1692982017993927, -0.0034491876140236855,
                    0.004925967659801245, 0.23511891067028046,
                    -0.014900850132107735, 0.01443432830274105,
                    0.04045639932155609, 0.060034219175577164,
                    -0.18968777358531952, -0.0074905045330524445,
                    -0.10868795216083527, -0.04131223261356354,
                    -0.02414746768772602, -0.17719361186027527,
                    0.06123749166727066, 0.05711662769317627,
                    -0.22564907371997833, 0.12076003849506378,
                    -0.03519260510802269, -0.05229882150888443,
                    0.07968016713857651, 0.10269852727651596,
                    -0.09237680584192276, -0.07353024929761887,
                    0.17998231947422028, -0.28366684913635254,
                    0.24148613214492798, 0.22057075798511505,
                    0.08867859840393066, 0.13162456452846527,
                    0.13829661905765533, 0.0863916277885437,
                    0.06446933001279831, 0.08313550055027008,
                    -0.06762728840112686, -0.1385902464389801,
                    -0.057743437588214874, -0.10212219506502151,
                    0.06303675472736359, 0.06018707901239395,
                ]).buffer
            ),
            picture_full: picturefull2.id,
            picture_single: picturesingle9.id,
            bounding_box: Buffer.from(
                new Int32Array([365, 205, 72, 72]).buffer
            ),
        },
    });
    const face10 = await prisma.face.create({
        data: {
            identity: identity10.id,
            embedding: Buffer.from(
                new Float64Array([
                    -0.04396964609622955, 0.07402271032333374,
                    0.1067984327673912, -0.12963750958442688,
                    -0.03944878280162811, -0.07454057782888412,
                    0.003955399617552757, -0.09968678653240204,
                    0.2852018177509308, -0.16164672374725342,
                    0.15640155971050262, -0.025020325556397438,
                    -0.203266903758049, 0.04539652541279793,
                    -0.06422323733568192, 0.19832287728786469,
                    -0.22795821726322174, -0.22640766203403473,
                    -0.10994581878185272, -0.08804736286401749,
                    0.020424416288733482, 0.12747521698474884,
                    0.03381634131073952, 0.0996473953127861,
                    -0.06481000781059265, -0.2529769837856293,
                    -0.008432692848145962, -0.09354620426893234,
                    0.1182088628411293, -0.1294315904378891,
                    0.01994093507528305, 0.09244246035814285,
                    -0.15091022849082947, -0.0312916561961174,
                    0.08330079913139343, 0.09447825700044632,
                    -0.05601600930094719, -0.2126336693763733,
                    0.2061319798231125, 0.06370598822832108,
                    -0.23574845492839813, -0.07714402675628662,
                    0.03343445062637329, 0.27375927567481995,
                    0.22051088511943817, 0.05152750015258789,
                    -0.002236291766166687, -0.19490958750247955,
                    0.14961478114128113, -0.3567783236503601,
                    -0.01979285292327404, 0.15891730785369873,
                    0.0097840316593647, 0.1340446025133133,
                    0.022857945412397385, -0.2743006944656372,
                    0.12120712548494339, 0.047534048557281494,
                    -0.28464215993881226, 0.11540877819061279,
                    0.10490783303976059, -0.1694050431251526,
                    0.08908358961343765, 0.04117196425795555,
                    0.20177680253982544, 0.06435738503932953,
                    -0.1051553413271904, -0.1334795206785202,
                    0.21686162054538727, -0.22341355681419373,
                    -0.060036104172468185, 0.09687630087137222,
                    -0.0694209411740303, -0.20552729070186615,
                    -0.1851862668991089, -0.07503461837768555,
                    0.34061625599861145, 0.1777433604001999,
                    -0.05539639666676521, 0.05987102538347244,
                    -0.08558694273233414, 0.0248197540640831,
                    0.022398129105567932, 0.17219579219818115,
                    -0.06921911239624023, -0.07118742167949677,
                    -0.10135626792907715, -0.012463181279599667,
                    0.25778618454933167, -0.04413788393139839,
                    -0.03407340124249458, 0.27498966455459595,
                    -0.026424739509820938, -0.05541669577360153,
                    0.0015766420401632786, 0.09348873049020767,
                    -0.14511775970458984, 0.10228640586137772,
                    -0.11940386146306992, -0.028122082352638245,
                    0.0012403354048728943, -0.025590412318706512,
                    0.052057210355997086, 0.12933097779750824,
                    -0.18242424726486206, 0.13011547923088074,
                    -0.07284397631883621, -0.07196229696273804,
                    -0.0014697480946779251, -0.032280221581459045,
                    -0.054563239216804504, -0.08714330941438675,
                    0.15589290857315063, -0.2035108506679535,
                    0.2515462040901184, 0.2794741690158844, 0.14305026829242706,
                    0.19856712222099304, 0.03639538213610649,
                    0.10585860162973404, 0.08574951440095901,
                    -0.09121381491422653, -0.11046493053436279,
                    -0.06367826461791992, -0.011735349893569946,
                    0.041549913585186005, -0.004669311456382275,
                    0.05677042901515961,
                ]).buffer
            ),
            picture_full: picturefull2.id,
            picture_single: picturesingle10.id,
            bounding_box: Buffer.from(new Int32Array([461, 93, 72, 72]).buffer),
        },
    });
    const face11 = await prisma.face.create({
        data: {
            identity: identity11.id,
            embedding: Buffer.from(
                new Float64Array([
                    -0.14017058908939362, 0.12563319504261017,
                    0.03704850748181343, -0.007849425077438354,
                    0.043227244168519974, -0.05184898152947426,
                    0.011056674644351006, -0.17130127549171448,
                    0.19132620096206665, -0.08348722010850906,
                    0.11568619310855865, 0.015480190515518188,
                    -0.30332112312316895, -0.10435609519481659,
                    -0.031788937747478485, 0.10909571498632431,
                    -0.1513514220714569, -0.24895118176937103,
                    -0.17605473101139069, -0.15473975241184235,
                    0.02710428647696972, 0.02477884106338024,
                    0.033499643206596375, -0.036640189588069916,
                    -0.21157029271125793, -0.3081004023551941,
                    -0.10424917936325073, -0.1203349381685257,
                    -0.005978580564260483, -0.04322059080004692,
                    0.03703249990940094, 0.024634655565023422,
                    -0.21985501050949097, -0.05767427012324333,
                    -0.007969941943883896, 0.05234500765800476,
                    -0.030004184693098068, -0.044548314064741135,
                    0.23475614190101624, 0.04578543081879616,
                    -0.1691649705171585, -0.014032536186277866,
                    0.09871004521846771, 0.24183495342731476,
                    0.1920037865638733, -0.03052210994064808,
                    0.05496979504823685, -0.11079826951026917,
                    0.13576838374137878, -0.25838083028793335,
                    0.06868577748537064, 0.23470444977283478,
                    0.1597653031349182, 0.17830923199653625,
                    0.14982964098453522, -0.10614340007305145,
                    0.06568774580955505, 0.10610261559486389,
                    -0.16371311247348785, 0.10251327604055405,
                    0.08868718147277832, -0.10234923660755157,
                    -0.04035849869251251, 0.02559129148721695,
                    0.07643676549196243, 0.02483890764415264,
                    -0.09138565510511398, -0.08398118615150452,
                    0.12691627442836761, -0.1613648235797882,
                    -0.05559898912906647, 0.08393222093582153,
                    -0.07656272500753403, -0.22142472863197327,
                    -0.37144994735717773, 0.0644078403711319,
                    0.39829155802726746, 0.1762744039297104,
                    -0.11464715003967285, 0.07638118416070938,
                    -0.11180908977985382, -0.04064387083053589,
                    0.05771753191947937, 0.020226333290338516,
                    -0.1445685625076294, -0.0028466396033763885,
                    -0.10442139953374863, 0.07485409080982208,
                    0.2240218222141266, 0.025255367159843445,
                    -0.06852606683969498, 0.17396299540996552,
                    0.00203653983771801, 0.018226275220513344,
                    0.025567639619112015, 0.13684971630573273,
                    -0.10941086709499359, -0.05120294168591499,
                    -0.0752037912607193, 0.022629830986261368,
                    0.06547987461090088, -0.09386639297008514,
                    -0.019982188940048218, 0.0072371819987893105,
                    -0.12862515449523926, 0.1145017147064209,
                    0.029260331764817238, -0.044934261590242386,
                    -0.08491551876068115, -0.0058908406645059586,
                    -0.10475603491067886, 0.003617740934714675,
                    0.11091862618923187, -0.25729280710220337,
                    0.21450753509998322, 0.21712559461593628,
                    -0.09661515802145004, 0.14611849188804626,
                    0.08129234611988068, 0.05400817468762398,
                    -0.054993655532598495, -0.038453973829746246,
                    -0.07055273652076721, -0.16588450968265533,
                    0.043238066136837006, 0.09653027355670929,
                    0.0534096360206604, 0.04627818614244461,
                ]).buffer
            ),
            picture_full: picturefull2.id,
            picture_single: picturesingle11.id,
            bounding_box: Buffer.from(
                new Int32Array([301, 133, 72, 72]).buffer
            ),
        },
    });
    const face12 = await prisma.face.create({
        data: {
            identity: identity12.id,
            embedding: Buffer.from(
                new Float64Array([
                    -0.10710855573415756, 0.049188897013664246,
                    0.021278908476233482, -0.025620540603995323,
                    -0.11533114314079285, -0.05298289656639099,
                    0.004990683868527412, -0.08431025594472885,
                    0.1581585854291916, -0.10760953277349472,
                    0.14596474170684814, -0.04607674479484558,
                    -0.2605646848678589, 0.0006827267352491617,
                    0.020040258765220642, 0.1065681129693985,
                    -0.20425236225128174, -0.0743391215801239,
                    -0.13781756162643433, -0.16223680973052979,
                    0.008269790560007095, 0.0518721304833889,
                    -0.03812304139137268, -0.01711009442806244,
                    -0.10070893913507462, -0.2771594524383545,
                    -0.0740777850151062, -0.16241702437400818,
                    0.10650142282247543, -0.08593972027301788,
                    0.06936710327863693, 0.09960474073886871,
                    -0.10555927455425262, -0.0410727933049202,
                    -0.017189158126711845, 0.018314877524971962,
                    -0.08547196537256241, -0.11340939998626709,
                    0.21673215925693512, 0.00761110894382, -0.15931807458400726,
                    -0.06645206362009048, 0.06260551512241364,
                    0.20435260236263275, 0.22021692991256714,
                    0.005492655094712973, 0.024461861699819565,
                    -0.06513325124979019, 0.11067758500576019,
                    -0.2500934600830078, 0.03641601651906967,
                    0.1518869400024414, 0.038087036460638046,
                    0.1062949076294899, 0.15637913346290588,
                    -0.1773950308561325, 0.006113730370998383,
                    0.1313890814781189, -0.15430223941802979,
                    0.13194550573825836, 0.09347742795944214,
                    -0.1333395391702652, -0.013492787256836891,
                    -0.005536995828151703, 0.12801307439804077,
                    0.10627903044223785, 0.0029986323788762093,
                    -0.15629924833774567, 0.2343468815088272,
                    -0.20400340855121613, -0.1609765589237213,
                    0.05347806215286255, -0.0709657222032547,
                    -0.14444327354431152, -0.25209057331085205,
                    -0.01653054542839527, 0.3152623176574707,
                    0.18491433560848236, -0.08356496691703796,
                    0.015053214505314827, -0.06609713286161423,
                    -0.11358388513326645, 0.1306494176387787,
                    0.031936027109622955, -0.061886198818683624,
                    -0.16529519855976105, -0.08583349734544754,
                    -0.010536311194300652, 0.2515212893486023,
                    -0.011902404949069023, -0.016803689301013947,
                    0.19987636804580688, -0.02860041707754135,
                    -0.08061570674180984, -0.012880970723927021,
                    -0.02579498291015625, -0.1535016894340515,
                    0.0004126857966184616, -0.10302852839231491,
                    -0.1345946490764618, 0.1509944051504135,
                    -0.1413564682006836, 0.011974706314504147,
                    0.1298234462738037, -0.18725024163722992,
                    0.11440719664096832, -0.029165081679821014,
                    -0.007875639945268631, 0.0028108423575758934,
                    -0.04890391603112221, -0.112337127327919,
                    0.09701915085315704, 0.2513290345668793,
                    -0.11775612831115723, 0.26878541707992554,
                    0.17422491312026978, 0.026127289980649948,
                    0.11150389909744263, 0.10970156639814377,
                    0.046743109822273254, -0.006068871356546879,
                    -0.0877358615398407, -0.21163393557071686,
                    -0.10006694495677948, 0.005273281596601009,
                    0.06249907985329628, -0.015550519339740276,
                    0.06635689735412598,
                ]).buffer
            ),
            picture_full: picturefull2.id,
            picture_single: picturesingle12.id,
            bounding_box: Buffer.from(
                new Int32Array([221, 117, 72, 72]).buffer
            ),
        },
    });
    const face13 = await prisma.face.create({
        data: {
            identity: identity13.id,
            embedding: Buffer.from(
                new Float64Array([
                    -0.1274425983428955, 0.05440405756235123,
                    0.04957346245646477, -0.09670839458703995,
                    -0.004530131816864014, -0.09696465730667114,
                    0.04381628334522247, -0.026990920305252075,
                    0.19976767897605896, 0.013317915610969067,
                    0.1694023460149765, 0.011606644839048386,
                    -0.20914384722709656, -0.058588650077581406,
                    0.01683567278087139, 0.05877715349197388,
                    -0.19275397062301636, -0.08469972759485245,
                    -0.10438351333141327, -0.11862695217132568,
                    0.03529158607125282, 0.03002433478832245,
                    0.10883135348558426, 0.015852242708206177,
                    -0.10193349421024323, -0.33757829666137695,
                    -0.06610733270645142, -0.19705721735954285,
                    0.07022571563720703, -0.10567770898342133,
                    0.05738229304552078, -0.004418672528117895,
                    -0.2437882125377655, -0.1045045554637909,
                    -0.01621372252702713, 0.052220508456230164,
                    -0.039999570697546005, -0.06106625497341156,
                    0.15697228908538818, -0.013404034078121185,
                    -0.132518008351326, 0.008544942364096642,
                    0.05738626420497894, 0.16088226437568665,
                    0.22450613975524902, 0.040522150695323944,
                    -0.01899612694978714, -0.05316633731126785,
                    0.08036144822835922, -0.23734425008296967,
                    0.12143288552761078, 0.10769524425268173,
                    0.028099749237298965, 0.10833775997161865,
                    0.09202826023101807, -0.13559426367282867,
                    0.03828377276659012, 0.07637009769678116,
                    -0.20340384542942047, 0.07187710702419281,
                    0.08269517868757248, -0.07859665900468826,
                    -0.05710327625274658, 0.0041447230614721775,
                    0.08162227272987366, 0.07655442506074905,
                    -0.07524241507053375, -0.1246567964553833,
                    0.049103979021310806, -0.16493633389472961,
                    -0.015430854633450508, 0.06728587299585342,
                    -0.08044926077127457, -0.139521524310112,
                    -0.2422052025794983, 0.10595438629388809,
                    0.34052741527557373, 0.13575445115566254,
                    -0.07839660346508026, 0.046669118106365204,
                    -0.1601872742176056, -0.01884898915886879,
                    0.007217164151370525, -0.02954857051372528,
                    -0.07123039662837982, -0.042513877153396606,
                    -0.10764271765947342, 0.04138992726802826,
                    0.07714466750621796, 0.008006278425455093,
                    -0.06157428398728371, 0.1501886248588562,
                    -0.09936538338661194, 0.04984606057405472,
                    0.00914696417748928, 0.08486690372228622,
                    -0.17164693772792816, 0.02693268656730652,
                    -0.10086214542388916, -0.042098887264728546,
                    0.07203605026006699, -0.08828487247228622,
                    -0.03397441282868385, 0.029017722234129906,
                    -0.1672852635383606, 0.10606248676776886,
                    -0.004072889219969511, -0.057313866913318634,
                    -0.0029367059469223022, 0.01074162870645523,
                    -0.0706024095416069, -0.005702754016965628,
                    0.10735200345516205, -0.2123836725950241,
                    0.31644120812416077, 0.20908121764659882,
                    -0.0005479864776134491, 0.1931459903717041,
                    0.06941983103752136, 0.04403923824429512,
                    -0.02534238062798977, 0.008894432336091995,
                    -0.11717250198125839, -0.06706836074590683,
                    0.011270157992839813, 0.10845416784286499,
                    0.05888531357049942, 0.034885987639427185,
                ]).buffer
            ),
            picture_full: picturefull2.id,
            picture_single: picturesingle13.id,
            bounding_box: Buffer.from(
                new Int32Array([101, 101, 72, 72]).buffer
            ),
        },
    });
    const face14 = await prisma.face.create({
        data: {
            identity: identity14.id,
            embedding: Buffer.from(
                new Float64Array([
                    -0.10626567900180817, 0.09472034126520157,
                    0.08861760050058365, 0.007974744774401188,
                    0.04083063825964928, -0.0890955850481987,
                    0.07137525081634521, -0.09543205797672272,
                    0.1684751957654953, -0.09415382146835327,
                    0.21354542672634125, -0.06820859014987946,
                    -0.12585890293121338, -0.1178978830575943,
                    0.10383475571870804, 0.12909777462482452,
                    -0.11333276331424713, -0.13845296204090118,
                    -0.1563192456960678, -0.1633514016866684,
                    -0.02564849704504013, 0.009868103079497814,
                    0.024429865181446075, 0.06479378789663315,
                    -0.08779667317867279, -0.24748080968856812,
                    -0.1299741566181183, -0.1807350516319275, 0.12515889108181,
                    -0.059118036180734634, 0.08768711984157562,
                    0.03440244495868683, -0.15381258726119995,
                    -0.030087504535913467, -0.037185750901699066,
                    -0.005165266804397106, 0.05976397916674614,
                    -0.015278052538633347, 0.16776469349861145,
                    0.005661992356181145, -0.13317681849002838,
                    -0.050722189247608185, -0.07877495884895325,
                    0.26300331950187683, 0.23338602483272552,
                    -0.02383415400981903, -0.007419111207127571,
                    0.016311263665556908, 0.06931832432746887,
                    -0.182011216878891, -0.016087718307971954,
                    0.0743715688586235, 0.08236751705408096,
                    0.049876563251018524, -0.022967666387557983,
                    -0.04941114783287048, -0.03000977635383606,
                    0.02096538618206978, -0.17958326637744904,
                    0.037302445620298386, 0.06578945368528366,
                    -0.20937423408031464, -0.1550924926996231,
                    0.012467458844184875, 0.169319748878479,
                    0.08864837884902954, -0.07823989540338516,
                    -0.19039519131183624, 0.2139556109905243,
                    -0.16561584174633026, -0.007030875887721777,
                    0.07969057559967041, -0.11794711649417877,
                    -0.05203653872013092, -0.230403333902359,
                    0.09401296079158783, 0.41857337951660156, 0.068735271692276,
                    -0.1717902570962906, 0.03637269139289856,
                    -0.21759015321731567, 0.06916377693414688,
                    -0.022999102249741554, 0.027145221829414368,
                    -0.041549380868673325, -0.04225722327828407,
                    -0.1308923214673996, 0.01898050308227539,
                    0.1157151535153389, -0.10113615542650223,
                    -0.029589535668492317, 0.17929919064044952,
                    -0.0673067718744278, 0.018477141857147217,
                    -0.01553148590028286, -0.01858040690422058,
                    -0.05574330687522888, -0.007292220368981361,
                    -0.06477490067481995, -0.08259279280900955,
                    0.10741822421550751, 0.00466229347512126,
                    0.042514245957136154, 0.05847074091434479,
                    -0.13682305812835693, 0.2111676186323166,
                    0.023324569687247276, 0.020404167473316193,
                    0.05317233130335808, 0.08416616916656494,
                    -0.07159922271966934, -0.08099733293056488,
                    0.1859709471464157, -0.13075166940689087,
                    0.12542292475700378, 0.16473130881786346,
                    -0.010402495972812176, 0.11264880001544952,
                    0.04827718809247017, 0.15917623043060303,
                    -0.05396133288741112, 0.0098474882543087,
                    -0.13531382381916046, -0.03882279992103577,
                    0.02998005971312523, 0.06862635910511017,
                    -0.029796689748764038, 0.03186481073498726,
                ]).buffer
            ),
            picture_full: picturefull2.id,
            picture_single: picturesingle14.id,
            bounding_box: Buffer.from(
                new Int32Array([557, 101, 72, 72]).buffer
            ),
        },
    });
    const face15 = await prisma.face.create({
        data: {
            identity: identity15.id,
            embedding: Buffer.from(
                new Float64Array([
                    -0.06506835669279099, 0.12295002490282059,
                    0.1205492690205574, -0.05039328336715698,
                    -0.04339763894677162, 0.036064621061086655,
                    -0.07094689458608627, -0.1595277339220047,
                    0.13262681663036346, -0.046046193689107895,
                    0.2252381592988968, -0.05117306113243103,
                    -0.19692665338516235, -0.0670645609498024,
                    -0.08968669921159744, 0.20044369995594025,
                    -0.17933478951454163, -0.08537010103464127,
                    -0.050310686230659485, -0.022224191576242447,
                    0.08189025521278381, 0.0014642201131209731,
                    0.06921161711215973, -0.03120671957731247,
                    -0.05761332809925079, -0.32884693145751953,
                    -0.1133260726928711, -0.046736910939216614,
                    0.0985272228717804, -0.05459390580654144,
                    -0.07579685747623444, 0.009056471288204193,
                    -0.16099533438682556, -0.05659743398427963,
                    0.020166968926787376, 0.05836573243141174,
                    -0.0042706942185759544, -0.0718802809715271,
                    0.1868394911289215, 0.0011202841997146606,
                    -0.19769734144210815, 0.10055708885192871,
                    0.05725797638297081, 0.1476895660161972,
                    0.22395005822181702, 0.050246305763721466,
                    0.04532758146524429, -0.17620167136192322,
                    0.054752763360738754, -0.1355646401643753,
                    -0.05772949755191803, 0.1669570952653885,
                    0.061336975544691086, 0.04523398354649544,
                    0.009386472404003143, -0.053089357912540436,
                    0.03533860296010971, 0.11994733661413193,
                    -0.1087338998913765, 0.01224756520241499,
                    0.10248648375272751, -0.10142888128757477,
                    -0.023909855633974075, -0.0023118648678064346,
                    0.13627231121063232, 0.04436419531702995,
                    -0.06601361930370331, -0.19628944993019104,
                    0.15394526720046997, -0.09031189978122711,
                    -0.11267195641994476, 0.03653140366077423,
                    -0.12211776524782181, -0.12191148102283478,
                    -0.28044626116752625, -0.008130732923746109,
                    0.44996264576911926, 0.0660206750035286,
                    -0.19935865700244904, 0.09740003943443298,
                    -0.0760323777794838, -0.007612390443682671,
                    0.12803207337856293, 0.11384902894496918,
                    -0.06656278669834137, -0.026018990203738213,
                    -0.07761162519454956, -0.03624027222394943,
                    0.2066258043050766, -0.04465162009000778,
                    0.019596636295318604, 0.17128704488277435,
                    0.017411593347787857, 0.1210993081331253,
                    0.03003932163119316, 0.07200541347265244,
                    -0.04294958338141441, 0.0572974793612957,
                    -0.1347346007823944, -0.058691635727882385,
                    0.04246431216597557, -0.031943097710609436,
                    0.041371263563632965, 0.12676922976970673,
                    -0.19502143561840057, 0.1114295944571495,
                    -0.009024908766150475, -0.006185425911098719,
                    0.07840371131896973, 0.023976316675543785,
                    -0.010792000219225883, -0.010795917361974716,
                    0.15469622611999512, -0.2374214231967926,
                    0.16279181838035583, 0.2671894133090973,
                    -0.0008043756242841482, 0.03802848234772682,
                    0.15531690418720245, 0.12034937739372253,
                    0.010518638417124748, 0.026202138513326645,
                    -0.18776962161064148, -0.06585819274187088,
                    0.03529489412903786, -0.04651434347033501,
                    0.030643384903669357, 0.01432068832218647,
                ]).buffer
            ),
            picture_full: picturefull2.id,
            picture_single: picturesingle15.id,
            bounding_box: Buffer.from(
                new Int32Array([534, 198, 87, 87]).buffer
            ),
        },
    });
    const face16 = await prisma.face.create({
        data: {
            identity: identity16.id,
            embedding: Buffer.from(
                new Float64Array([
                    -0.04140590503811836, 0.049649354070425034,
                    -0.02067989856004715, -0.05076811835169792,
                    -0.14976666867733002, -0.08061786741018295,
                    0.019402552396059036, -0.18232886493206024,
                    0.1207430437207222, -0.08818063884973526, 0.12371876090765,
                    -0.05344335734844208, -0.2804890275001526,
                    -0.14318405091762543, 0.04758526384830475,
                    0.061636049300432205, -0.14288561046123505,
                    -0.07295693457126617, -0.2190050333738327,
                    -0.1366390883922577, -0.03133338317275047,
                    0.06637683510780334, 0.1095065325498581,
                    -0.037315234541893005, -0.07901723682880402,
                    -0.4088205099105835, -0.08998822420835495,
                    -0.04321330785751343, 0.07070690393447876,
                    0.01363934762775898, 0.10405141115188599,
                    0.16385434567928314, -0.193526491522789,
                    -0.09171134233474731, -0.011596187949180603,
                    -0.00945630669593811, -0.07787761837244034,
                    -0.045090094208717346, 0.14477580785751343,
                    -0.012610232457518578, -0.18896739184856415,
                    -0.02492128312587738, -0.0010343361645936966,
                    0.17045725882053375, 0.22648194432258606,
                    -0.01081682089716196, 0.03772783279418945,
                    -0.11609532684087753, 0.0920756533741951,
                    -0.21439039707183838, 0.012428520247340202,
                    0.18025223910808563, 0.1021026074886322,
                    0.0025921761989593506, 0.11720144003629684,
                    -0.05258139967918396, 0.028399016708135605,
                    0.11455099284648895, -0.2667990028858185,
                    -0.001472150208428502, 0.09983916580677032,
                    -0.11736385524272919, -0.06857871264219284,
                    -0.0773627832531929, 0.12281864881515503,
                    0.1171419769525528, -0.0578288808465004,
                    -0.09650182723999023, 0.1847001165151596,
                    -0.18025445938110352, -0.003081172239035368,
                    0.03463121876120567, -0.07124291360378265,
                    -0.19859176874160767, -0.2681810259819031,
                    0.024311916902661324, 0.3540894389152527,
                    0.1751251518726349, -0.111127108335495,
                    -0.010253841988742352, -0.12043162435293198,
                    -0.0018610190600156784, 0.0942433774471283,
                    -0.019338615238666534, -0.1354033201932907,
                    -0.11410393565893173, -0.04884789139032364,
                    0.08814084529876709, 0.11320986598730087,
                    -0.07513757795095444, -0.08101080358028412,
                    0.2566007971763611, 0.01866612769663334,
                    -0.00028231553733348846, 0.04616454988718033,
                    -0.002362515777349472, -0.10511912405490875,
                    0.04857249557971954, -0.09029348194599152,
                    0.0646161139011383, 0.13711081445217133,
                    -0.16760040819644928, 0.09597866237163544,
                    0.007513765245676041, -0.05516968294978142,
                    0.18374928832054138, 0.0033039499539881945,
                    0.008818475529551506, 0.06709745526313782,
                    -0.10391589999198914, -0.09790568053722382,
                    -0.02775111421942711, 0.1645895540714264,
                    -0.22596733272075653, 0.27179980278015137,
                    0.11700475960969925, -0.05085063353180885,
                    0.2117108702659607, 0.0473460853099823, 0.11080020666122437,
                    -0.048490822315216064, -0.0798875093460083,
                    -0.07986918836832047, -0.09268683940172195,
                    0.09616371244192123, 0.008976544253528118,
                    0.04611557722091675, 0.02706117555499077,
                ]).buffer
            ),
            picture_full: picturefull2.id,
            picture_single: picturesingle16.id,
            bounding_box: Buffer.from(
                new Int32Array([101, 221, 72, 72]).buffer
            ),
        },
    });
    const face17 = await prisma.face.create({
        data: {
            identity: identity17.id,
            embedding: Buffer.from(
                new Float64Array([
                    -0.14455245435237885, 0.006127643398940563,
                    0.01918071135878563, -0.059116579592227936,
                    -0.1472500115633011, 0.011969022452831268,
                    0.017068060114979744, -0.08502824604511261,
                    0.10996045917272568, -0.044452596455812454,
                    0.18713054060935974, 0.0764879509806633,
                    -0.29542794823646545, 0.029862606897950172,
                    -0.07005913555622101, 0.09706425666809082,
                    -0.07051213085651398, -0.1254590004682541,
                    -0.1759001463651657, -0.19640235602855682,
                    -0.02108069695532322, -0.005289993714541197,
                    -0.005410941317677498, 0.08342400193214417,
                    -0.13098788261413574, -0.1550997793674469,
                    -0.08723852783441544, -0.13537918031215668,
                    0.08479902148246765, -0.16780538856983185,
                    0.06498387455940247, -0.07354524731636047,
                    -0.09758852422237396, -0.051675621420145035,
                    0.001471041701734066, 0.0014672409743070602,
                    -0.09853533655405045, -0.12475240230560303,
                    0.2793842852115631, -0.011909706518054008,
                    -0.1355239301919937, 0.07863691449165344,
                    0.049414798617362976, 0.3517013192176819,
                    0.16174446046352386, -0.03596124425530434,
                    0.07254409790039063, -0.021157901734113693,
                    0.14481909573078156, -0.2712373733520508,
                    0.0585048533976078, 0.14222826063632965, 0.167252779006958,
                    0.04447730630636215, 0.10313358902931213,
                    -0.1736457347869873, -0.0132349394261837,
                    0.2574132978916168, -0.17646276950836182,
                    0.20687270164489746, 0.02216067537665367,
                    -0.06435489654541016, -0.057117849588394165,
                    -0.1228417232632637, 0.19242621958255768,
                    0.11211644113063812, -0.17172212898731232,
                    -0.16201454401016235, 0.1872095912694931,
                    -0.142628014087677, -0.06566499918699265,
                    0.0959329754114151, -0.1686566323041916,
                    -0.16105858981609344, -0.20386840403079987,
                    0.07742939889431, 0.37309882044792175, 0.1340295821428299,
                    -0.1513509303331375, 0.015268095768988132,
                    -0.12091702222824097, 0.007173215504735708,
                    -0.08039689809083939, 0.013580245897173882,
                    -0.08597224205732346, -0.08233863860368729,
                    -0.052545562386512756, 0.007443979382514954,
                    0.1881214678287506, -0.0051871733739972115,
                    -0.03041643463075161, 0.1837909072637558,
                    0.04109080135822296, -0.10727392882108688,
                    0.011514304205775261, 0.08813812583684921,
                    -0.19228065013885498, -0.06096074357628822,
                    -0.050819315016269684, -0.026618126779794693,
                    0.0484800711274147, -0.18343351781368256,
                    0.0979660227894783, 0.04825162887573242,
                    -0.20686587691307068, 0.22404584288597107,
                    -0.051148876547813416, 0.015942569822072983,
                    -0.03058403916656971, 0.04027657210826874,
                    -0.11259584128856659, 0.06923413276672363,
                    0.25678151845932007, -0.2789524793624878,
                    0.29447782039642334, 0.22815975546836853,
                    0.06792108714580536, 0.057000912725925446,
                    0.0608857162296772, 0.004681505262851715,
                    -0.01735261082649231, 0.08004467934370041,
                    -0.12259341031312943, -0.11870177090167999,
                    -0.023702068254351616, -0.113726407289505,
                    0.05555823817849159, 0.07539499551057816,
                ]).buffer
            ),
            picture_full: picturefull2.id,
            picture_single: picturesingle17.id,
            bounding_box: Buffer.from(new Int32Array([21, 77, 72, 72]).buffer),
        },
    });
    const face18 = await prisma.face.create({
        data: {
            identity: identity18.id,
            embedding: Buffer.from(
                new Float64Array([
                    0.001347551355138421, 0.03915585204958916,
                    0.10329438745975494, -0.08984021842479706,
                    -0.006895882077515125, -0.07366327941417694,
                    0.049019549041986465, -0.07810233533382416,
                    0.09743143618106842, -0.12059962749481201,
                    0.20636947453022003, -0.002232709899544716,
                    -0.25921013951301575, -0.026866985484957695,
                    0.016013966873288155, 0.12015730142593384,
                    -0.10276284068822861, -0.1296517699956894,
                    -0.15611986815929413, -0.09686272591352463,
                    -0.008331941440701485, 0.025662459433078766,
                    0.08709663152694702, -0.0039029084146022797,
                    -0.13929474353790283, -0.28862422704696655,
                    -0.0660262256860733, -0.10324540734291077,
                    0.030327994376420975, -0.0977122113108635,
                    0.04888318479061127, -0.022565491497516632,
                    -0.1195782870054245, -0.06779620051383972,
                    0.015447479672729969, 0.04644690454006195,
                    -0.04551916569471359, -0.14961303770542145,
                    0.2885179817676544, 0.055701158940792084,
                    -0.1519085317850113, 0.06696557253599167,
                    0.021613553166389465, 0.29226061701774597,
                    0.1825753152370453, -0.032537318766117096,
                    0.07036914676427841, -0.05651155114173889,
                    0.12088897079229355, -0.26627373695373535,
                    0.09894657880067825, 0.03777971863746643,
                    0.12237907201051712, 0.06962944567203522,
                    0.12029256671667099, -0.12048682570457458,
                    0.023486195132136345, 0.1603209376335144,
                    -0.18281224370002747, 0.06706809252500534,
                    0.07586392760276794, -0.03323861211538315,
                    0.0050288597121834755, -0.08423904329538345,
                    0.15895487368106842, 0.04277842491865158,
                    -0.1629529893398285, -0.006693067029118538,
                    0.10576416552066803, -0.11298910528421402,
                    -0.04546869918704033, -0.03248675912618637,
                    -0.1254255324602127, -0.07754421979188919,
                    -0.27134549617767334, 0.06498216837644577,
                    0.2823219299316406, 0.14042988419532776,
                    -0.20302660763263702, -0.07242348790168762,
                    -0.06902004778385162, 0.053686290979385376,
                    0.027941569685935974, 0.03893442824482918,
                    -0.07089076191186905, -0.05388471484184265,
                    -0.05325176194310188, 0.005311259999871254,
                    0.12264208495616913, -0.010354075580835342,
                    -0.08731751143932343, 0.15320411324501038,
                    -0.026391630992293358, -0.02292645536363125,
                    0.04255448654294014, 0.06126968562602997,
                    -0.2120780050754547, -0.03360370546579361,
                    -0.13154636323451996, 0.02499120682477951,
                    0.03207039833068848, -0.11479146778583527,
                    0.01845150627195835, 0.14455847442150116,
                    -0.18765567243099213, 0.16092456877231598,
                    -0.06880607455968857, -0.08181486278772354,
                    0.04946646839380264, 0.0809822604060173,
                    -0.09133398532867432, -0.05468428507447243,
                    0.11952178180217743, -0.17199674248695374,
                    0.1462048441171646, 0.24960187077522278,
                    -0.032002825289964676, 0.10107317566871643,
                    0.08167654275894165, 0.05152951553463936,
                    -0.050430599600076675, 0.11302195489406586,
                    -0.15543122589588165, -0.12367966771125793,
                    0.003992676269263029, 0.07484374195337296,
                    0.09499545395374298, 0.028549186885356903,
                ]).buffer
            ),
            picture_full: picturefull2.id,
            picture_single: picturesingle18.id,
            bounding_box: Buffer.from(new Int32Array([381, 54, 86, 87]).buffer),
        },
    });
    const face19 = await prisma.face.create({
        data: {
            identity: identity19.id,
            embedding: Buffer.from(
                new Float64Array([
                    -0.08361602574586868, 0.039230745285749435,
                    0.13893015682697296, 0.019414030015468597,
                    -0.1139121875166893, -0.05235147476196289,
                    -0.007231363095343113, -0.17362698912620544,
                    0.03054693527519703, -0.08020759373903275,
                    0.21525079011917114, -0.12463589012622833,
                    -0.17432919144630432, -0.026240672916173935,
                    0.0010266322642564774, 0.1670219600200653,
                    -0.14711813628673553, -0.160709947347641,
                    -0.0509292334318161, -0.0386015847325325,
                    0.07218105345964432, 0.0326753631234169,
                    -0.013887335546314716, -0.03242066875100136,
                    -0.06751647591590881, -0.3166319727897644,
                    -0.09025847911834717, -0.04985330253839493,
                    0.13477438688278198, -0.03839537873864174,
                    -0.041632190346717834, 0.06711050122976303,
                    -0.2159939408302307, -0.07614801824092865,
                    0.054622832685709, 0.0840669497847557,
                    -0.026025090366601944, -0.09774511307477951,
                    0.1526833027601242, -0.0674237459897995,
                    -0.2776484787464142, 0.019024232402443886,
                    0.11326438933610916, 0.2175998091697693,
                    0.19425921142101288, 0.013324307277798653,
                    -0.0031277425587177277, -0.08509056270122528,
                    0.039081137627363205, -0.1414303183555603,
                    0.06280380487442017, 0.11146575212478638,
                    0.036299608647823334, 0.08770467340946198,
                    0.029935142025351524, -0.12399469316005707,
                    0.042551230639219284, 0.09621495753526688,
                    -0.11141711473464966, 0.03484729304909706,
                    0.19440610706806183, -0.07578614354133606,
                    0.04404504969716072, -0.048949550837278366,
                    0.1398971527814865, -0.020270854234695435,
                    -0.013279804959893227, -0.20145101845264435,
                    0.11040908098220825, -0.15107697248458862,
                    -0.09894541651010513, 0.06627373397350311,
                    -0.145269975066185, -0.10836604982614517,
                    -0.3094491958618164, -0.001155739650130272,
                    0.40160253643989563, 0.05819707363843918,
                    -0.15658628940582275, 0.08870463073253632,
                    0.02261233888566494, 0.003658234141767025,
                    0.21332944929599762, 0.09346318244934082,
                    0.04271923750638962, 0.0333251878619194,
                    -0.10505007952451706, -0.009131351485848427,
                    0.2416125386953354, -0.03549014776945114,
                    -0.024976221844553947, 0.18289919197559357,
                    -0.03799305856227875, -0.04600086435675621,
                    0.0915580540895462, 0.05826899781823158,
                    -0.017600588500499725, 0.024055108428001404,
                    -0.16672660410404205, -0.06620552390813828,
                    0.03742878884077072, -0.05766306072473526,
                    -0.015225423499941826, 0.16472575068473816,
                    -0.17663803696632385, 0.12316567450761795,
                    -0.017239753156900406, 0.08107517659664154,
                    0.02445177733898163, -0.029708364978432655,
                    -0.0712505355477333, -0.022499514743685722,
                    0.1298438012599945, -0.20051681995391846,
                    0.15778079628944397, 0.19642096757888794,
                    0.018338199704885483, 0.04581413418054581,
                    0.0942000076174736, 0.06808646023273468,
                    -0.0017537791281938553, -0.003271954134106636,
                    -0.23520849645137787, -0.04388856142759323,
                    0.07099020481109619, -0.013226490467786789,
                    0.0369626060128212, 0.06311903893947601,
                ]).buffer
            ),
            picture_full: picturefull2.id,
            picture_single: picturesingle19.id,
            bounding_box: Buffer.from(new Int32Array([165, 61, 72, 72]).buffer),
        },
    });
    const face20 = await prisma.face.create({
        data: {
            identity: null,
            embedding: Buffer.from(
                new Float64Array([
                    -0.07159972190856934, 0.013931511901319027,
                    0.07105563580989838, -0.061572059988975525,
                    -0.10288727283477783, -0.059170182794332504,
                    -0.08201517909765244, -0.1075863167643547,
                    0.18071171641349792, -0.1264810413122177,
                    0.1820729523897171, -0.04219195991754532,
                    -0.13955816626548767, -0.060289110988378525,
                    -0.0061845676973462105, 0.19099943339824677,
                    -0.18344318866729736, -0.12930066883563995,
                    -0.03742679953575134, 0.01837158203125, 0.0639314129948616,
                    -0.041906703263521194, 0.06387893855571747,
                    0.06125213950872421, -0.12216845154762268,
                    -0.38829687237739563, -0.11199361085891724,
                    -0.08531858026981354, -0.002937628887593746,
                    -0.0015375098446384072, -0.08155020326375961,
                    0.05627104267477989, -0.18256492912769318,
                    -0.07729373872280121, 0.021021338179707527,
                    0.12011329084634781, -0.0132465660572052,
                    -0.11417976766824722, 0.18661992251873016,
                    -0.02752555161714554, -0.3187643885612488,
                    -0.0016136621125042439, 0.05726936459541321,
                    0.17066186666488647, 0.12135785073041916,
                    0.0680198147892952, 0.06177841126918793,
                    -0.09982644021511078, 0.09712836891412735,
                    -0.17379331588745117, 0.0936511680483818,
                    0.1306428164243698, 0.015691440552473068,
                    0.06262707710266113, 0.025399498641490936,
                    -0.1307777613401413, 0.06068069115281105,
                    0.11941009014844894, -0.1305248886346817,
                    -0.03424109145998955, 0.09480679035186768,
                    -0.04356683790683746, 0.0288722962141037,
                    -0.10762755572795868, 0.23659230768680573,
                    0.15592265129089355, -0.08125282824039459,
                    -0.16049636900424957, 0.09304965287446976,
                    -0.13397018611431122, -0.09671754390001297,
                    0.032068341970443726, -0.16488340497016907,
                    -0.1734704226255417, -0.33759239315986633,
                    -0.028516175225377083, 0.4009455442428589,
                    0.13673405349254608, -0.1400497853755951,
                    0.035126928240060806, -0.0708676353096962,
                    -0.019837263971567154, 0.1228552982211113,
                    0.17880411446094513, 0.011489640921354294,
                    0.10794568806886673, -0.04185723140835762,
                    -0.0029098447412252426, 0.22537584602832794,
                    -0.03984461724758148, -0.026997186243534088,
                    0.18782199919223785, 0.006819184869527817,
                    0.07049816846847534, -0.007737088017165661,
                    0.023311259225010872, -0.04680751636624336,
                    0.06360045820474625, -0.1350875198841095,
                    0.017196279019117355, 0.05108186602592468,
                    0.03376200050115585, 0.005745152942836285,
                    0.10839495062828064, -0.21548405289649963,
                    0.0997154489159584, 0.002794726751744747,
                    0.0005115587264299393, 0.043117303401231766,
                    0.05340467393398285, -0.08911125361919403,
                    -0.10196010023355484, 0.10693702101707458,
                    -0.21718089282512665, 0.16672948002815247,
                    0.21911972761154175, 0.07546328753232956,
                    0.1426752805709839, 0.10669108480215073,
                    0.09565725177526474, -0.008750401437282562,
                    -0.0333721786737442, -0.22724325954914093,
                    -0.002605196787044406, 0.11101125180721283,
                    0.002452651970088482, 0.08837974071502686,
                    0.06285282224416733,
                ]).buffer
            ),
            picture_full: picturefull3.id,
            picture_single: picturesingle20.id,
            bounding_box: Buffer.from(
                new Int32Array([710, 1154, 1331, 1331]).buffer
            ),
        },
    });
    const face21 = await prisma.face.create({
        data: {
            identity: identity20.id,
            embedding: Buffer.from(
                new Float64Array([
                    -0.136684849858284, 0.10100702941417694,
                    0.02102765627205372, -0.034587204456329346,
                    -0.04388761892914772, -0.11670725792646408,
                    -0.01692645624279976, -0.1711784303188324,
                    0.1644241064786911, -0.06816035509109497,
                    0.2572038471698761, -0.031543392688035965,
                    -0.14809317886829376, -0.1285386085510254,
                    0.00555503461509943, 0.1575871706008911,
                    -0.18834996223449707, -0.09386374056339264,
                    -0.01261298730969429, -0.027147890999913216,
                    0.054473359137773514, -0.016641909256577492,
                    0.07012544572353363, 0.08588386327028275,
                    -0.13704949617385864, -0.3343013525009155,
                    -0.11595857888460159, -0.1188928633928299,
                    -0.03177983686327934, -0.002247212454676628,
                    -0.016956286504864693, 0.08735940605401993,
                    -0.20755165815353394, -0.07376547157764435,
                    0.0022048698738217354, 0.10632520914077759,
                    -0.013501967303454876, -0.02144983410835266,
                    0.19946494698524475, -0.012934056110680103,
                    -0.2009081244468689, -0.02990792877972126,
                    0.08402910083532333, 0.22578564286231995,
                    0.2015598863363266, 0.02230725809931755,
                    0.04823848605155945, -0.08214975893497467,
                    0.05925046652555466, -0.13644541800022125,
                    0.012372646480798721, 0.07621056586503983,
                    0.037706125527620316, 0.07838654518127441,
                    -0.04398356005549431, -0.15363554656505585,
                    0.022396355867385864, 0.05244431272149086,
                    -0.10005104541778564, -0.02786054089665413,
                    0.052651356905698776, -0.13138385117053986,
                    -0.0672026127576828, 0.0012504798360168934,
                    0.28830868005752563, 0.13036781549453735,
                    -0.09270770102739334, -0.1429179161787033,
                    0.09705805033445358, -0.1735347956418991,
                    -0.11434844136238098, 0.08935967087745667,
                    -0.16468320786952972, -0.14732134342193604,
                    -0.3558614253997803, 0.006109120324254036,
                    0.40541544556617737, 0.06418517231941223,
                    -0.17369861900806427, 0.021320607513189316,
                    -0.07648565620183945, 0.011516009457409382,
                    0.14402136206626892, 0.16260088980197906,
                    -0.010761315003037453, 0.05545321851968765,
                    -0.11076220870018005, 0.010191456414759159,
                    0.2566970884799957, -0.040582966059446335,
                    -0.08605015277862549, 0.1849537044763565,
                    0.001241559162735939, 0.1302625834941864,
                    0.02216455154120922, 0.006730666384100914,
                    0.010605083778500557, 0.016154490411281586,
                    -0.12883102893829346, -0.012427590787410736,
                    0.06552325934171677, 0.009456062689423561,
                    -0.03361305221915245, 0.11357592046260834,
                    -0.19228224456310272, 0.10660131275653839,
                    0.050343338400125504, 0.011703118681907654,
                    0.0065445126965641975, 0.017785048112273216,
                    -0.07215770334005356, -0.060297641903162,
                    0.1173233613371849, -0.19473546743392944,
                    0.22699186205863953, 0.1901482343673706,
                    0.02529396302998066, 0.14738455414772034,
                    0.08316533267498016, 0.07573164999485016,
                    -0.0517120324075222, -0.004033506847918034,
                    -0.17119437456130981, 0.015182161703705788,
                    0.10054056346416473, -0.0058033703826367855,
                    0.14322571456432343, 0.00211996678262949,
                ]).buffer
            ),
            picture_full: picturefull4.id,
            picture_single: picturesingle21.id,
            bounding_box: Buffer.from(
                new Int32Array([485, 435, 445, 446]).buffer
            ),
        },
    });
    const face22 = await prisma.face.create({
        data: {
            identity: null,
            embedding: Buffer.from(
                new Float64Array([
                    -0.15658831596374512, 0.09326855093240738,
                    0.0844271332025528, -0.023102739825844765,
                    -0.04672691226005554, -0.032108232378959656,
                    -0.02918119914829731, -0.055920593440532684,
                    0.1390305906534195, -0.06857739388942719,
                    0.22373554110527039, -0.022741233929991722,
                    -0.2566036283969879, -0.12094703316688538,
                    -0.01870916783809662, 0.19930090010166168,
                    -0.15561909973621368, -0.15218251943588257,
                    -0.00582458171993494, 0.014269508421421051,
                    0.05351061746478081, -0.04963662475347519,
                    0.023189455270767212, 0.08074862509965897,
                    -0.12184088677167892, -0.38236087560653687,
                    -0.0928635224699974, -0.08310700953006744,
                    -0.014568276703357697, -0.011151610873639584,
                    -0.07885877043008804, 0.08268892765045166,
                    -0.18252630531787872, -0.043620072305202484,
                    -0.030141256749629974, 0.08063693344593048,
                    -0.008191417902708054, -0.012289253994822502,
                    0.18560564517974854, 0.02496575564146042,
                    -0.2149561494588852, -0.03386804461479187,
                    0.035981740802526474, 0.2975548207759857,
                    0.20949208736419678, 0.06657286733388901,
                    0.05946877598762512, -0.06260641664266586,
                    0.029898814857006073, -0.17273417115211487,
                    0.0014851242303848267, 0.1428297609090805,
                    0.13524283468723297, 0.04426490515470505,
                    -0.047484636306762695, -0.10920386016368866,
                    -0.017145752906799316, 0.0735415667295456,
                    -0.13902266323566437, -0.001714303158223629,
                    0.009543446823954582, -0.11433851718902588,
                    -0.08104576170444489, -0.0918494462966919,
                    0.3376235365867615, 0.06972166150808334,
                    -0.15268850326538086, -0.15502594411373138,
                    0.17563612759113312, -0.122788205742836,
                    -0.08984095603227615, 0.06077917665243149,
                    -0.18805433809757233, -0.1472659707069397,
                    -0.3356366753578186, 0.06698040664196014,
                    0.3359529674053192, 0.07726806402206421,
                    -0.17224238812923431, 0.07686220854520798,
                    -0.12130036950111389, 0.01322408951818943,
                    0.05780164897441864, 0.16736365854740143,
                    -0.027845874428749084, 0.014337819069623947,
                    -0.08178621530532837, -0.011352000758051872,
                    0.19441968202590942, -0.08630465716123581,
                    -0.029185274615883827, 0.15832729637622833,
                    0.021768417209386826, 0.07550092041492462,
                    -0.027249189093708992, -0.0036604199558496475,
                    -0.015773292630910873, 0.05617930367588997,
                    -0.13851799070835114, -0.02379683405160904,
                    0.06446389853954315, 0.01772996038198471,
                    0.0322975255548954, 0.10569596290588379,
                    -0.15897543728351593, 0.04807831346988678,
                    0.0450434684753418, 0.028375916182994843,
                    0.09569965302944183, 0.04728022217750549,
                    -0.15994778275489807, -0.16937364637851715,
                    0.10552414506673813, -0.2599008083343506,
                    0.17457956075668335, 0.21429044008255005,
                    0.04770766943693161, 0.06931447237730026,
                    0.14206096529960632, 0.10745331645011902,
                    -0.0007279682904481888, 0.011970562860369682,
                    -0.18121077120304108, 0.022326741367578506,
                    0.1906379908323288, -0.032058946788311005,
                    0.08018794655799866, 0.011018089950084686,
                ]).buffer
            ),
            picture_full: picturefull5.id,
            picture_single: picturesingle22.id,
            bounding_box: Buffer.from(
                new Int32Array([448, 687, 215, 215]).buffer
            ),
        },
    });
    const face23 = await prisma.face.create({
        data: {
            identity: null,
            embedding: Buffer.from(
                new Float64Array([
                    -0.16780324280261993, 0.08232703059911728,
                    0.08511053770780563, -0.044125303626060486,
                    -0.07439149171113968, -0.08085962384939194,
                    -0.0739477202296257, -0.15962734818458557,
                    0.09607946127653122, -0.06995181739330292,
                    0.2909013032913208, -0.07253381609916687,
                    -0.1799919307231903, -0.1427363008260727,
                    -0.027030430734157562, 0.16678465902805328,
                    -0.21629419922828674, -0.10623934119939804,
                    -0.038335204124450684, -0.05646708607673645,
                    0.0418987013399601, -0.027920151129364967,
                    0.11767125874757767, 0.060592155903577805,
                    -0.07131823897361755, -0.4245339632034302,
                    -0.10857914388179779, -0.16643968224525452,
                    0.0851355642080307, -0.018553568050265312,
                    -0.07358463108539581, 0.03226768225431442,
                    -0.24486178159713745, -0.07179781794548035,
                    -0.02226801961660385, 0.09620030224323273,
                    0.024250388145446777, -0.02136056497693062,
                    0.19072678685188293, -0.04626218229532242,
                    -0.18165192008018494, -0.012977376580238342,
                    0.03747545927762985, 0.20537859201431274,
                    0.18514956533908844, 0.08684372156858444,
                    0.08195169270038605, -0.09740833193063736,
                    0.09565302729606628, -0.14409734308719635,
                    0.08912830799818039, 0.09701969474554062,
                    0.1273626685142517, -0.0031131822615861893,
                    -0.009075365029275417, -0.16939027607440948,
                    -0.015500414185225964, 0.06763654202222824,
                    -0.08687194436788559, 0.023038554936647415,
                    0.08537356555461884, -0.03665328770875931,
                    -0.0029747402295470238, -0.049571890383958817,
                    0.3127557933330536, 0.10213799774646759,
                    -0.10220856219530106, -0.10732349753379822,
                    0.117400623857975, -0.12705464661121368,
                    -0.000649760477244854, 0.058632366359233856,
                    -0.16808541119098663, -0.11365453898906708,
                    -0.33081290125846863, 0.024528350681066513,
                    0.4151984453201294, 0.00962577760219574,
                    -0.1662205308675766, -0.018615245819091797,
                    -0.14548061788082123, -0.004924418404698372,
                    0.09019874036312103, 0.08790338039398193,
                    -0.10908830165863037, 0.047894224524497986,
                    -0.1362500935792923, 0.004097502678632736,
                    0.24649861454963684, -0.08002182841300964,
                    -0.005543557461351156, 0.1950809210538864,
                    -0.02752586454153061, 0.11660616099834442,
                    0.0190359428524971, 0.010900063440203667,
                    -0.06578430533409119, 0.006512495223432779,
                    -0.0936443880200386, 0.036886066198349,
                    -0.008613448590040207, -0.05953359603881836,
                    -0.03863302245736122, 0.06464671343564987,
                    -0.1912636160850525, 0.01623014360666275,
                    -0.013646668754518032, 0.0028230613097548485,
                    -0.004360603634268045, 0.002759977476671338,
                    -0.12279248982667923, -0.13411583006381989,
                    0.1471043974161148, -0.18935687839984894,
                    0.18284189701080322, 0.22294948995113373,
                    0.05570564419031143, 0.1610821634531021,
                    0.12045377492904663, 0.10065118968486786,
                    -0.050736237317323685, -0.0035280873998999596,
                    -0.16039864718914032, 0.023869765922427177,
                    0.14159244298934937, -0.03870965540409088,
                    0.06650974601507187, 0.02325192093849182,
                ]).buffer
            ),
            picture_full: picturefull6.id,
            picture_single: picturesingle23.id,
            bounding_box: Buffer.from(
                new Int32Array([336, 542, 310, 310]).buffer
            ),
        },
    });
    const face24 = await prisma.face.create({
        data: {
            identity: null,
            embedding: Buffer.from(
                new Float64Array([
                    -0.11066855490207672, 0.09788023680448532,
                    0.059338249266147614, -0.0985684022307396,
                    -0.16609184443950653, -0.028835605829954147,
                    -0.0398314967751503, -0.06921912729740143,
                    0.22377938032150269, -0.21231642365455627,
                    0.18069705367088318, -0.08120013028383255,
                    -0.20425286889076233, 0.035279493778944016,
                    -0.01128374319523573, 0.22028416395187378,
                    -0.13239005208015442, -0.17877818644046783,
                    -0.041704703122377396, -0.024766700342297554,
                    0.12335419654846191, 0.04617230221629143,
                    -0.013879368081688881, 0.04295017942786217,
                    -0.08887626230716705, -0.3266548812389374,
                    -0.0947401151061058, 0.0016397200524806976,
                    -0.029276952147483826, -0.09096670895814896,
                    -0.020212218165397644, 0.11628163605928421,
                    -0.18993832170963287, -0.038755789399147034,
                    -0.023382985964417458, 0.07622937858104706,
                    -0.0024385342840105295, -0.05624362453818321,
                    0.1634979546070099, -0.04002892225980759,
                    -0.332686185836792, 0.0027048871852457523,
                    0.1040956899523735, 0.23105859756469727,
                    0.16131235659122467, 0.03125959634780884,
                    -0.027178185060620308, -0.1074376255273819,
                    0.07964153587818146, -0.1785721331834793,
                    0.021274156868457794, 0.12859298288822174,
                    0.05426154285669327, 0.04750455543398857,
                    0.015033137984573841, -0.13408806920051575,
                    0.04448976367712021, 0.0693945586681366,
                    -0.12115630507469177, -0.027559975162148476,
                    0.13341212272644043, -0.1126682385802269,
                    0.02324260026216507, -0.09945135563611984,
                    0.29526323080062866, 0.07174509763717651,
                    -0.06815113872289658, -0.19693072140216827,
                    0.1715192347764969, -0.11942651122808456,
                    -0.1290363073348999, 0.07790200412273407,
                    -0.2034597098827362, -0.13744455575942993,
                    -0.3308187425136566, -0.0310529675334692, 0.36182701587677,
                    0.06737612932920456, -0.11577613651752472,
                    0.12317118793725967, -0.012831715866923332,
                    0.02104458585381508, 0.09350431710481644,
                    0.19485251605510712, 0.01102943904697895,
                    0.02560408040881157, -0.07254571467638016,
                    0.05979873239994049, 0.26851582527160645,
                    -0.07327460497617722, -0.07557346671819687,
                    0.1906849592924118, 0.03546500951051712,
                    0.052810780704021454, -0.002572398167103529,
                    0.02835185080766678, -0.027807161211967468,
                    0.006486412137746811, -0.18535491824150085,
                    0.01174096204340458, -0.001910720020532608,
                    0.023331793025135994, -0.06602707505226135,
                    0.19730320572853088, -0.154066264629364,
                    0.12731118500232697, -0.014780228957533836,
                    0.03916102275252342, -0.05360810458660126,
                    0.0714394748210907, -0.07250697165727615,
                    -0.07412400841712952, 0.07425922155380249,
                    -0.18072564899921417, 0.15914982557296753,
                    0.14973555505275726, 0.04629822075366974,
                    0.08637896925210953, 0.08541526645421982,
                    0.10110949724912643, 0.025605399161577225,
                    -0.0005240188911557198, -0.25858211517333984,
                    -0.013318593613803387, 0.14671576023101807,
                    -0.031922418624162674, 0.1030266135931015,
                    0.10104545950889587,
                ]).buffer
            ),
            picture_full: picturefull7.id,
            picture_single: picturesingle24.id,
            bounding_box: Buffer.from(
                new Int32Array([651, 981, 372, 372]).buffer
            ),
        },
    });

    // Define timestamp
    const startDate = new Date("2024-01-01T00:00:00Z"); // Start date
    const endDate = new Date("2024-12-18T23:59:59Z"); // End date

    // Create array dummy data
    const dummyData = Array.from({ length: 400 }).map(() => ({
        face: faker.number.int({ min: 1, max: 19 }), // Generate random faceId
        timestamp: faker.date.between({ from: startDate, to: endDate }), // Generate random timestamp
    }));

    // Detection log
    for (const data of dummyData) {
        await prisma.detection_Log.create({
            data: {
                face: data.face,
                timestamp: data.timestamp,
            },
        });
    }

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
