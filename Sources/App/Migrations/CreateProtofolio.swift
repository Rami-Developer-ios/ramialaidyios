//
//  File.swift
//  
//
//  Created by Developer IOS on 16/05/2024.
//

import Vapor
import Fluent

struct CreateProtofolio: AsyncMigration{
    
    func prepare(on database: any FluentKit.Database) async throws {
        
        try await database.schema("protofolio")
        
            .id()
            .field("category",.string,.required)
            .field("client",.string,.required)
            .field("num",.int)
            .field("url",.string)
            .field("info",.string,.required)
            .field("img1",.string)
            .field("img2",.string)
            .field("img3",.string)
            .create()
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema("protofolio").delete()
    }
    
}
