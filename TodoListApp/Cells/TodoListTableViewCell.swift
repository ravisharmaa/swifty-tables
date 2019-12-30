import UIKit

class TodoListTableViewCell: UITableViewCell {
    
    
    //MARK:- Subviews
    lazy var todoTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints =  false
        label.numberOfLines = 0
        return label
    }()
    
    
    
    lazy var indicatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    //MARK:- Data Source
    private var todoData: Todo? {
        
        didSet {
            todoTitleLabel.text = todoData?.title
            indicatorView.backgroundColor = todoData!.completed ? .green : .red
        }
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: "todoCell")
        
        setupIndicatorView()
        
        setupTitleLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupTitleLabel() -> Void {
        contentView.addSubview(todoTitleLabel)
        
        NSLayoutConstraint.activate([
            todoTitleLabel.leadingAnchor.constraint(equalTo: self.indicatorView.trailingAnchor, constant: 16),
            todoTitleLabel.centerYAnchor.constraint(equalTo: self.indicatorView.centerYAnchor)
        ])
    }
    
    func setupIndicatorView() {
        
        contentView.addSubview(indicatorView)
        
        indicatorView.layer.cornerRadius = 10
        
        NSLayoutConstraint.activate([
            indicatorView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            indicatorView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            indicatorView.heightAnchor.constraint(equalToConstant: 20),
            indicatorView.widthAnchor.constraint(equalToConstant: 20)
        ])
        
    }
    
    func setFields(_ todo: Todo) {
        self.todoData = todo
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.todoTitleLabel.text = nil
        self.indicatorView.backgroundColor = nil
    }
    
    
}
