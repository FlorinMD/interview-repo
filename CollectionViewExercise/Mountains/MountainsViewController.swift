import UIKit

class MountainsViewController: UIViewController {
    enum Section: CaseIterable {
        case main
    }

    let mountainsController = MountainsController()
    let searchBar = UISearchBar(frame: .zero)
    var mountainsCollectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, MountainsController.Mountain>!
    var nameFilter: String?
    var delegate: MountainsDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Mountains Search"
        configureHierarchy()
        configureDataSource()
        performQuery(with: nil)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.delegate.didSelect()
        }
    }
}

extension MountainsViewController {
    /// - Tag: MountainsDataSource
    func configureDataSource() {

        let cellRegistration = UICollectionView.CellRegistration
        <LabelCell, MountainsController.Mountain> { (cell, indexPath, mountain) in
            // Populate the cell with our item description.
            cell.label.text = mountain.name
            cell.setupUI()
        }

        dataSource = UICollectionViewDiffableDataSource<Section, MountainsController.Mountain>(collectionView: mountainsCollectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: MountainsController.Mountain) -> UICollectionViewCell? in
            // Return the cell.
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }
    }

    /// - Tag: MountainsPerformQuery
    func performQuery(with filter: String?) {
        let mountains = mountainsController.filteredMountains(with: filter).sorted { $0.name < $1.name }

        var snapshot = NSDiffableDataSourceSnapshot<Section, MountainsController.Mountain>()
        snapshot.appendSections([.main])
        snapshot.appendItems(mountains)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

extension MountainsViewController {
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int,
                                                            layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection in
            let contentSize = layoutEnvironment.container.effectiveContentSize
            let columns = contentSize.width > 800 ? 3 : 2
            let spacing = CGFloat(10)
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .absolute(32))

            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: groupSize,
                repeatingSubitem: item,
                count: columns
            )
            group.interItemSpacing = .fixed(spacing)

            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = spacing
            section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)

            return section
        }
        return layout
    }

    func configureHierarchy() {
        view.backgroundColor = .systemBackground
        let layout = createLayout()
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        view.addSubview(collectionView)
        view.addSubview(searchBar)

        let views = ["cv": collectionView, "searchBar": searchBar]
        var constraints = [NSLayoutConstraint]()
        constraints.append(contentsOf: NSLayoutConstraint.constraints(
            withVisualFormat: "H:|[cv]|", options: [], metrics: nil, views: views))
        constraints.append(contentsOf: NSLayoutConstraint.constraints(
            withVisualFormat: "H:|[searchBar]|", options: [], metrics: nil, views: views))
        constraints.append(contentsOf: NSLayoutConstraint.constraints(
            withVisualFormat: "V:[searchBar]-20-[cv]|", options: [], metrics: nil, views: views))
        constraints.append(searchBar.topAnchor.constraint(
            equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 1.0))
        NSLayoutConstraint.activate(constraints)
        mountainsCollectionView = collectionView

        searchBar.delegate = self
    }
}

extension MountainsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        performQuery(with: searchText)
    }
}
