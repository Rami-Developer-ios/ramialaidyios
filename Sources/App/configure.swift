
import NIOSSL
import Fluent
import FluentPostgresDriver
import Leaf
import Vapor

// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    app.middleware.use(app.sessions.middleware)
    
    let corsConfiguration = CORSMiddleware.Configuration(
        allowedOrigin: .all,
        allowedMethods: [.GET, .POST, .PUT, .OPTIONS, .DELETE, .PATCH],
        allowedHeaders: [.accept, .authorization, .contentType, .origin, .xRequestedWith, .userAgent, .accessControlAllowOrigin]
    )
    let cors = CORSMiddleware(configuration: corsConfiguration)
    // cors middleware should come before default error middleware using `at: .beginning`
    app.middleware.use(cors, at: .beginning)
//    
  
    
    if var config = Environment.get("DATABASE_URL").flatMap(URL.init).flatMap(PostgresConfiguration.init) { 
        config.tlsConfiguration = .forClient( certificateVerification:.none)
        app.databases.use(.postgres(configuration: config), as: .psql)
    } else {
        app.databases.use(DatabaseConfigurationFactory.postgres(configuration: .init(
            hostname: Environment.get("DATABASE_HOST") ?? "localhost",
            port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? SQLPostgresConfiguration.ianaPortNumber,
            username: Environment.get("DATABASE_USERNAME") ?? "postgres",
            password: Environment.get("DATABASE_PASSWORD") ?? "r315r199r",
            database: Environment.get("DATABASE_NAME") ?? "Protofolio",
            tls: .prefer(try .init(configuration: .clientDefault)))
        ), as: .psql)
    }
//    try app.databases.use(.postgres(url: ""), as: .psql)
//
    app.migrations.add(CreatePersonInfo())
    
//    app.migrations.add(CreatePerson())
    // 2
    app.migrations.add(CreateExperience())
    
    app.migrations.add(CreateProtofolio())
    
    app.logger.logLevel = .debug
  
    //3
    try await app.autoMigrate()
    
    app.views.use(.leaf)
    // register routes
    try routes(app)
}
