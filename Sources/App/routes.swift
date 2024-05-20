import Vapor

func routes(_ app: Application) throws {
    
//    app.get { req async in
//        "It works!"
//    }

    app.get("hello") { req async -> String in
        "Hello, world!"
    }
 
//    // 1
//    app.post("info") { req -> String in
//      let data = try req.content.decode(PersonModel.self)
//      return "Hello \(data.name)!"
//    }
//    // 1
//    app.post("info","json") { req -> InfoResponse in
//      let data = try req.content.decode(PersonModel.self)
//      // 2
//      return InfoResponse(request: data)
//    }
    try app.register(collection: ExperienceController())
    
    try app.register(collection: PersonController())
    
    try app.register(collection: ProtofolioController())
    
    let websiteController = WebsiteController()
    try app.register(collection: websiteController)
}

struct InfoResponse:Content {
    
    let request: PersonModel
}
