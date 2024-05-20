//
//  File.swift
//  
//
//  Created by Developer IOS on 14/05/2024.
//

import Vapor
import Fluent
import FluentPostgresDriver

struct CreatePerson: AsyncMigration{
    
    func prepare(on database: any FluentKit.Database) async throws {
        try await database.schema("info")
            .id()
            .field("name",.string,.required)
            .field("gender",.string,.required)
            .create()
    }
    
    func revert(on database: any FluentKit.Database) async throws {
        try await database.schema("info").delete()
    }
    
}
