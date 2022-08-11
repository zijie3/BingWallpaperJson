import Foundation

@main
public struct BingWallpaperJson {
    
    
    public static func main() async {
        let downloader = BingWallpaperDownloader.shared
        await downloader.fetchAllCountriesJson()
        
    }
}
