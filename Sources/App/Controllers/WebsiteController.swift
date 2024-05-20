//
//  File.swift
//  
//
//  Created by Developer IOS on 15/05/2024.
//

import Vapor
import Leaf


struct WebsiteController: RouteCollection {
    
    let imageFolder = "img/portfolio"
    func boot(routes: RoutesBuilder) throws {
        
        routes.get(use: { try await indexHandler(req: $0)})
        routes.get("portfolioFFF",use: { try await IndexProfolio(req: $0)})
        routes.get("home",use: { try await IndexHomePage(req: $0)})
        routes.get("resume",use: { try await IndexResume(req: $0)})
        routes.get("portfolio", use: { try await IndexPortfolio(req: $0)})
        routes.get(
            "category",
            "client",
            "num",
            "info",
            "url",
            ":id",
            "addProfilePicture",
            use: {try await addProfilePictureHandler($0)})
        
        
        routes.on(.POST,
                  "category",
                  "client",
                  "num",
                  "info",
                  "url",
                  ":id",
                  "addProfilePicture",
                  body: .collect(maxSize: "10mb"),
                  use:  {try await addProfilePicturePostHandler($0)})
        
        routes.get(
          "portfolio",
          ":id",
          "profilePicture",
          use: {try await getUsersProfilePictureHandler($0)})
    }
    
    func indexHandler(req: Request) async throws -> View {
        let PersonalData = try await PersonModel.query(on: req.db).all()
        
        let protofolio = try await ProtofolioModel.query(on: req.db).all()
        
        let context = IndexContext(title:"Rami Alaidy",personalData: PersonalData, protofolio: protofolio)
        return try await req.view.render("index",  context)
        
    }
    
    func IndexHomePage(req:Request) async throws -> View{
        let PersonalData = try await PersonModel.query(on: req.db).all()
        
        let protofolio = try await ProtofolioModel.query(on: req.db).all()
        
        let context = IndexContext(title:"Rami Alaidy",personalData: PersonalData, protofolio: protofolio)
        
        return try await req.view.render("homePage",context)
        
    }
    func IndexResume(req:Request) async throws -> View{
        
        let PersonalData = try await PersonModel.query(on: req.db).all()
        
        let protofolio = try await ProtofolioModel.query(on: req.db).all()
        
        let context = IndexContext(title:"Rami Alaidy",personalData: PersonalData, protofolio: protofolio)
        
        return try await req.view.render("resume",context)
    }
    func IndexPortfolio(req:Request) async throws -> View{
        let PersonalData = try await PersonModel.query(on: req.db).all()
        let protofolio = try await ProtofolioModel.query(on: req.db).all()
        
        let context = IndexContext(title:"Rami Alaidy",personalData: PersonalData, protofolio: protofolio)
        return try await req.view.render("home",context)
    }
    func IndexProfolio(req:Request) async throws -> View{
        
//      guard  let PersonalData = try await PersonModel.find(req.parameters.get("id"), on: req.db) else{
//            throw Abort(.notFound)
//        }
//        
//        guard let protofolio = try await ProtofolioModel.find(req.parameters.get("id"), on: req.db) else{
//            throw Abort(.notFound)
        
        let PersonalData = try await PersonModel.query(on: req.db).all()
        let protofolio = try await ProtofolioModel.query(on: req.db).all()
    
        let context = IndexContext(title:"Rami Alaidy",personalData: PersonalData, protofolio: protofolio)
        
        return try await req.view.render("portfolio-details",context)
    }
    
    func addProfilePictureHandler(_ req: Request) async throws -> View {
        
        guard let user = try await ProtofolioModel.find(req.parameters.get("id"), on: req.db) else{
            throw Abort(.notFound)
        }
        //        try await user.save(on: req.db)
        
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
        guard let user = try await ProtofolioModel.find(req.parameters.get("id"), on: req.db)
        else { throw Abort(.notFound)}
        
        let userID: UUID
        do {
            userID = try user.requireID()
        } catch {
            throw Abort(.noContent)
        }
        // 4
        let name = "portfolio-\(user.num ?? 0).jpg"
        // 5
        let path =
        req.application.directory.publicDirectory + imageFolder + name
        // 6
        try await req.fileio
            .writeFile(.init(data: data.picture), at: path)
        // 7
        user.img1 = name
         
        
        try await req.db.transaction { transaction in
            
            try await   user.save(on: transaction)
        }
        let redirect = req.redirect(to: "/protofolio/\(userID)")
        
        return redirect
    }
    func getUsersProfilePictureHandler(_ req: Request) async throws -> Response {
        // 1
        guard let user =  try await ProtofolioModel.find(req.parameters.get("id"), on: req.db) else{
            throw Abort(.notFound)
        }
      let filename = user.client
          
        // 3
        let path = req.application.directory
            .workingDirectory + imageFolder + filename
        // 4
        return req.fileio.streamFile(at: path)
    }
}

struct IndexContext: Encodable {
  let title: String
  let personalData: [PersonModel]?
  let protofolio: [ProtofolioModel]?
//  let authenticatedUser: ProtofolioModel?
}
struct ImageUploadData: Content {
  var picture: Data
}

struct Indexprotfolio:Content{
    let title: String
    let personInformation:PersonModel?

  let protofolio: ProtofolioModel?
}
