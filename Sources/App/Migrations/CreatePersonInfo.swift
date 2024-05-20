//
//  File.swift
//  
//
//  Created by Developer IOS on 14/05/2024.
//
import Vapor
import Fluent

struct CreatePersonInfo: AsyncMigration{
    
    func prepare(on database: any FluentKit.Database) async throws {
        
        try await database.schema("PersonalInfo")
        
            .id()
            .field("name",.string,.required)
            .field("birthdate",.date)
            .field("updated_at",.string)
            .field("gender",.string,.required)
            .field("nationality",.string)
            .field("Adress",.string)
            .field("marital_status",.string)
            .field("email",.string)
            .field("mobile",.int)
        
            .create()
    }
    
    func revert(on database: any FluentKit.Database) async throws {
        try await database.schema("PersonalInfo").delete()
    }
    
}

