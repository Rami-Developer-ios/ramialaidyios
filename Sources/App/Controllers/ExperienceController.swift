//
//  File.swift
//  
//
//  Created by Developer IOS on 14/05/2024.
//

import Vapor

struct ExperienceController:RouteCollection{
    
    func boot(routes: any Vapor.RoutesBuilder) throws {
        
        let route = routes.grouped("experience")
        
        route.group("info") {  req in
            
            req.get(use: {try await index(req: $0)})
            req.post(use:{try await create(req: $0)})
            req.put(":id",use: {try await update(req: $0)})
        }
    }
    
    func index(req:Request) async throws -> [ExperienceModel] {
        try await ExperienceModel.query(on: req.db).all()
    }
    
    func create(req:Request) async throws -> ExperienceModel{
        
        let data = try req.content.decode(ExperienceModel.self)
        try await data.save(on: req.db)
        
        return data
    }
    
    func update(req:Request) async throws -> ExperienceModel{
        
        guard let infoByID = try await ExperienceModel.find(req.parameters.get("id"), on: req.db) else{
            throw Abort(.notFound)
        }
        
        let updatedTodo = try req.content.decode(ExperienceModel.self)
        
        infoByID.companyName = updatedTodo.companyName
        infoByID.startWork = updatedTodo.startWork
        infoByID.endWork = updatedTodo.endWork
        infoByID.positionWork = updatedTodo.positionWork
        infoByID.workTask = updatedTodo.workTask
       
       
        try await infoByID.save(on: req.db)
        
        return infoByID
    }
    
}
