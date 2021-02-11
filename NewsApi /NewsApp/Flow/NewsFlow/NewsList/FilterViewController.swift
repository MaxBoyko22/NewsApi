//
//  FilterViewController.swift
//  NewsApp
//
//  Created by Maximilian Boiko on 11.02.2021.
//

import UIKit

protocol FilterViewControllerDelegate {
    func didApplyFilters(_ filters: [NewsApiParameter])
}

enum FilterState: Int {
    case categories = 0
    case countries
    case sources
}

class FilterViewController: UIViewController {
    
    var delegate: FilterViewControllerDelegate?
    @IBOutlet weak var filterTypePicker: UISegmentedControl!
    @IBOutlet weak var pickerView: UIPickerView!
    
    var countries = Country.all
    var categories = Category.all
    var sources = [Source]()
    
    var selectedCountry: Country?
    var selectedCategory: Category?
    var selectedSource: Source?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get sources
        QueriesToAPI.shared.getSources(params: [],
                                       completion: { (sourceArray, Error) in
                                        if let sources = sourceArray {
                                            self.sources = sources
                                            DispatchQueue.main.async {
                                                self.pickerView.reloadAllComponents()
                                            }
                                        }
                                       })
    }
    
    @IBAction func selectorValueChanged(_ sender: UISegmentedControl) {
        pickerView.reloadAllComponents()
    }
    
    @IBAction func applyButtonPressed(_ sender: Any) {
        var parameters = [NewsApiParameter]()
        
        if let country = selectedCountry {
            parameters.append(.country(country))
        }
        
        if let category = selectedCategory {
            parameters.append(.category(category))
        }
        
        if let source = selectedSource, filterTypePicker.selectedSegmentIndex == 2 {
            parameters = [.source(source)]
        }
        
        // Do the same for source
        
        delegate?.didApplyFilters(parameters)
    }
}

extension FilterViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let selectedState = FilterState(rawValue: filterTypePicker.selectedSegmentIndex)
        
        guard let state = selectedState else {return 0}
        
        switch state {
        case .categories:
            return categories.count
        case .countries:
            return countries.count
        case .sources:
            return sources.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let state = FilterState(rawValue: filterTypePicker.selectedSegmentIndex) else {return nil}
        
        switch state {
        case .categories:
            return categories[row].rawValue
        case .countries:
            return countries[row].rawValue
        case .sources:
            return sources[row].name
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let state = FilterState(rawValue: filterTypePicker.selectedSegmentIndex) else {return}
        
        switch state {
        case .categories:
            selectedCategory = categories[row]
        case .countries:
            selectedCountry = countries[row]
        case .sources:
            selectedSource = sources[row]
        }
    }
}
