import Foundation

@main
public struct BingWallpaperJson {
    
    
    public static func main() {
        let downloader = BingWallpaperDownloader.shared
        downloader.fetchAllCountriesJson()
        
    }
}
