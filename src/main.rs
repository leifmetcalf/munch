use axum::{extract::State, response::Html, routing::get, Form, Router};
use chrono::naive::NaiveDate;
use minijinja::{context, Environment};
use serde::Deserialize;
use sqlx::postgres::{PgPoolOptions, PgPool};
use sqlx::prelude::*;
use std::error::Error;
use std::sync::Arc;
use tower_http::services::ServeDir;

struct AppState {
    template_env: Environment<'static>,
    pool: PgPool,
}

async fn index_handler(State(state): State<Arc<AppState>>) -> Html<String> {
    let tmpl = state.template_env.get_template("index.html").unwrap();
    Html(tmpl.render(context! {}).unwrap())
}

async fn show_log_handler(State(state): State<Arc<AppState>>) -> Html<String> {
    let tmpl = state.template_env.get_template("log.html").unwrap();
    Html(tmpl.render(context! {}).unwrap())
}

#[derive(Deserialize)]
struct LogForm {
    id: i32,
    restaurant_id: i32,
    text: String,
    date: NaiveDate,
}

async fn accept_log_handler(
    State(state): State<Arc<AppState>>,
    Form(form): Form<LogForm>,
) -> Html<String> {
    let tmpl = state.template_env.get_template("log.html").unwrap();
    sqlx::query!(
        "insert into logs (restaurant_id, text, date) values (($1), ($2), ($3))",
        form.restaurant_id,
        form.text,
        form.date
    )
    .execute(&state.pool)
    .await
    .unwrap();
    Html(tmpl.render(context! {}).unwrap())
}

#[tokio::main]
async fn main() -> Result<(), Box<dyn Error>> {
    let mut template_env = Environment::new();
    template_env
        .add_template("base.html", include_str!("templates/base.html"))?;
    template_env
        .add_template("index.html", include_str!("templates/index.html"))?;
    template_env
        .add_template("log.html", include_str!("templates/log.html"))?;
    let pool = PgPoolOptions::new()
        .max_connections(5)
        .connect(&std::env::var("DATABASE_URL").unwrap()).await?;
    let app_state = Arc::new(AppState { template_env, pool });
    let app = Router::new()
        .nest_service("/static", ServeDir::new("static"))
        .route("/", get(index_handler))
        .route("/log", get(show_log_handler).post(accept_log_handler))
        .with_state(app_state);
    let listener = tokio::net::TcpListener::bind("0.0.0.0:3000").await?;
    axum::serve(listener, app).await?;
    Ok(())
}
