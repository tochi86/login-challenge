import UIKit
import SwiftUI
import Combine

@MainActor
final class LoginViewController: UIViewController {
    @IBOutlet private var idField: UITextField!
    @IBOutlet private var passwordField: UITextField!
    @IBOutlet private var loginButton: UIButton!

    private var activityIndicatorViewController: ActivityIndicatorViewController?

    private let viewModel = LoginViewModel()

    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.$state.map(\.isIdFieldEnalbed)
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .assign(to: \.isEnabled, on: idField)
            .store(in: &cancellables)

        viewModel.$state.map(\.isPasswordFieldEnabled)
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .assign(to: \.isEnabled, on: passwordField)
            .store(in: &cancellables)

        viewModel.$state.map(\.isLoginButtonEnabled)
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .assign(to: \.isEnabled, on: loginButton)
            .store(in: &cancellables)

        viewModel.$state.map(\.isLoading)
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                guard let self = self else { return }

                if self.activityIndicatorViewController != nil {
                    self.dismiss(animated: true)
                    self.activityIndicatorViewController = nil
                }

                if isLoading {
                    let activityIndicatorViewController: ActivityIndicatorViewController = .init()
                    activityIndicatorViewController.modalPresentationStyle = .overFullScreen
                    activityIndicatorViewController.modalTransitionStyle = .crossDissolve
                    self.present(activityIndicatorViewController, animated: true)
                    self.activityIndicatorViewController = activityIndicatorViewController
                }
            }
            .store(in: &cancellables)

        viewModel.$state.map(\.showErrorAlert)
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [weak self] errorAlert in
                guard let self = self else { return }

                let alertController: UIAlertController = .init(
                    title: errorAlert.title,
                    message: errorAlert.message,
                    preferredStyle: .alert
                )
                alertController.addAction(.init(title: errorAlert.buttonTitle, style: .default, handler: nil))

                self.present(alertController, animated: true)
                self.viewModel.onErrorAlertDidShow()
            }
            .store(in: &cancellables)

        viewModel.$state.map(\.showHomeView)
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .filter { $0 }
            .sink { [weak self] _ in
                guard let self = self else { return }

                let destination = UIHostingController(
                    rootView: HomeView(dismiss: { [weak self] in
                        self?.dismiss(animated: true)
                    })
                )
                destination.modalPresentationStyle = .fullScreen
                destination.modalTransitionStyle = .flipHorizontal

                self.present(destination, animated: true)
                self.viewModel.onHomeViewDidShow()
            }
            .store(in: &cancellables)
    }
    
    // ログインボタンが押されたときにログイン処理を実行。
    @IBAction private func loginButtonPressed(_ sender: UIButton) {
        viewModel.onLoginButtonDidTap()
    }
    
    // ID およびパスワードのテキストが変更されたときに View の状態を更新。
    @IBAction private func inputFieldValueChanged(sender: UITextField) {
        viewModel.onInputFieldValueChanged(id: idField.text ?? "",
                                           password: passwordField.text ?? "")
    }
}
