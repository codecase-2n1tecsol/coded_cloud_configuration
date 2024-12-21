//Parse data from any files that were created due to returned data that is needed
// 1) enterprise application (client id)

use serde_json::Value;
use std::fs;
use std::io::{self, Write};
use dotenvy::dotenv;
use std::env;

fn main() {
    // Load the existing .env file or create a new one if it doesn't exist
    dotenv().ok();

// 1) start
    // Path to the JSON file
    let auth_file_path = "dataReturn/sensitiveFiles/myappauth.json";

    // Read and parse the JSON file
    let file_content = fs::read_to_string(auth_file_path)
        .expect("Failed to read the auth JSON file.");
    let auth_data: Value = serde_json::from_str(&file_content)
        .expect("Failed to parse JSON.");

    // Extract the clientAppId
    let app_id = auth_data["clientAppId"]
        .as_str()
        .expect("clientAppId not found in the JSON file.");

    // Write to the .env file
    let env_file_path = ".env";
    let mut env_file = fs::OpenOptions::new()
        .create(true)
        .write(true)
        .append(true)
        .open(env_file_path)
        .expect("Failed to open or create the .env file.");

    writeln!(env_file, "AZURE_APP_ID={}", app_id).expect("Failed to write to .env file");

    println!("Azure App ID successfully added to the .env file.");
// 1) end
}
