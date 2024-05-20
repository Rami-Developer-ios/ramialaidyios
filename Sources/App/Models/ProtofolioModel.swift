//
//  File.swift
//  
//
//  Created by Developer IOS on 16/05/2024.
//

import Vapor
import Fluent

final class ProtofolioModel:Model, @unchecked Sendable{
    
     static let schema = "protofolio"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "category")
    var category: String
    
    @Field(key: "client")
    var client:String
    
    @Field(key: "num")
    var num : Int?
    
//    @Timestamp(key: "createDate", on: .create)
//    var createDate: Date?
//    
//    // Stores an ISO 8601 formatted timestamp representing
//    // when this model was last updated.
//    @Timestamp(key: "lastDate", on: .update, format: .iso8601)
//    var lastDate: Date?
    
    @Field(key: "url")
    var url: String
    
    @Field(key: "info")
    var info: String
    
    @Field(key: "img1")
    var img1: String?
    
    @Field(key: "img2")
    var img2: String?
    
    @Field(key: "img3")
    var img3: String?
    
    init() {
    }
    
    init(id: UUID? = nil, category: String, client: String ,num:Int?, url: String, info: String, img1: String? = nil,img2:String? = nil,img3:String? = nil) {
        
        self.id = id
        self.category = category
        self.client = client
        self.num = num
        self.url = url
        self.info = info
        self.img1 = img1
        self.img2 = img2
        self.img3 = img3
    }
    
}
extension ProtofolioModel:Content{}
