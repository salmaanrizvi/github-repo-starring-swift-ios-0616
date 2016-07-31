//
//  GithubAPIClient.swift
//  github-repo-starring-swift
//
//  Created by Haaris Muneer on 6/28/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class GithubAPIClient {
    
    class func getRepositoriesWithCompletion(completion: (NSArray) -> ()) {
        let urlString = "\(githubAPIURL)/repositories?client_id=\(githubClientID)&client_secret=\(githubClientSecret)"
        let url = NSURL(string: urlString)
        let session = NSURLSession.sharedSession()
        
        guard let unwrappedURL = url else { fatalError("Invalid URL") }
        let task = session.dataTaskWithURL(unwrappedURL) { (data, response, error) in
            guard let data = data else { fatalError("Unable to get data \(error?.localizedDescription)") }
            
            if let responseArray = try? NSJSONSerialization.JSONObjectWithData(data, options: []) as? NSArray {
                if let responseArray = responseArray {
                    completion(responseArray)
                }
            }
        }
        task.resume()
    }
    
    class func checkIfRepositoryIsStarred(fullName : String, completion : (Bool) -> ()) {
        
        let urlString = "\(githubAPIURL)/user/starred/\(fullName)?access_token=\(githubAccessToken)"
        
        let url = NSURL(string: urlString)
        
        let session = NSURLSession.sharedSession()
        
        guard let unwrappedURL = url else { fatalError("Invalid URL") }
        
        let task = session.dataTaskWithURL(unwrappedURL) { (data, response, error) in
            guard let taskResponse = response as? NSHTTPURLResponse else { fatalError("Couldn't get response \(error)") }
                
            if taskResponse.statusCode == 404 { completion(false) }
            else { completion(true) }
        }
        
        task.resume()
        
    }
    
    class func starRepository(fullName : String, completion : () -> ()) {
        
        let urlString = "\(githubAPIURL)/user/starred/\(fullName)?access_token=\(githubAccessToken)"
        
        let url = NSURL(string: urlString)
        
        let session = NSURLSession.sharedSession()
        
        guard let unwrappedURL = url else { fatalError("Invalid URL") }
        
        let urlRequest = NSMutableURLRequest(URL: unwrappedURL)
        
        urlRequest.HTTPMethod = "PUT"
        
        let task = session.dataTaskWithRequest(urlRequest) { (data, response, error) in
            guard let response = response as? NSHTTPURLResponse else { fatalError("Couldn't get response. \(error)") }
            
            print("Starred repo with response: \(response.statusCode)")
            completion()
        }
        
        task.resume()
        
    }
    
    class func unstarRepository(fullName : String, completion : () -> () ) {
        let urlString = "\(githubAPIURL)/user/starred/\(fullName)?access_token=\(githubAccessToken)"
        
        let url = NSURL(string: urlString)
        
        let sesh = NSURLSession.sharedSession()
        
        guard let unwrappedURL = url else { fatalError("Invalid URL") }
        
        let urlRequest = NSMutableURLRequest(URL: unwrappedURL)
        urlRequest.HTTPMethod = "DELETE"
        
        let task = sesh.dataTaskWithRequest(urlRequest) { (data, response, error) in
            guard let response = response as? NSHTTPURLResponse else { fatalError("Couldn't get response") }
            
            print("Unstarred repo with response: \(response.statusCode)")
            completion()
        }
        
        task.resume()
    }
    
}

