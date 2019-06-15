//
//  NewAgeViewController.swift
//  Age
//
//  Created by Amin on 2019-05-17.
//  Copyright © 2019 Amin Heidari. All rights reserved.
//

import UIKit

class NewAgeViewController: BaseViewController {
    
    // MARK: - Constants/Types
    
    enum Scenario {
        case newDefault
        case editDefault
        case newEntity
        case editEntity(birthdayEntity: BirthdayEntity)
    }
    
    // MARK: - Static
    
    static private func evaluateDefaultBirthDate() -> BirthDate {
        let calendar = Calendar.current
        return BirthDate(
            year: calendar.component(.year, from: Date()) - RemoteConfigManager.shared.remoteConfig.ageSpecs.defaultAge,
            month: calendar.component(.month, from: Date()),
            day: calendar.component(.day, from: Date())
        )
    }
        
    // MARK: - API
    
    var scenario: Scenario!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch scenario! {
        case .newDefault:
            closeButton.isHidden = true
            deleteButton.isHidden = true
            editingBirthDate = NewAgeViewController.evaluateDefaultBirthDate()
        case .editDefault:
            closeButton.isHidden = false
            deleteButton.isHidden = true
            let birthday = UserDefaultsUtil.defaultBirthday!
            editingBirthDate = birthday.birthDate
            nameTextField.text = birthday.name
        case .newEntity:
            closeButton.isHidden = false
            fatalError("Not implemented yet!")
        case .editEntity(let birthdayEntity):
            _ = birthdayEntity
            closeButton.isHidden = false
            fatalError("Not implemented yet!")
        }
        
        datePicker.date = editingBirthDate.date
        
//        nameTextFieldDelegate = NameTextFieldDelegate(self)
//        nameTextField.delegate = nameTextFieldDelegate
        
//        dateTextFieldDelegate = DateTextFieldDelegate(self)
//        dateTextField.delegate = dateTextFieldDelegate
        
        dateTextField.inputView = datePicker
        
        isProcessing = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateProceedButton()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // MARK: - Properties
    
    private var isProcessing: Bool = false {
        didSet {
            if (isProcessing) {
                nameTextField.isEnabled = false
                dateTextField.isEnabled = false
                deleteButton.isEnabled = false
                proceedButton.isEnabled = false
                activityIndicator.isHidden = false
            } else {
                nameTextField.isEnabled = true
                dateTextField.isEnabled = true
                deleteButton.isEnabled = true
                proceedButton.isEnabled = true
                activityIndicator.isHidden = true
            }
        }
    }
    
    private var editingBirthDate: BirthDate! {
        didSet {
            guard let value = editingBirthDate else {
                dateTextField.text = nil
                return
            }
            dateTextField.text = String(format: "%d - %d - %d", value.year, value.month, value.day)
        }
    }
    
    // MARK: - Outlets
    
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var dateTextField: UITextField!
    
    // Because the datePicker is not a permanent subview of the view, it has to be strong.
    // Read this again if you got confused: https://cocoacasts.com/should-outlets-be-weak-or-strong
    @IBOutlet private var datePicker: UIDatePicker!
    
    @IBOutlet private weak var deleteButton: UIButton!
    @IBOutlet private weak var proceedButton: UIButton!
    @IBOutlet private weak var closeButton: UIButton!
    
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Methods
    
    private func updateProceedButton() {
        proceedButton.isEnabled = nameTextField.text?.isNonEmpty ?? false
    }
    
    // MARK: - Actions
    
    @IBAction private func closeButtonTapped(_ sender: Any) {
        guard !isProcessing else { return }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func proceedButtonTapped(_ sender: Any) {
        let birthday = Birthday(birthDate: editingBirthDate, name: (nameTextField.text ?? ""))
        
        switch scenario! {
        case .newDefault:
            UserDefaultsUtil.defaultBirthday = birthday
            performSegue(withIdentifier: "age", sender: nil)
        case .editDefault:
            UserDefaultsUtil.defaultBirthday = birthday
            dismiss(animated: true, completion: nil)
        case .newEntity:
            fatalError("Not implemented yet!")
        case .editEntity(let birthdayEntity):
            _ = birthdayEntity
            fatalError("Not implemented yet!")
        }
        
//        _ = DatabaseManager.shared.addBirthday(Birthday(birthDate: BirthDate(year: 1988, month: 6, day: 24), name: "Amin")) { [weak self] _ in
//            self?.dismiss(animated: true, completion: nil)
//        }
    }
    
    @IBAction private func deleteButtonTapped(_ sender: Any) {
        
    }
    
    @IBAction private func nameTextFieldEdited(_ sender: Any) {
        updateProceedButton()
    }
    
    @IBAction private func nameTextFieldReturned(_ sender: Any) {
        nameTextField.resignFirstResponder()
    }
    
    @IBAction func datePickerValueChanged(_ sender: Any) {
        editingBirthDate = datePicker.date.birthDate
    }
    
    
    // This is my way of mimicing Anonymous classes/objects on Android.
    // Because I don't like to set the ViewController as the delegate for everything all the time.
    var nameTextFieldDelegate: NameTextFieldDelegate!
    class NameTextFieldDelegate: NSObject, UITextFieldDelegate {
        
        private weak var viewController: NewAgeViewController?
        
        init(_ viewController: NewAgeViewController) {
            self.viewController = viewController
        }
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            viewController?.dateTextField.becomeFirstResponder()
            return true
        }
        
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            viewController?.updateProceedButton()
            return true
        }
        
    }
    
    var dateTextFieldDelegate: DateTextFieldDelegate!
    class DateTextFieldDelegate: NSObject, UITextFieldDelegate {
        
        private weak var viewController: NewAgeViewController?
        
        init(_ viewController: NewAgeViewController) {
            self.viewController = viewController
        }
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            viewController?.dateTextField.resignFirstResponder()
            return true
        }
        
    }

}

private extension BirthDate {
    var date: Date {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        return Calendar.current.date(from: components)!
    }
}
