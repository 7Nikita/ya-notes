//
//  GithubService.swift
//  ya-notes
//
//  Created by Nikita Pekurin on 3/8/20.
//  Copyright © 2020 Nikita Pekurin. All rights reserved.
//

import Foundation
import CocoaLumberjack

class GithubService {
    
    private let fileServerName = "ios-course-notes-db"
    
    var gistRawUrl: String?
    
    func saveGithubToken(value: String) {
        UserDefaults.standard.set(value, forKey: "githubToken")
        DDLogInfo("Github token saved.")
    }
    
    func getGithubToken() -> String? {
        return UserDefaults.standard.string(forKey: "githubToken")
    }
    
    func getGistDbId(completion: @escaping () -> Void) {
        guard let githubToken = getGithubToken() else { return }
        let stringUrl = "https://api.github.com/gists"
        guard let url = URL(string: stringUrl) else { return }
        var request = URLRequest(url: url)
        request.setValue("token \(githubToken)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                DDLogError(error.localizedDescription)
                return
            }
            let statusCode = (response as! HTTPURLResponse).statusCode
            guard 200..<300 ~= statusCode else {
                DDLogError("Incorrect status code: \(statusCode).")
                return
            }
            guard let data = data else {
                DDLogInfo("Data is empty.")
                return
            }
            do {
                let gists = try JSONDecoder().decode([Gist].self, from: data)
                let gist = gists.filter { ($0.files.first?.value.filename.elementsEqual(self.fileServerName))! }
                if gist.isEmpty {
                    UserDefaults.standard.set(nil, forKey: "gistId")
                } else {
                    self.gistRawUrl = gist.first?.files.first?.value.rawUrl
                    let newGistId = (gist.first?.id)!
                    UserDefaults.standard.set(newGistId, forKey: "gistId")
                    completion()
                }
            } catch(let error) {
                DDLogError(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    func getGistContent(completion: @escaping ([Note]?) -> Void) {
        guard let stringUrl = gistRawUrl else {
            completion(nil)
            return
        }
        guard let url = URL(string: stringUrl) else {
            completion(nil)
            return
        }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                DDLogError(error.localizedDescription)
                completion(nil)
                return
            }
            let statusCode = (response as! HTTPURLResponse).statusCode
            guard 200..<300 ~= statusCode else {
                DDLogError("Incorrect status code: \(statusCode).")
                completion(nil)
                return
            }
            guard let data = data else {
                DDLogInfo("Data is empty.")
                completion(nil)
                return
            }
            let jsonArray = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]
            let notes = jsonArray!.map { Note.parse(json: $0)!}
            completion(notes)
        }
        task.resume()
    }
    
    func uploadGists(notes: [Note]?) {
        let jsonNotes = notes?.map { $0.json } ?? [[String: Any]()]
        var data: Data
        do {
            data = try JSONSerialization.data(withJSONObject: jsonNotes, options: [])
        } catch(let error) {
            DDLogError(error.localizedDescription)
            return
        }
        let newGist: [String : Any] = [
            "public" : false,
            "files" : ["\(self.fileServerName)" : ["content": "\(String(decoding: data, as: UTF8.self))"]]]
        
        guard let githubToken = getGithubToken() else { return }
        let stringUrl = "https://api.github.com/gists"
        guard let url = URL(string: stringUrl) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("token \(githubToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONSerialization.data(withJSONObject: newGist)

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                DDLogError(error.localizedDescription)
                return
            }
            let statusCode = (response as! HTTPURLResponse).statusCode
            guard 200..<300 ~= statusCode else {
                DDLogError("Incorrect status code: \(statusCode).")
                return
            }
            guard let gistId = try? JSONDecoder().decode(GistId.self, from: data!) else {
                DDLogError("Error while parsing gists.")
                return
            }
            UserDefaults.standard.set(gistId.id, forKey: "gistId")
        }
        task.resume()
    }
    
    func updateGists(notes: [Note]?) {
        let jsonNotes = notes?.map { $0.json } ?? [[String: Any]()]
        var data: Data
        do {
            data = try JSONSerialization.data(withJSONObject: jsonNotes, options: [])
        } catch(let error) {
            DDLogError(error.localizedDescription)
            return
        }
        let newGist: [String : Any] = [
            "public" : false,
            "files" : ["\(self.fileServerName)" : ["content": "\(String(decoding: data, as: UTF8.self))"]]]
        
        guard let githubToken = getGithubToken() else { return }
        let rawUrl = UserDefaults.standard.object(forKey: "gistId") as? String
        let stringUrl = "https://api.github.com/gists/\(rawUrl!)"
        let components = URLComponents(string: stringUrl)
        guard let url = components?.url else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("token \(githubToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONSerialization.data(withJSONObject: newGist)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                DDLogError(error.localizedDescription)
                return
            }
            let statusCode = (response as! HTTPURLResponse).statusCode
            guard 200..<300 ~= statusCode else {
                DDLogError("Error: Incorrect status code: \(statusCode).")
                return
            }
        }
        task.resume()
    }
    
}
