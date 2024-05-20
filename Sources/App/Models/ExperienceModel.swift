//
//  File.swift
//  
//
//  Created by Developer IOS on 14/05/2024.
//

import Vapor
import Fluent

/// Property wrappers interact poorly with `Sendable` checking, causing a warning for the `@ID` property
/// It is recommended you write your model with sendability checking on and then suppress the warning
/// afterwards with `@unchecked Sendable`.
///
final class ExperienceModel: Content,Model , @unchecked Sendable {
  
    
    static let schema = "Experience"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "companyName")
    var companyName: String
    
    @Timestamp(key: "startWork", on: .create)
    var startWork: Date?
    
    // Stores an ISO 8601 formatted timestamp representing
    // when this model was last updated.
    @Timestamp(key: "endWork", on: .update, format: .iso8601)
    var endWork: Date?
    
    @Field(key: "positionWork")
    var positionWork: String
    
    @Field(key: "workTask")
    var workTask: String
    
    init() {
    }
    init(id: UUID? = nil, companyName: String, startWork: Date, endWork: Date, positionWork: String, workTask: String) {
        self.id = id
        self.companyName = companyName
        self.startWork = startWork
        self.endWork = endWork
        self.positionWork = positionWork
        self.workTask = workTask
    }
    
}
