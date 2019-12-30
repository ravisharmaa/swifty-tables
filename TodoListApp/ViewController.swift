import UIKit

class ViewController: UIViewController {
    
    //MARK:- Data Source
    var toDos = [Todo]()
    
    var filteredData: [Todo] = []
    
    
    //MARK:- Subviews
    lazy var todoListTableView: UITableView = {
        
        let tableView = UITableView()
        return tableView
        
    }()
    
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        return searchBar
    }()
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        navigationItem.title = "Todo List Table Views"
        //navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.rightBarButtonItem = editButtonItem
        
        // ui search bar sub view and its constraints
        view.addSubview(searchBar)
        setupSearchBarConstraints()
        
        // todo list table view and its constraints
        view.addSubview(todoListTableView)
        setupTableViewConstraints()
        
        //fetch data from api
        getDataFromUrl()
        
        
    }
    
    //MARK:- Constraints for search bar
    
    func setupSearchBarConstraints() {
        
        searchBar.delegate = self
        
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 50),
            searchBar.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        
    }
    
    //MARK:- Constraints for table view
    func setupTableViewConstraints() {
        
        todoListTableView.dataSource = self
        todoListTableView.delegate = self
        todoListTableView.translatesAutoresizingMaskIntoConstraints = false
        todoListTableView.allowsSelectionDuringEditing = true
        
        todoListTableView.register(TodoListTableViewCell.self, forCellReuseIdentifier: "todoCell")
        
        // code to create self sizing cells
        todoListTableView.estimatedRowHeight = 50.0
        
        todoListTableView.rowHeight = UITableView.automaticDimension
        
        NSLayoutConstraint.activate([
            todoListTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            todoListTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            todoListTableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            todoListTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    fileprivate func getDataFromUrl() {
        
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/todos") else { return  }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard let jsonData = data else { return }
            
            do {
                let todo = try JSONDecoder().decode([Todo].self, from: jsonData)
                self.toDos = todo
                self.filteredData = self.toDos
                DispatchQueue.main.async { [weak self ] in
                    self?.todoListTableView.reloadData()
                }
            } catch let jsonError {
                print("Could not parse json \(jsonError)")
            }
        }.resume()
    }
    
    
}


extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.filteredData.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell") as! TodoListTableViewCell
        
        let todo = self.filteredData[indexPath.row]
        
        cell.setFields(todo)
        
        return cell
        
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            self.filteredData.remove(at: indexPath.row)
            
            tableView.beginUpdates()
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            tableView.endUpdates()
        }
    }
    
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        self.todoListTableView.setEditing(editing ? true : false, animated: animated)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    // MARK:- Showing another view controller
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let desitnationViewController = DetailTableViewController()
        
        desitnationViewController.todo = self.filteredData[indexPath.row]
        
        self.navigationController?.pushViewController(desitnationViewController, animated: true)
    }
    
    //handler for swipe in leading direction
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let favoriteAction = UIContextualAction(style: .normal, title: "Favorite") { (action, view, nil) in
            print("fav action")
        }
        
        let dislikeAction = UIContextualAction(style: .normal, title: "Dislike") { (action, view, nil) in
            print("dislike button")
        }
        
        favoriteAction.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        
        dislikeAction.backgroundColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
        
        let swipeActionConfiguration = UISwipeActionsConfiguration(actions: [
            favoriteAction, dislikeAction
        ])
        
        // disable the full swipe to preceed in unwanted action
        swipeActionConfiguration.performsFirstActionWithFullSwipe = false
        
        return swipeActionConfiguration
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let infoAction = UIContextualAction(style: .normal, title: "Info") { (action, view, nil) in
            print("fav action")
        }
        
        
        let readAction = UIContextualAction(style: .destructive, title: "Read") { (action, view, nil) in
            print("fav action")
        }
        
        let swipeActionConfiguration = UISwipeActionsConfiguration(actions: [
            infoAction, readAction
        ])
        
        // disable the full swipe to preceed in unwanted action
        swipeActionConfiguration.performsFirstActionWithFullSwipe = false
        return swipeActionConfiguration
    }
    
}

//UI Search bar

extension ViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        guard !searchText.isEmpty else {
            filteredData = toDos
            self.todoListTableView.reloadData()
            return
        }
        
        filteredData = toDos.filter({ (todo) -> Bool in
            return todo.title.contains(searchText)
        })
        
        todoListTableView.reloadData()
    }
}
