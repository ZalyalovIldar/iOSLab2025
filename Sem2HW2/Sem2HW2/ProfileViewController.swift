import UIKit

final class ProfileViewController: UIViewController {

    private let cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerRadius = 24
        return view
    }()

    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .systemBlue
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private let emailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private let followButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 14
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        return button
    }()

    var onFollowTap: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupActions()
    }

    func configure(profile: UserProfile, isFollowing: Bool) {
        avatarImageView.image = UIImage(systemName: profile.avatarSystemName)
        nameLabel.text = profile.name
        emailLabel.text = profile.email
        updateButton(isFollowing: isFollowing)
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground

        view.addSubview(cardView)
        cardView.addSubview(avatarImageView)
        cardView.addSubview(nameLabel)
        cardView.addSubview(emailLabel)
        cardView.addSubview(followButton)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            cardView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            cardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            avatarImageView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 24),
            avatarImageView.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 100),
            avatarImageView.heightAnchor.constraint(equalToConstant: 100),

            nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),

            emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            emailLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            emailLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),

            followButton.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 20),
            followButton.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            followButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            followButton.heightAnchor.constraint(equalToConstant: 50),
            followButton.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -24)
        ])
    }

    private func setupActions() {
        followButton.addTarget(self, action: #selector(followTapped), for: .touchUpInside)
    }

    private func updateButton(isFollowing: Bool) {
        if isFollowing {
            followButton.setTitle("Following", for: .normal)
            followButton.backgroundColor = .systemGray5
            followButton.setTitleColor(.label, for: .normal)
        } else {
            followButton.setTitle("Follow", for: .normal)
            followButton.backgroundColor = .systemBlue
            followButton.setTitleColor(.white, for: .normal)
        }
    }

    @objc
    private func followTapped() {
        onFollowTap?()
    }
}
