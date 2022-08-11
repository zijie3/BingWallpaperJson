import Foundation

let sourceURI = "https://www.bing.com" + "/HPImageArchive.aspx"

struct BingWallpaperDownloader {
    
    private init(){ }
    
    static let shared = BingWallpaperDownloader()
    
    func getBingWallpaperRequest(index: Int, count: Int, market: Market) -> URLRequest {
        let sourceURI = sourceURI
        let index = min(max(0, index), 8)
        let count = min(max(0, count), 8)
        let urlString = sourceURI.appending("?format=js&idx=\(index)&n=\(count)&mkt=\(market.toString)")
        let url = URL(string: urlString)!
        let request = URLRequest(url: url)
        return request
    }
    
    func getBingWallpaperResponse(with request: URLRequest) async throws -> String {
        let (data, _) = try await URLSession.shared.data(for: request)
        let jsonString = String(data: data, encoding: .utf8) ?? ""
        return jsonString
    }
    
    func fetchAllCountriesJson() async {
        
        for market in Market.allCases {
            
            let request = getBingWallpaperRequest(index: 0, count: 1, market: market)
            do {
                let jsonString = try await getBingWallpaperResponse(with: request)
                try append(for: jsonString, with: "\(market).json")
            } catch {
                print(error.localizedDescription)
                return
            }
        }
        
    }
    
    func append(for jsonString: String, with fileName: String) throws {
        let str = jsonString + ",\n]"
        let pathString = FileManager.default.currentDirectoryPath
        let url = URL(string: pathString)!.appendingPathComponent("json/\(fileName)")
        let fileUrl = URL(string: "file://\(url)")!
        try str.appendLineToURL(fileURL: fileUrl)
    }
}

extension String {
    func appendLineToURL(fileURL: URL) throws {
         try (self + "\n").appendToURL(fileURL: fileURL)
     }

     func appendToURL(fileURL: URL) throws {
         let data = self.data(using: String.Encoding.utf8)!
         try data.append(fileURL: fileURL)
     }
 }

 extension Data {
     func append(fileURL: URL) throws {
         if let fileHandle = FileHandle(forWritingAtPath: fileURL.path) {
             defer {
                 fileHandle.closeFile()
             }
             fileHandle.seekToEndOfFile()
             var offset = try fileHandle.offset()
             offset = offset - 2
             try fileHandle.seek(toOffset: offset)
             fileHandle.write(self)
         }
         else {
             try write(to: fileURL, options: .atomic)
         }
     }
 }
