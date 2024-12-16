use ai::{model, video_processing, web_server};
use dotenvy::var;
use mysql::Pool;
use tokio::sync::{broadcast, mpsc};

#[tokio::main]
async fn main() {
    tracing_subscriber::fmt::init();

    let db_host = var("DB_HOST").unwrap();
    let db_port = var("DB_PORT").unwrap();
    let db_user = var("DB_USER").unwrap();
    let db_pass = var("DB_PASS").unwrap();
    let db_name = var("DB_NAME").unwrap();

    // let db_url = format!("mysql://{db_user}:{db_pass}@{db_host}:{db_port}/{db_name}");

    let db_opts: mysql::Opts = mysql::OptsBuilder::new()
        .ip_or_hostname(Some(db_host))
        .tcp_port(db_port.parse::<u16>().unwrap())
        .user(Some(db_user))
        .pass(Some(db_pass))
        .db_name(Some(db_name))
        .into();

    let db_pool = Pool::new(db_opts.clone()).unwrap();

    let (job_tx, job_rx) = mpsc::channel(128);
    let (detection_tx, detection_rx) = broadcast::channel::<(String, u64, u64)>(32);
    let (doorlock_tx, doorlock_rx) = broadcast::channel(32);

    let handler_webserver = tokio::spawn(web_server::run(
        db_pool.clone(),
        job_tx.clone(),
        detection_rx,
        doorlock_rx,
    ));
    let handler_aiservice = tokio::spawn(model::run(db_pool, job_rx));
    let handler_videoproc = tokio::spawn(video_processing::run(db_opts, job_tx, detection_tx, doorlock_tx));

    let _ = tokio::join!(handler_webserver, handler_aiservice, handler_videoproc);
}
