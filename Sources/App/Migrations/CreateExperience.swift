//
//  File.swift
//  
//
//  Created by Developer IOS on 14/05/2024.
//

import Vapor
import Fluent

struct CreateExperience: AsyncMigration{
   
    func prepare(on database: any FluentKit.Database) async throws {
        
        try await database.schema("Experience")
        
            .id()
            .field("companyName",.string,.required)
            .field("startWork",.date)
            .field("endWork",.string)
            .field("positionWork",.string,.required)
            .field("workTask",.string,.required)
        
            .create()
    }
    
    func revert(on database: any FluentKit.Database) async throws {
        
        try await database.schema("Experience").delete()
    }
    
}
