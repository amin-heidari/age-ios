//
//  NewAgeViewController.swift
//  Age
//
//  Created by Amin on 2019-05-17.
//  Copyright © 2019 Amin Heidari. All rights reserved.
//

import UIKit
import AgeData

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
        let todayBirthDate = Date().birthDate
        return BirthDate(
            year: todayBirthDate.year - RemoteConfigManager.shared.remoteConfig.ageSpecs.defaultAge,
            month: todayBirthDate.month,
            day: todayBirthDate.day
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
            titleLabel.text = "Enter Your Age"
        case .editDefault:
            closeButton.isHidden = false
            deleteButton.isHidden = true
            let birthday = SuiteDefaultsUtil.defaultBirthday!
            editingBirthDate = birthday.birthDate
            nameTextField.text = birthday.name
            titleLabel.text = "Your Age"
        case .newEntity:
            closeButton.isHidden = false
            deleteButton.isHidden = true
            editingBirthDate = NewAgeViewController.evaluateDefaultBirthDate()
            titleLabel.text = "New Age"
        case .editEntity(let birthdayEntity):
            closeButton.isHidden = false
            deleteButton.isHidden = false
            let birthday = birthdayEntity.birthday!
            editingBirthDate = birthday.birthDate
            nameTextField.text = birthday.name
            titleLabel.text = "Edit Age"
        }
        
        datePicker.date = editingBirthDate.date
        
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
    
    override var isNavigationBarHidden: Bool { return true }
    
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
    
    @IBOutlet private weak var titleLabel: UILabel!
    
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
            SuiteDefaultsUtil.defaultBirthday = birthday
            performSegue(withIdentifier: "age", sender: nil)
        case .editDefault:
            SuiteDefaultsUtil.defaultBirthday = birthday
            dismiss(animated: true, completion: nil)
        case .newEntity:
            isProcessing = true
            DatabaseManager.shared.addBirthday(birthday) { [weak self] _ in
                self?.dismiss(animated: true, completion: nil)
            }
        case .editEntity(let birthdayEntity):
            isProcessing = true
            DatabaseManager.shared.updateBirthday(birthdayEntity, with: birthday)
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction private func deleteButtonTapped(_ sender: Any) {
        switch scenario! {
        case .editEntity(let birthdayEntity):
            isProcessing = true
            DatabaseManager.shared.deleteBirthday(birthdayEntity) { [weak self] _ in
                self?.dismiss(animated: true, completion: nil)
            }
        default:
            break
        }
    }
    
    @IBAction private func nameTextFieldEdited(_ sender: Any) {
        updateProceedButton()
    }
    
    @IBAction private func nameTextFieldReturned(_ sender: Any) {
        nameTextField.resignFirstResponder()
    }
    
    @IBAction func dateTextFieldEditingBegan(_ sender: Any) {
        // Adjust the min/max on the date picker.
        let todayBirthDate = Date().birthDate
        
        datePicker.minimumDate = BirthDate(
            year: todayBirthDate.year - RemoteConfigManager.shared.remoteConfig.ageSpecs.maxAge,
            month: todayBirthDate.month,
            day: todayBirthDate.day
        ).date
        datePicker.maximumDate = Date()
    }
    
    
    @IBAction func datePickerValueChanged(_ sender: Any) {
        editingBirthDate = datePicker.date.birthDate
    }

}
