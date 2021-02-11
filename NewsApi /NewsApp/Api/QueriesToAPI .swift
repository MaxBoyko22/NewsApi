//
//  QueriesToAPI .swift
//  NewsApp
//
//  Created by Maximilian Boiko on 09.02.2021.
//

import Foundation

class QueriesToAPI {
    static let shared = QueriesToAPI()
    
    private let session = URLSession.init(configuration: .default)
    
    private let jsonDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)
        return jsonDecoder
    }()
   
    func getArticles(endpoint: Endpoint,
                     params: [NewsApiParameter],
                     completion: (([Article]?, Error?) -> Void)?) {
        let params = params + [.apiKey]
        guard let absoluteUrl = endpoint.getAbsoluteURL(params: params.map {$0.asUrlQueryItem}) else { return }
        
        let urlRequest = URLRequest(url: absoluteUrl)
        
        session.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            if error != nil {
                completion?(nil, error)
            }
            
            if let jsonData = data, !jsonData.isEmpty {
                do {
                    let result = try self.jsonDecoder.decode(NewsResponse.self, from: jsonData)
                    
                    completion?(result.articles, nil)
                } catch {
                    completion?(nil, error)
                }
            }
        }).resume()
    }
    
    func getSources(params:[NewsApiParameter], completion:(([Source]?, Error?) -> Void)?){
        let params = params + [.apiKey]
        
        guard let absoluteUrl = Endpoint.sources.getAbsoluteURL(params: params.map {$0.asUrlQueryItem}) else { return }
        
        let urlRequest = URLRequest(url: absoluteUrl)
        
        session.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            if error != nil {
                completion?(nil, error)
            }
            
            if let jsonData = data, !jsonData.isEmpty {
                do {
                    let result = try self.jsonDecoder.decode(SourcesResponse.self, from: jsonData)
                    
                    completion?(result.sources, nil)
                } catch {
                    completion?(nil, error)
                }
            }
        }).resume()

                    
    
        
        
    }
    
}
