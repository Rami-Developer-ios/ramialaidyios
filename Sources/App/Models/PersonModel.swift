//
//  File.swift
//  
//
//  Created by Developer IOS on 14/05/2024.
//

import Vapor
import Fluent
import struct Foundation.UUID

/// Property wrappers interact poorly with `Sendable` checking, causing a warning for the `@ID` property
/// It is recommended you write your model with sendability checking on and then suppress the warning
/// afterwards with `@unchecked Sendable`.
///
final class PersonModel:Model,@unchecked Sendable{
    
    static let schema = "PersonalInfo"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "name")
    var name: String?
    
    @Timestamp(key: "birthdate", on: .create)
    var birthdate: Date?
    
    // Stores an ISO 8601 formatted timestamp representing
    // when this model was last updated.
    @Timestamp(key: "updated_at", on: .update, format: .iso8601)
    var updatedAt: Date?
    
    @Field(key: "gender")
    var gender: String?
    
    @Field(key: "nationality")
    var nationality: String
    
    @Field(key: "Adress")
    var Adress: String?
    
    @Field(key: "marital_status")
    var marital_status: String?
    
    @Field(key: "email")
    var email:String
    
    @Field(key: "mobile")
    var mobile: Int?
    
    init() {
        
    }
    init(id: UUID? = nil, name: String? = nil, birthdate: Date? = nil, updatedAt: Date? = nil, gender: String? = nil, nationality: String, Adress: String? = nil, marital_status: String? = nil, email: String, mobile: Int? = nil) {
        self.id = id
        self.name = name
        self.birthdate = birthdate
        self.updatedAt = updatedAt
        self.gender = gender
        self.nationality = nationality
        self.Adress = Adress
        self.marital_status = marital_status
        self.email = email
        self.mobile = mobile
    }
    
}
extension PersonModel:Content{}
