use ai::{video_processing, web_server};
use dotenvy::var;
use tokio::sync::mpsc;

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
        .db_name(Some(db_name)).into();

    let (tx, _rx) = mpsc::channel(128);

    tokio::spawn(web_server::run(db_opts.clone(), tx.clone()));
    tokio::spawn(video_processing::run(db_opts, tx));
}
