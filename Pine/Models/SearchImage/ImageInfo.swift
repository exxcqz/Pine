//
//  ImageInfo.swift
//  Pine
//
//  Created by Nikita Gavrikov on 27.02.2022.
//

import Foundation

struct ImageInfo: Codable {
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
    let tags: [Tag?]

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
        case tags
    }
}

// MARK: - URLs
struct Urls: Codable {
    let raw: String
    let full: String
    let regular: String
    let small: String
    let thumb: String
}

// MARK: - Links
struct Links: Codable {
    let selfLink: String?
    let html: String?
    let download: String?
    let downloadLocations: String?

    enum CodingKeys: String, CodingKey {
        case selfLink = "self"
        case html
        case download
        case downloadLocations = "download_Locations"
    }
}

// MARK: - TopicSubmissions
struct TopicSubmissions: Codable {
    let businessWork: BusinessWork?

    enum CodingKeys: String, CodingKey {
        case businessWork = "business-work"
    }
}

// MARK: - BusinessWork
struct BusinessWork: Codable {
    let status: String?
    let approvedOn: String?

    enum CodingKeys: String, CodingKey {
        case status
        case approvedOn = "approved_on"
    }
}

// MARK: - Tag
struct Tag: Codable {
    let type: String?
    let title: String?
}
