//
//  EVMBaseDemoViewController.swift
//  BloctoSDK_Example
//
//  Created by Andrew Wang on 2022/5/11.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit
import SafariServices
import RxSwift
import RxCocoa
import SnapKit
import BloctoSDK
import web3
import BigInt

// swiftlint:disable type_body_length
final class EVMBaseDemoViewController: UIViewController {

    private var userWalletAddress: String?

    private lazy var bloctoEthereumSDK = BloctoSDK.shared.ethereum

    private var selectedBlockchain: EVMBase = .ethereum

    private lazy var rpcClient = selectedBlockchain.rpcClient

    private lazy var networkSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["testnet", "mainnet"])
        segmentedControl.selectedSegmentIndex = 0
        return segmentedControl
    }()

    private let blockchainSelections: [EVMBase] = EVMBase.allCases

    private lazy var blockchainSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: blockchainSelections.map { $0.displayString })
        segmentedControl.selectedSegmentIndex = 0
        return segmentedControl
    }()

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .white

        scrollView.addSubview(contentView)

        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        return scrollView
    }()

    private lazy var contentView: UIView = {
        let view = UIView()

        view.addSubview(titleLabel)

        view.addSubview(requestAccountButton)
        view.addSubview(requestAccountResultLabel)
        view.addSubview(requestAccountCopyButton)
        view.addSubview(requestAccountExplorerButton)

        view.addSubview(separator1)

        view.addSubview(setValueTitleLabel)
        view.addSubview(nomalTxInputTextField)
        view.addSubview(setValueButton)
        view.addSubview(setValueResultLabel)
        view.addSubview(setValueExplorerButton)

        view.addSubview(separator2)

        view.addSubview(getValueTitleLabel)
        view.addSubview(getValueButton)
        view.addSubview(getValueResultLabel)

        view.addSubview(separator3)

        view.addSubview(sendValueTxTitleLabel)
        view.addSubview(valueTxInputTextField)
        view.addSubview(sendValueTxButton)
        view.addSubview(sendValueTxResultLabel)
        view.addSubview(sendValueTxExplorerButton)

        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(30)
            $0.leading.trailing.equalToSuperview().inset(20)
        }

        requestAccountButton.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(50)
            $0.leading.equalToSuperview().inset(20)
        }

        requestAccountResultLabel.snp.makeConstraints {
            $0.top.equalTo(requestAccountButton.snp.bottom).offset(20)
            $0.leading.equalToSuperview().inset(20)
        }

        requestAccountCopyButton.snp.makeConstraints {
            $0.centerY.equalTo(requestAccountResultLabel)
            $0.size.equalTo(40)
            $0.leading.equalTo(requestAccountResultLabel.snp.trailing).offset(20)
        }

        requestAccountExplorerButton.snp.makeConstraints {
            $0.centerY.equalTo(requestAccountCopyButton)
            $0.size.equalTo(40)
            $0.leading.equalTo(requestAccountCopyButton.snp.trailing).offset(20)
            $0.trailing.equalToSuperview().inset(20)
        }

        separator1.snp.makeConstraints {
            $0.top.equalTo(requestAccountResultLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
        }

        setValueTitleLabel.snp.makeConstraints {
            $0.top.equalTo(separator1.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
        }

        nomalTxInputTextField.snp.makeConstraints {
            $0.top.equalTo(setValueTitleLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(35)
        }

        setValueButton.snp.makeConstraints {
            $0.top.equalTo(nomalTxInputTextField.snp.bottom).offset(20)
            $0.leading.equalToSuperview().inset(20)
        }

        setValueResultLabel.snp.makeConstraints {
            $0.top.equalTo(setValueButton.snp.bottom).offset(20)
            $0.leading.equalToSuperview().inset(20)
        }

        setValueExplorerButton.snp.makeConstraints {
            $0.centerY.equalTo(setValueResultLabel)
            $0.size.equalTo(40)
            $0.leading.equalTo(setValueResultLabel.snp.trailing).offset(20)
            $0.trailing.equalToSuperview().inset(20)
        }

        separator2.snp.makeConstraints {
            $0.top.equalTo(setValueResultLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
        }

        getValueTitleLabel.snp.makeConstraints {
            $0.top.equalTo(separator2.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
        }

        getValueButton.snp.makeConstraints {
            $0.top.equalTo(getValueTitleLabel.snp.bottom).offset(20)
            $0.leading.equalToSuperview().inset(20)
        }

        getValueResultLabel.snp.makeConstraints {
            $0.top.equalTo(getValueButton.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
        }

        separator3.snp.makeConstraints {
            $0.top.equalTo(getValueResultLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
        }

        sendValueTxTitleLabel.snp.makeConstraints {
            $0.top.equalTo(separator3.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
        }

        valueTxInputTextField.snp.makeConstraints {
            $0.top.equalTo(sendValueTxTitleLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(35)
        }

        sendValueTxButton.snp.makeConstraints {
            $0.top.equalTo(valueTxInputTextField.snp.bottom).offset(20)
            $0.leading.equalToSuperview().inset(20)
        }

        sendValueTxResultLabel.snp.makeConstraints {
            $0.top.equalTo(sendValueTxButton.snp.bottom).offset(20)
            $0.leading.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(50)
        }

        sendValueTxExplorerButton.snp.makeConstraints {
            $0.centerY.equalTo(sendValueTxResultLabel)
            $0.size.equalTo(40)
            $0.leading.equalTo(sendValueTxResultLabel.snp.trailing).offset(20)
            $0.trailing.equalToSuperview().inset(20)
        }

        return view
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 35, weight: .semibold)
        label.textColor = .black
        label.textAlignment = .left
        label.text = "Value dApp"
        return label
    }()

    private lazy var requestAccountButton: UIButton = createButton(
        text: "Request account",
        indicator: requestAccountLoadingIndicator)

    private lazy var requestAccountLoadingIndicator = createLoadingIndicator()

    private lazy var requestAccountResultLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    private lazy var requestAccountCopyButton: UIButton = {
        let button: UIButton = UIButton()
        button.setImage(UIImage(named: "ic28Copy"), for: .normal)
        button.contentEdgeInsets = .init(top: 4, left: 4, bottom: 4, right: 4)
        button.isHidden = true
        return button
    }()

    private lazy var requestAccountExplorerButton: UIButton = {
        let button: UIButton = UIButton()
        button.setImage(UIImage(named: "ic28Earth"), for: .normal)
        button.contentEdgeInsets = .init(top: 4, left: 4, bottom: 4, right: 4)
        button.isHidden = true
        return button
    }()

    private lazy var separator1 = createSeparator()

    private lazy var setValueTitleLabel: UILabel = createLabel(text: "Set a Value")

    private lazy var nomalTxInputTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.textColor = .black
        textField.backgroundColor = .lightGray
        textField.text = "5566"
        textField.returnKeyType = .done
        textField.delegate = self
        textField.leftViewMode = .always
        textField.layer.cornerRadius = 5
        textField.clipsToBounds = true
        let leftView = UIView()
        leftView.snp.makeConstraints {
            $0.size.equalTo(10)
        }
        textField.leftView = leftView
        return textField
    }()

    private lazy var setValueButton: UIButton = createButton(
        text: "Send transaction",
        indicator: setValueLoadingIndicator)

    private lazy var setValueLoadingIndicator = createLoadingIndicator()

    private lazy var setValueResultLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    private lazy var setValueExplorerButton: UIButton = {
        let button: UIButton = UIButton()
        button.setImage(UIImage(named: "ic28Earth"), for: .normal)
        button.contentEdgeInsets = .init(top: 4, left: 4, bottom: 4, right: 4)
        button.isHidden = true
        return button
    }()

    private lazy var separator2 = createSeparator()

    private lazy var getValueTitleLabel: UILabel = createLabel(text: "Get a Value from Account's Data")

    private lazy var getValueButton: UIButton = createButton(
        text: "Get Value",
        indicator: getValueLoadingIndicator)

    private lazy var getValueLoadingIndicator = createLoadingIndicator()

    private lazy var getValueResultLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()

    private lazy var separator3 = createSeparator()

    private lazy var sendValueTxTitleLabel: UILabel = createLabel(text: "Send transaction with native coin value")

    private lazy var valueTxInputTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.textColor = .black
        textField.backgroundColor = .lightGray
        textField.text = "100"
        textField.returnKeyType = .done
        textField.delegate = self
        textField.leftViewMode = .always
        textField.rightViewMode = .always
        textField.layer.cornerRadius = 5
        textField.clipsToBounds = true
        let leftView = UIView()

        leftView.snp.makeConstraints {
            $0.size.equalTo(10)
        }

        let rightView = UILabel()
        rightView.text = "wei   "

        textField.leftView = leftView
        textField.rightView = rightView
        return textField
    }()

    private lazy var sendValueTxButton: UIButton = createButton(
        text: "Send Tx with value",
        indicator: sendValueTxLoadingIndicator)

    private lazy var sendValueTxLoadingIndicator = createLoadingIndicator()

    private lazy var sendValueTxResultLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()

    private lazy var sendValueTxExplorerButton: UIButton = {
        let button: UIButton = UIButton()
        button.setImage(UIImage(named: "ic28Earth"), for: .normal)
        button.contentEdgeInsets = .init(top: 4, left: 4, bottom: 4, right: 4)
        button.isHidden = true
        return button
    }()

    private lazy var disposeBag: DisposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupBinding()
        title = "EVM Base"
    }

    private func setupViews() {
        view.backgroundColor = .white

        view.addSubview(networkSegmentedControl)
        view.addSubview(blockchainSegmentedControl)
        view.addSubview(scrollView)

        networkSegmentedControl.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.centerX.equalToSuperview()
            $0.leading.greaterThanOrEqualToSuperview().inset(20)
            $0.trailing.lessThanOrEqualToSuperview().inset(20)
        }

        blockchainSegmentedControl.snp.makeConstraints {
            $0.top.equalTo(networkSegmentedControl.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.leading.greaterThanOrEqualToSuperview().inset(20)
            $0.trailing.lessThanOrEqualToSuperview().inset(20)
        }

        scrollView.snp.makeConstraints {
            $0.top.equalTo(blockchainSegmentedControl.snp.bottom).offset(20)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }

        contentView.snp.makeConstraints {
            $0.width.equalTo(view)
        }
    }

    // swiftlint:disable cyclomatic_complexity
    private func setupBinding() {
        _ = networkSegmentedControl.rx.value.changed
            .take(until: rx.deallocated)
            .subscribe(onNext: { [weak self] index in
                guard let self = self else { return }
                guard let window = self.view.window else { return }
                self.resetRequestAccountStatus()
                self.resetSetValueStatus()
                self.resetGetValueStatus()
                self.resetValueTxStatus()
                switch index {
                case 0:
                    isProduction = false
                case 1:
                    isProduction = true
                default:
                    break
                }
                if #available(iOS 13.0, *) {
                    BloctoSDK.shared.initialize(
                        with: bloctoSDKAppId,
                        window: window,
                        logging: true,
                        testnet: !isProduction)
                } else {
                    BloctoSDK.shared.initialize(
                        with: bloctoSDKAppId,
                        logging: true,
                        testnet: !isProduction)
                }
            })

        _ = blockchainSegmentedControl.rx.value.changed
            .take(until: rx.deallocated)
            .subscribe(onNext: { [weak self] index in
                guard let self = self else { return }
                self.resetRequestAccountStatus()
                self.resetSetValueStatus()
                self.resetGetValueStatus()
                self.resetValueTxStatus()
                self.selectedBlockchain = self.blockchainSelections[index]
                self.rpcClient = self.selectedBlockchain.rpcClient
            })

        _ = requestAccountButton.rx.tap
            .throttle(
                DispatchTimeInterval.milliseconds(500),
                latest: false,
                scheduler: MainScheduler.instance)
            .take(until: rx.deallocated)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.resetRequestAccountStatus()

                self.selectedBlockchain.sdkProvider.requestAccount { [weak self] result in
                    switch result {
                    case .success(let address):
                        self?.userWalletAddress = address
                        self?.requestAccountResultLabel.text = address
                        self?.requestAccountCopyButton.isHidden = false
                        self?.requestAccountExplorerButton.isHidden = false
                    case .failure(let error):
                        self?.handleRequestAccountError(error)
                    }
                }
            })

        _ = requestAccountCopyButton.rx.tap
            .throttle(
                DispatchTimeInterval.milliseconds(500),
                latest: false,
                scheduler: MainScheduler.instance)
            .take(until: rx.deallocated)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self,
                      let address = self.requestAccountResultLabel.text else { return }
                UIPasteboard.general.string = address
                self.requestAccountCopyButton.setImage(UIImage(named: "icon20Selected"), for: .normal)
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self.requestAccountCopyButton.setImage(UIImage(named: "ic28Copy"), for: .normal)
                }
            })

        _ = requestAccountExplorerButton.rx.tap
            .throttle(
                DispatchTimeInterval.milliseconds(500),
                latest: false,
                scheduler: MainScheduler.instance)
            .take(until: rx.deallocated)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self,
                      let address = self.requestAccountResultLabel.text else { return }
                self.routeToExplorer(with: .address(address))
            })

        _ = setValueButton.rx.tap
            .throttle(
                DispatchTimeInterval.milliseconds(500),
                latest: false,
                scheduler: MainScheduler.instance)
            .take(until: rx.deallocated)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.resetSetValueStatus()
                self.setValueLoadingIndicator.startAnimating()
                self.sendTransaction()
            })

        _ = setValueExplorerButton.rx.tap
            .throttle(
                DispatchTimeInterval.milliseconds(500),
                latest: false,
                scheduler: MainScheduler.instance)
            .take(until: rx.deallocated)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self,
                      let hash = self.setValueResultLabel.text else { return }
                self.routeToExplorer(with: .txhash(hash))
            })

        _ = getValueButton.rx.tap
            .throttle(
                DispatchTimeInterval.milliseconds(500),
                latest: false,
                scheduler: MainScheduler.instance)
            .take(until: rx.deallocated)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.resetGetValueStatus()
                self.getValueLoadingIndicator.startAnimating()
                self.getValue()
            })

        _ = sendValueTxButton.rx.tap
            .throttle(
                DispatchTimeInterval.milliseconds(500),
                latest: false,
                scheduler: MainScheduler.instance)
            .take(until: rx.deallocated)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.resetValueTxStatus()
                self.sendValueTxLoadingIndicator.startAnimating()
                self.sendTransactionWithValue()
            })

        _ = sendValueTxExplorerButton.rx.tap
            .throttle(
                DispatchTimeInterval.milliseconds(500),
                latest: false,
                scheduler: MainScheduler.instance)
            .take(until: rx.deallocated)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self,
                      let hash = self.sendValueTxResultLabel.text else { return }
                self.routeToExplorer(with: .txhash(hash))
            })
    }

    private func createSeparator() -> UIView {
        let view = UIView()
        view.backgroundColor = .gray
        view.snp.makeConstraints {
            $0.height.equalTo(1)
        }
        return view
    }

    private func createLabel(text: String) -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.text = text
        label.textColor = .black
        label.textAlignment = .left
        return label
    }

    private func createButton(text: String, indicator: UIActivityIndicatorView) -> UIButton {
        let button: UIButton = UIButton()
        button.setTitle(text, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .blue
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.contentEdgeInsets = .init(top: 12, left: 35, bottom: 12, right: 35)

        button.addSubview(indicator)

        indicator.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(10)
            $0.centerY.equalToSuperview()
        }
        return button
    }

    private func createLoadingIndicator() -> UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
        indicator.color = .white
        return indicator
    }

    private func resetRequestAccountStatus() {
        requestAccountResultLabel.text = nil
        requestAccountResultLabel.textColor = .black
        requestAccountLoadingIndicator.stopAnimating()
        requestAccountCopyButton.isHidden = true
        requestAccountExplorerButton.isHidden = true
    }

    private func resetSetValueStatus() {
        setValueResultLabel.text = nil
        setValueResultLabel.textColor = .black
        setValueLoadingIndicator.stopAnimating()
        setValueExplorerButton.isHidden = true
    }

    private func resetGetValueStatus() {
        getValueResultLabel.text = nil
        getValueResultLabel.textColor = .black
        getValueLoadingIndicator.stopAnimating()
    }

    private func resetValueTxStatus() {
        sendValueTxResultLabel.text = nil
        sendValueTxResultLabel.textColor = .black
        sendValueTxLoadingIndicator.stopAnimating()
    }

    private func sendTransaction() {
        guard let userWalletAddress = userWalletAddress else {
            handleSetValueError(Error.message("User address not found. Please request account first."))
            return
        }
        guard let inputValue = nomalTxInputTextField.text,
              inputValue.isEmpty == false,
              let value = BigUInt(inputValue) else {
                  handleSetValueError(Error.message("Input not found."))
                  return
              }
        let setValueABIFunction = SetValueABIFunction(value: value)

        do {
            let functionData = try setValueABIFunction.functionData()

            let evmBaseTransaction = EVMBaseTransaction(
                to: selectedBlockchain.dappAddress,
                from: userWalletAddress,
                value: "0",
                data: functionData)
            selectedBlockchain.sdkProvider.sendTransaction(
                blockchain: selectedBlockchain.blockchain,
                transaction: evmBaseTransaction
            ) { [weak self] result in
                guard let self = self else { return }
                self.resetSetValueStatus()
                switch result {
                case let .success(txHsh):
                    self.setValueResultLabel.text = txHsh
                    self.setValueExplorerButton.isHidden = false
                case let .failure(error):
                    self.handleSetValueError(error)
                }
            }
        } catch {
            debugPrint(error)
        }
    }

    private func getValue() {
        let getValueABIFunction = GetValueABIFunction(
            contract: EthereumAddress(selectedBlockchain.dappAddress),
            from: nil,
            gasPrice: nil,
            gasLimit: nil)

        getValueABIFunction.call(
            withClient: rpcClient,
            responseType: GetValueABIFunction.Response.self) { [weak self] error, response in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.resetGetValueStatus()
                    if let error = error {
                        debugPrint(error)
                        self.handleGetValueError(error)
                    } else {
                        self.getValueResultLabel.text = response?.value.description
                    }
                }
            }
    }

    private func sendTransactionWithValue() {
        guard let userWalletAddress = userWalletAddress else {
            handleValueTxError(Error.message("User address not found. Please request account first."))
            return
        }
        guard let inputValue = valueTxInputTextField.text,
              inputValue.isEmpty == false,
              let value = BigUInt(inputValue) else {
                  handleValueTxError(Error.message("Input not found."))
                  return
              }
        let donateABIFunction = DonateABIFunction(message: "lalala")

        do {
            let functionData = try donateABIFunction.functionData()

            let evmBaseTransaction = EVMBaseTransaction(
                to: selectedBlockchain.dappAddress,
                from: userWalletAddress,
                value: value,
                data: functionData)
            selectedBlockchain.sdkProvider.sendTransaction(
                blockchain: selectedBlockchain.blockchain,
                transaction: evmBaseTransaction
            ) { [weak self] result in
                guard let self = self else { return }
                self.resetValueTxStatus()
                switch result {
                case let .success(txHsh):
                    self.sendValueTxResultLabel.text = txHsh
                    self.sendValueTxExplorerButton.isHidden = false
                case let .failure(error):
                    self.handleValueTxError(error)
                }
            }
        } catch {
            debugPrint(error)
        }
    }

    private func handleRequestAccountError(_ error: Swift.Error) {
        if let error = error as? QueryError {
            switch error {
            case .userRejected:
                requestAccountResultLabel.text = "user rejected."
            case .forbiddenBlockchain:
                requestAccountResultLabel.text = "Forbidden blockchain. You should check blockchain selection on Blocto developer dashboard."
            case .invalidResponse:
                requestAccountResultLabel.text = "invalid response."
            case .userNotMatch:
                requestAccountResultLabel.text = "user not matched."
            case .other(let code):
                requestAccountResultLabel.text = code
            }
        } else if let error = error as? Error {
            requestAccountResultLabel.text = error.message
        } else {
            requestAccountResultLabel.text = error.localizedDescription
        }
        requestAccountResultLabel.textColor = .red
        requestAccountLoadingIndicator.stopAnimating()
    }

    private func handleSetValueError(_ error: Swift.Error) {
        if let error = error as? QueryError {
            switch error {
            case .userRejected:
                setValueResultLabel.text = "user rejected."
            case .forbiddenBlockchain:
                setValueResultLabel.text = "Forbidden blockchain. You should check blockchain selection on Blocto developer dashboard."
            case .invalidResponse:
                setValueResultLabel.text = "invalid response."
            case .userNotMatch:
                setValueResultLabel.text = "user not matched."
            case .other(let code):
                setValueResultLabel.text = code
            }
        } else if let error = error as? Error {
            setValueResultLabel.text = error.message
        } else {
            setValueResultLabel.text = error.localizedDescription
        }
        setValueResultLabel.textColor = .red
        setValueLoadingIndicator.stopAnimating()
    }

    private func handleGetValueError(_ error: Swift.Error) {
        getValueResultLabel.text = error.localizedDescription
        getValueResultLabel.textColor = .red
        getValueLoadingIndicator.stopAnimating()
    }

    private func handleValueTxError(_ error: Swift.Error) {
        if let error = error as? QueryError {
            switch error {
            case .userRejected:
                sendValueTxResultLabel.text = "user rejected."
            case .forbiddenBlockchain:
                sendValueTxResultLabel.text = "Forbidden blockchain. You should check blockchain selection on Blocto developer dashboard."
            case .invalidResponse:
                sendValueTxResultLabel.text = "invalid response."
            case .userNotMatch:
                sendValueTxResultLabel.text = "user not matched."
            case .other(let code):
                sendValueTxResultLabel.text = code
            }
        } else if let error = error as? Error {
            sendValueTxResultLabel.text = error.message
        } else {
            sendValueTxResultLabel.text = error.localizedDescription
        }
        sendValueTxResultLabel.textColor = .red
        sendValueTxLoadingIndicator.stopAnimating()
    }

    private func routeToExplorer(with type: ExplorerURLType) {
        guard let url = selectedBlockchain.explorerURL(type: type) else { return }
        let safariVC = SFSafariViewController(url: url)
        if #available(iOS 13.0, *) {
            safariVC.modalPresentationStyle = .automatic
        } else {
            safariVC.modalPresentationStyle = .overCurrentContext
        }
        safariVC.delegate = self
        present(safariVC, animated: true, completion: nil)
    }

}

extension EVMBaseDemoViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}

extension EVMBaseDemoViewController: SFSafariViewControllerDelegate {}

extension EVMBaseDemoViewController {

    enum Error: Swift.Error {
        case message(String)

        var message: String {
            switch self {
            case let .message(message):
                return message
            }
        }
    }

}
