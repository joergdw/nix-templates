use std::default::Default;
use std::env::{self, Vars};
use std::include_str;
use std::str::FromStr;

struct Config {
    to_listener: String
}

impl Config {
    fn new() -> Self {
        Default::default()
    }

    /// Creates a configuration for this application using the environment-
    /// variables.
    //
    // There are some environment-variables each cf-application should
    // take account of. Most notably "${PORT}", see:
    // <https://docs.cloudfoundry.org/devguide/deploy-apps/environment-variable.html#PORT>
    fn from_env(mut env_vars: Vars) -> Self {
        let mut c = Self::new();

        if let Some((_, port)) =
            env_vars.find(|(key, _): &(String, String)| key == "PORT") {
                c.to_listener = format!("0.0.0.0:{port}");
        }

        c
    }
}

impl Default for Config {
    fn default() -> Self {
        Config { to_listener: String::from("localhost:8080") }
    }
}

#[async_std::main]
async fn main() -> tide::Result<()> {
    let config = Config::from_env(env::vars());

    let mut app = tide::new();
    let mut std_entry_route = app.at("/");
    std_entry_route.get(|_: tide::Request<()>| {
        std_response()
    });
    app.listen(config.to_listener).await?;

    Ok(())
}

async fn std_response() -> Result<tide::Response, tide::Error> {
    let mut response = tide::Response::new(200);
    let mime = tide::http::Mime::from_str("text/html; charset=utf-8").unwrap();
    response.set_content_type(mime);
    response.set_body(include_str!("../resources/greeting-page.html"));

    Ok(response)
}