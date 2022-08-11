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
    
    func getBingWallpaperResponse(with request: URLRequest, handler: (String) -> Void) {
        let task = URLSession.shared.dataTask(with: request) { data, _, _ in
            let jsonString = String(data: data!, encoding: .utf8) ?? ""
            handler(jsonString)
        }
        task.resume()
        
    }
    
    func fetchAllCountriesJson() {
        let group = DispatchGroup()
        
        for market in Market.allCases {
            group.enter()
            let request = getBingWallpaperRequest(index: 0, count: 1, market: market)
            
            getBingWallpaperResponse(with: request) { jsonString in
                do {
                    try append(for: jsonString, with: "\(market).json")
                    group.leave()
                } catch {
                    print(error.localizedDescription)
                    group.leave()
                }
            }
            
        }
        
        group.wait()
    }
    
    func append(for jsonString: String, with fileName: String) throws {
        let str = jsonString + ",\n]"
        let pathString = FileManager.default.currentDirectoryPath
        let url = URL(string: pathString)!.appendingPathComponent("json/\(fileName)")
        let fileUrl = URL(string: "file://\(url)")!
        try str.appendLineToURL(fileURL: fileUrl)
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
