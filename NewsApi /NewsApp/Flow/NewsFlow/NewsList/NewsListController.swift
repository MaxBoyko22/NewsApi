//
//  NewsListController.swift
//  NewsApp
//
//  Created by Maximilian Boiko on 10.02.2021.
//

import UIKit

class NewsListController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    let refreshControl = UIRefreshControl()
    
    var articles: [Article] = []
    var page = 1
    var pagesize = 20
    var filters: [NewsApiParameter] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        
        getArticles(refresh: true, isSearch: false, completion: { (error) in
            if error == nil {
                self.tableView.reloadData()
            }
        })
    }
    
    @objc func refresh(_ sender: AnyObject){
        getArticles(refresh: true, isSearch: false, completion: { error in
            if error == nil {
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? FilterViewController {
            destination.delegate = self
        } else if let destination = segue.destination as? WebViewController, let row = sender as? Int {
            let article = articles[row]
            destination.url = article.url
        }
    }
    
    func getArticles(refresh: Bool, isSearch: Bool, completion: ((Error?) -> Void)? = nil) {
        if refresh {
            page = 1
        } else {
            page += 1
        }
        
        var params: [NewsApiParameter] = [.page(page), .pagesize(pagesize)]
        var endpoint: Endpoint = .topHeadLines
        
        if isSearch {
            params.append(.search(searchTextField.text ?? ""))
            endpoint = .everything
        } else {
            params.append(contentsOf: filters)
            if !params.contains(where: {$0.key == "country"}) {
                if filters.isEmpty {
                    params.append(.country(.us))
                }
            }
        }
        
        QueriesToAPI.shared.getArticles(endpoint: endpoint, params: params, completion: { (articles, error) in
            
            DispatchQueue.main.async {
                if let unwrapedArticles = articles {
                    if refresh {self.articles = []}
                    self.articles = self.articles + unwrapedArticles
                    completion?(error)
                } else {
                    completion?(error)
                }
            }
        })
    }
    
    @IBAction func seachButtonDidPress(_ sender: Any) {
        getArticles(refresh: true, isSearch: true, completion: { error in
            if error == nil {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        
        let article = articles[indexPath.row]
        cell.setUp(with: article)
        if let urlString = article.urlToImage, let imageUrl = URL(string: urlString) {
            cell.articleImageView.af.setImage(withURL: imageUrl)
        } else {
            cell.articleImageView.image = nil
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == articles.count - 3 {
            getArticles(refresh: false, isSearch: false, completion: { error in
                if error == nil {
                    DispatchQueue.main.async {
                        tableView.reloadData()
                    }
                }
            })
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "openWebView", sender: indexPath.row)
    }
}

extension NewsListController: FilterViewControllerDelegate {
    func didApplyFilters(_ filters: [NewsApiParameter]) {
        self.filters = filters
        
        getArticles(refresh: true, isSearch: false, completion: { error in
            if error == nil {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        })
    }
}
