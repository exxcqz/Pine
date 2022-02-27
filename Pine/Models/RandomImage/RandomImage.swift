//
//  RandomImage.swift
//  Pine
//
//  Created by Nikita Gavrikov on 27.02.2022.
//

import Foundation

struct RandomImage: Codable {
    let id: String
    let createdAt: String?
    let updatedAt: String?
    let promotedAt: String?
    let width: Int
    let height: Int
    let color: String?
    let blurHash: String?
    let description: String?
    let altDescription: String?
    let urls: Urls
    let links: Links?
    let categories: [String?]
    let likes: Int?
    let likedByUser: Bool?
    let currentUserCollections: [String?]
    let sponsorship: String?
    let topicSubmissions: TopicSubmissions?
    let user: UserModel?

    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case promotedAt = "promoted_at"
        case width
        case height
        case color
        case blurHash = "blur_hash"
        case description
        case altDescription = "alt_description"
        case urls
        case links
        case categories
        case likes
        case likedByUser = "liked_by_user"
        case currentUserCollections = "current_user_collections"
        case sponsorship
        case topicSubmissions = "topic_submissions"
        case user
    }
}
