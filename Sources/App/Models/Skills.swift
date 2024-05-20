//
//  File.swift
//  
//
//  Created by Developer IOS on 19/05/2024.
//

import Vapor
import Fluent

final class Skills: Content,Model , @unchecked Sendable{
  
    static let schema =  "skills"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "name")
    var name:String
    
    @Field(key: "persentage")
    var persentage:Int
    
    @Field(key: "yearsExperianxe")
    var yearsExperianxe: Int
    
    @Field(key: "ProjectNum")
    var ProjectNum: Int
    
    init() {
        
    }
    init(id: UUID? = nil, name: String, persentage: Int, yearsExperianxe: Int, ProjectNum: Int) {
        self.id = id
        self.name = name
        self.persentage = persentage
        self.yearsExperianxe = yearsExperianxe
        self.ProjectNum = ProjectNum
    }
    
}
