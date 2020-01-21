//
//  RepositoryManager.swift
//  POFAssignment
//
//  Created by Parisa on 2020-01-12.
//  Copyright © 2020 Parisa. All rights reserved.
//

import Foundation

protocol RepositoryManager {
    func getRepository<T: Codable>(type: T.Type, repoURL: String, completion: @escaping ([T]) -> Void)
}

class RepositoryManagerImp: RepositoryManager {
    let queueLabel = "githubinfo.data-queue"

    func getRepository<T: Codable>(type: T.Type, repoURL: String, completion: @escaping ([T]) -> Void) {
        DispatchQueue(label: self.queueLabel, qos: .background).async {
            guard let url = URL(string: repoURL) else { return }
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                if(error != nil){
                    print("\(error!.localizedDescription)")
                } else {
                    guard let data = data else { return }
                    do{
                        let object = try JSONDecoder().decode([T].self, from: data)
                        completion(object)
                    } catch let error as NSError{
                        print(error)
                    }
                }
            }).resume()
        }
    }
    

}
