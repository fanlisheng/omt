use flutter_rust_bridge::for_generated::futures::future::err;
use mac_address::get_mac_address;

static mut COUNT: u32 = 0;

#[flutter_rust_bridge::frb(sync)]
pub fn greet(name: String) -> String {
    format!("Hello, {name}!")
}

#[flutter_rust_bridge::frb(sync)]
pub fn greet2(name: String) -> String {
    format!("Hello2, {name}!")
}

#[flutter_rust_bridge::frb(sync)]
pub fn get_mac() -> Result<String, String> {
    match get_mac_address() {
        Ok(Some(mac)) => Ok(mac.to_string() + "2213"),
        Ok(None) => Err("No MAC address found".into()),
        Err(e) => Err(e.to_string()),
    }
}

#[flutter_rust_bridge::frb(sync)]
pub fn count_add_self() -> u32 {
    COUNT += 2;
    COUNT
}

#[flutter_rust_bridge::frb(init)]
pub fn init_app() {
    flutter_rust_bridge::setup_default_user_utils();
}
