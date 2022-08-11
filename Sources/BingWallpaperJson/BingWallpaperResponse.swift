import Foundation

struct WallpaperResponse: Codable {
    let images: [WallpaperImageResponse]
}

struct WallpaperImageResponse: Codable {

    let startdate, urlbase: String
    let fullstartdate, enddate, url: String
    let copyright: String
    let copyrightlink: String
    let title, quiz: String
    let wp: Bool
    let hsh: String
    let drk, top, bot: Int
    
}



