#![cfg_attr(not(feature = "std"), no_std)]
use ink_lang as ink;
#[ink::contract]
mod hello_world {
    #[ink(storage)]
    pub struct HelloWorld {}
    impl HelloWorld {
        #[ink(constructor)]
        pub fn new() -> Self {
            Self {}
        }
        #[ink(message)]
        pub fn sayhello(&self) {
            ink_env::debug_println!("\n\nSaying Hi from 'sayhello'\n\n");
            ink_env::debug_message("\n\nSaying Hi from sayhello()\n\n");
        }
        #[ink(message)]
        pub fn saybye(&self) {
            ink_env::debug_println!("\n\nSaying Hi from 'sayhello'\n\n");
            ink_env::debug_message("\n\nSaying Hi from sayhello()\n\n");
            panic!("\n\nPanicking at saybye()\n\n")
        }
    }
}
