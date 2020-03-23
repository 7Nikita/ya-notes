//
//  GithubViewController.swift
//  ya-notes
//
//  Created by Nikita Pekurin on 3/8/20.
//  Copyright © 2020 Nikita Pekurin. All rights reserved.
//

import UIKit
import WebKit
import CocoaLumberjack

protocol GithubViewControllerDelegate: class {
    func handleTokenChanged(token: String)
}

class GithubViewController: UIViewController {
    
    private let clientId = "41258db0d52fb7ddf142"
    private let clientSecret = "e2706004c6adef4d62863a38e8b92acef4575351"
    
    private let webView = WKWebView()
    
    weak var delegate: GithubViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        guard let request = codeGetRequest else { return }
        webView.load(request)
        webView.navigationDelegate = self
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
    }
    
    private var codeGetRequest: URLRequest? {
        let stringUrl = "https://github.com/login/oauth/authorize"
        guard var urlComponents = URLComponents(string: stringUrl) else { return nil }
        urlComponents.queryItems = [
            URLQueryItem(name: "scope", value: "gist"),
            URLQueryItem(name: "client_id", value: "\(clientId)")
        ]
        guard let url = urlComponents.url else { return nil }
        return URLRequest(url: url)
    }
    
    func getTokenBy(code: String) {
        let stringUrl = "https://github.com/login/oauth/access_token"
        var components = URLComponents(string: stringUrl)
        components?.queryItems = [
            URLQueryItem(name: "client_id", value: "\(clientId)"),
            URLQueryItem(name: "client_secret", value: "\(clientSecret)"),
            URLQueryItem(name: "code", value: "\(code)")
        ]
        guard let url = components?.url else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse {
                defer {
                    DispatchQueue.main.async {
                        self.dismiss(animated: true, completion: nil)
                    }
                }
                switch response.statusCode {
                case 200..<300:
                    guard let data = data else { return }
                    do {
                        if let content = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] {
                            if let token = content["access_token"] as? String {
                                self.delegate?.handleTokenChanged(token: token)
                            }
                        }
                    } catch {}
                    
                default:
                    DDLogError("Status: \(response.statusCode)")
                }
            }
        }
        task.resume()
    }
}


extension GithubViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        defer {
            decisionHandler(.allow)
        }
        
        if let url = navigationAction.request.url, url.scheme == "https" {
            let targetString = url.absoluteString.replacingOccurrences(of: "#", with: "?")
            guard let components = URLComponents(string: targetString) else { return }
            
            if let code = components.queryItems?.first(where: { $0.name == "code" })?.value {
                getTokenBy(code: code)
            }
        }
    }
}
