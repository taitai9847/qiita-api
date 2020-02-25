//
//  ViewController.swift
//  qiitAPI
//
//  Created by ishikawa on 2020/02/13.
//  Copyright © 2020 ishikawa. All rights reserved.
//

import UIKit

//structを定義したところでArticle型ができている
struct Article: Codable {
    var title:String
    var url: String
    var user: User
    struct User: Codable {
        var id: String
    }
}
//API部分
struct Qiita {
    
    static func fetchArticle(completion: @escaping ([Article]) -> Swift.Void) {
        
        let url = "https://qiita.com/api/v2/items"
        
        guard var urlComponents = URLComponents(string: url) else {
            return
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "per_page", value: "100")
        ]
        
        let task = URLSession.shared.dataTask(with: urlComponents.url!) { (data, response, error) in
            
            guard let jsonData = data else{
                return
            }
            
            do {
                // JSONに変換
                let articles = try JSONDecoder().decode([Article].self, from: jsonData)
                completion(articles)
            } catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
}
//escaping & completion
class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var articles: [Article] = []
    var qiitaURL: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //tableviwにUITableDataSourceとUITableDelegateを適用する
        tableView.dataSource = self
        tableView.delegate = self
        Qiita.fetchArticle { (articles) in
            self.articles = articles
            // tableViewの更新
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    //ここでSecindViewControllerにデータを送っている
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let secondVC: SecondViewController = segue.destination as! SecondViewController
        if let qiitaOptURL = qiitaURL{
            secondVC.qiitaArticleUrl = qiitaOptURL
        }
    }
    
    @IBAction func unwindToSecondVC(_ unwindSegue: UIStoryboardSegue) {
        if (unwindSegue.identifier == "back") {
            let sourceViewController = unwindSegue.source
            print(sourceViewController)
        }
        // Use data from the view controller which initiated the unwind segue
    }
}


// tableViewについて
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        let article = articles[indexPath.row]
        print(article.url)
        cell.textLabel?.text = article.title
        cell.detailTextLabel?.text = article.user.id
        return cell
    }
}

//セルが選択された時の挙動
extension ViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //選択されたセルのindexpathからrowを取り出す、。それがarticlesが配列からrowに一致するarticleを取り出す。それをqiitaURLにセットする。
        let row: Int = indexPath.row
        let article: Article = articles[row]
        let qiitaUrl: String = article.url
        self.qiitaURL = qiitaUrl
        performSegue(withIdentifier: "toSecondViewController",sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
