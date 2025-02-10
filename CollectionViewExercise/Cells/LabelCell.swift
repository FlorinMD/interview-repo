import UIKit

class LabelCell: UICollectionViewCell {
    static let reuseIdentifier = "label-cell-reuse-identifier"
    let defaults = UserDefaults.standard
    let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }
}

extension LabelCell {
    func configure() {
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        let inset = CGFloat(10)
        setupUI()

        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
            ])
    }

    func setupUI() {
        let _ = UIImage(named: "image")
        let shouldDrawBorder = defaults.bool(forKey: "shouldDrawBorder")

        if shouldDrawBorder {
            layer.borderWidth = 1
            layer.borderColor = UIColor.systemGray2.cgColor
        }
    }
}
