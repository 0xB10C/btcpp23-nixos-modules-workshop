use bitcoincore_rpc::{Auth, Client, RpcApi};
use clap::{Parser, Subcommand};
use oxhttp::model::{Response, Status};
use oxhttp::Server;

#[derive(Parser)]
#[clap(author, version, about, long_about = None)]
struct Cli {
    #[clap(subcommand)]
    command: Commands,

    /// The host of the Bitcoin Core RPC server.
    #[clap(long, value_parser)]
    rpc_host: String,

    /// The port of the Bitcoin Core RPC server.
    #[clap(long, value_parser)]
    rpc_port: u16,

    /// A user for authentication with the Bitcoin Core RPC server.
    #[clap(long, value_parser)]
    rpc_user: String,

    /// A password for authentication with the Bitcoin Core RPC server.
    #[clap(long, value_parser)]
    rpc_password: String,
}

#[derive(Subcommand)]
enum Commands {
    /// Run the app with a webserver
    Server {
        /// Webserver port
        port: u16,
    },
    // Run the backup functionallity
    // Backup,
}

fn main() {
    let cli = Cli::parse();

    let rpc_url = format!("http://{}:{}", cli.rpc_host, cli.rpc_port);
    let rpc_auth = Auth::UserPass(cli.rpc_user.clone(), cli.rpc_password);
    let rpc = Client::new(&rpc_url, rpc_auth).unwrap();

    println!(
        "Created a RPC client connectiont to {} using user '{}'.",
        rpc_url, cli.rpc_user
    );

    let chain_info = rpc.get_blockchain_info().unwrap();
    println!("chain info: {:#?}", chain_info);

    match &cli.command {
        Commands::Server { port } => server(*port),
        //Commands::Backup => backup(),
    }
}

fn server(port: u16) {
    let server = Server::new(|_request| Response::builder(Status::OK).with_body("Hello, world!"));
    println!("Starting webserver listening on http://0.0.0.0:{}", port);
    server.listen(("0.0.0.0", port)).unwrap();
}

/*
fn backup() {
    println!("backup..");
}
*/
