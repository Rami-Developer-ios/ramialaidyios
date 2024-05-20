//
//  File.swift
//  
//
//  Created by Developer IOS on 16/05/2024.
//

import Vapor
import Fluent

struct ProtofolioController: RouteCollection{
    
    let imageFolder = "ProfilePictures/"
    
    func boot(routes: any Vapor.RoutesBuilder) throws {
        
        let route = routes.grouped("protofolio")
        
        route.get(use: {try await index(req:$0)})
        
        route.post(use: {try await create(req: $0)})
        
        route.put("update", use: {try await update(req: $0)})
        
        /// Route Add Profile Picture
        route.get("addProfilePicture",use: {try await addProfilePictureHandler($0)})
        
        route.on(.POST,":id","addProfilePicture",body:.collect(maxSize: "10mb"),use: {try await addProfilePicturePostHandler($0)})
    }
    
    func index(req:Request) async throws -> [ProtofolioModel]{
        try await req.db.query(ProtofolioModel.self).all()
    }
    
    func create(req:Request) async throws -> ProtofolioModel{
        
        let data = try req.content.decode(ProtofolioModel.self)

        try await data.save(on: req.db)
        return data
    }
    func update(req:Request) async throws -> ProtofolioModel{
        
        guard let ProtofolioID = try await ProtofolioModel.find(req.parameters.get("id"), on: req.db) else{
            throw Abort(.notFound)
        }
        let updateData = try req.content.decode(ProtofolioModel.self)
        
        ProtofolioID.category = updateData.category
        ProtofolioID.client = updateData.client
//        ProtofolioID.createDate = updateData.createDate
//        ProtofolioID.lastDate = updateData.lastDate
        ProtofolioID.url = updateData.url
        ProtofolioID.info = updateData.info
        ProtofolioID.num = updateData.num
        ProtofolioID.img1 = updateData.img1
        ProtofolioID.img2 = updateData.img2
        ProtofolioID.img3 = updateData.img3
        
        try await ProtofolioID.save(on: req.db)
        
        return ProtofolioID
    }
    
    // Add Profile Picture
    func addProfilePictureHandler(_ req: Request) async throws -> View {
        
        guard let user = try await ProtofolioModel.find(req.parameters.get("id"), on: req.db) else{
            throw Abort(.notFound)
        }
        try await user.save(on: req.db)
        
        return try await req.view.render(
            "addProfilePicture",
            [
                "title": "Add Profile Picture",
                "username": user.client
            ]
        )
    }

    func addProfilePicturePostHandler(_ req: Request) async throws -> Response {
        // 1
        let data = try req.content.decode(ImageUploadData.self)
        // 2
        guard let user =  try await ProtofolioModel.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        // 3
        let userID: UUID
        do {
            userID = try user.requireID()
        } catch {
            throw Abort(.notFound)
        }
        // 4
        let name = "portfolio-\(user.num ?? 0).jpg"
        // 5
        let path =
        req.application.directory.workingDirectory + imageFolder + name
        // 6
        try await req.fileio
            .writeFile(.init(data: data.picture), at: path)
        
        // 7
        user.img1 = name
        // 8
        let redirect = req.redirect(to: "/create/\(userID)")
        try await user.save(on: req.db)
        return redirect
    }

    func getUsersProfilePictureHandler(_ req: Request) async throws -> Response {
        // 1
        guard let user =  try await ProtofolioModel.find(req.parameters.get("id"), on: req.db) else{
            throw Abort(.notFound)
        }
        guard let filename = user.img1 else {
            throw Abort(.notFound)
        }
        // 3
        let path = req.application.directory
            .workingDirectory + imageFolder + filename
        // 4
        return req.fileio.streamFile(at: path)
    }


}

