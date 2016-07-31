//
//  ReposDataStore.swift
//  github-repo-starring-swift
//
//  Created by Haaris Muneer on 6/28/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class ReposDataStore {
    
    static let sharedInstance = ReposDataStore()
    private init() {}
    
    var repositories:[GithubRepository] = []
    
    func getRepositoriesWithCompletion(completion: () -> ()) {
        GithubAPIClient.getRepositoriesWithCompletion { (reposArray) in
            self.repositories.removeAll()
            for dictionary in reposArray {
                guard let repoDictionary = dictionary as? NSDictionary else { fatalError("Object in reposArray is of non-dictionary type") }
                let repository = GithubRepository(dictionary: repoDictionary)
                self.repositories.append(repository)
                
            }
            completion()
        }
    }
    
    func toggleStarStatusForRepository(repo : GithubRepository, completion : (Bool) -> ()) {
        GithubAPIClient.checkIfRepositoryIsStarred(repo.fullName) { (starred) in
            if starred {
                GithubAPIClient.unstarRepository(repo.fullName, completion: { 
                    completion(false)
                })
            }
            else { // wasn't starred
                GithubAPIClient.starRepository(repo.fullName, completion: { 
                    completion(true)
                })
            }
        }
    }

}
