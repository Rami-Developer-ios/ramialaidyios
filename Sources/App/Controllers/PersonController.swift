//
//  PersonController.swift
//  
//
//  Created by Developer IOS on 14/05/2024.
//

import Vapor

struct PersonController:RouteCollection {
    
    func boot(routes: any Vapor.RoutesBuilder) throws {
        
        let route = routes.grouped("person")
        
        route.group("info") {  req in
            
            req.get(use: {try await index(req: $0)})
            req.post(use:{try await create(req: $0)})
            req.put(":id",use: {try await update(req: $0)})
        }
    }
    
    func index(req:Request) async throws -> [PersonModel] {
        try await PersonModel.query(on: req.db).all()
    }
    
    func create(req:Request) async throws -> PersonModel{
        
        let data = try req.content.decode(PersonModel.self)
        try await data.save(on: req.db)
        return data
    }
    func update(req:Request) async throws -> PersonModel{
        
        guard let infoByID = try await PersonModel.find(req.parameters.get("id"), on: req.db) else{
            throw Abort(.notFound)
        }
        
        let updatedTodo = try req.content.decode(PersonModel.self)
        infoByID.name = updatedTodo.name
        infoByID.birthdate = updatedTodo.birthdate
        infoByID.updatedAt = updatedTodo.updatedAt
        infoByID.gender = updatedTodo.gender
        infoByID.Adress = updatedTodo.Adress
        infoByID.marital_status = updatedTodo.marital_status
        infoByID.nationality = updatedTodo.nationality
        infoByID.email = updatedTodo.email
        infoByID.mobile = updatedTodo.mobile
       
        try await infoByID.save(on: req.db)
        
        return infoByID
    }
    
}
