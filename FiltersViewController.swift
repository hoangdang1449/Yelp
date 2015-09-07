//
//  FiltersViewController.swift
//  Yelp
//
//  Created by Hoang Dang on 9/5/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol FiltersViewControllerDelegate {
    optional func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: [String:AnyObject])
}

class FiltersViewController: UIViewController,UITableViewDataSource, UITableViewDelegate, SwitchCellDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    
    weak var delegate: FiltersViewControllerDelegate?
    var categories: [[String:String]]!
    var switchStates = [Int:Bool]()
    var filters = [String : AnyObject]()
    var radiusValue: [Float?]!

    override func viewDidLoad() {
        super.viewDidLoad()
        categories = yelpCategories()
        tableView.delegate = self
        tableView.dataSource = self
        radiusValue = [nil, 0.5, 1, 3, 10]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCancelButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func onSearchButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
        var filters = [String : AnyObject]()
        var selectedCategories = [String]()
        for (row,isSelected) in switchStates {
            if isSelected {
                selectedCategories.append(categories[row]["code"]!)
            }
        }
        if selectedCategories.count > 0 {
            filters["categories"] = selectedCategories
        }
        delegate?.filtersViewController?(self, didUpdateFilters: filters)
    }
    
    // Define section in table
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 2
        case 2:
            return 3
        case 3:
            return categories.count + 1
        default:
            break
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            //Deal Section
            let cell = tableView.dequeueReusableCellWithIdentifier("SwitchCell", forIndexPath: indexPath) as! SwitchCell
            cell.switchLable.text = "Offering a Deal"
            cell.delegate = self
            cell.onSwitch.on = filters["deal"] as? Bool ?? false
            return cell
            
        case 1:
            //Radius Section
            let cell = tableView.dequeueReusableCellWithIdentifier("SwitchCell", forIndexPath: indexPath) as! SwitchCell
            cell.delegate = self
            if indexPath.row == 0 {
                cell.switchLable.text = "Auto"
            } else {
                if radiusValue[indexPath.row] == 1 {
                    cell.switchLable.text =  String(format: "%g", radiusValue[indexPath.row]!) + " mile"
                } else {
                    cell.switchLable.text =  String(format: "%g", radiusValue[indexPath.row]!) + " miles"
                }
            }
            return cell
            
        case 2:
            //Sort section
            let cell = tableView.dequeueReusableCellWithIdentifier("SwitchCell", forIndexPath: indexPath) as! SwitchCell
            cell.delegate = self
            switch indexPath.row {
            case 0:
                cell.switchLable.text = "Best Match"
                break
            case 1:
                cell.switchLable.text = "Distance"
                break
            case 2:
                cell.switchLable.text = "Rating"
                break
            default:
                break
            }
            return cell

            case 3:
                //Countries section
                let cell = tableView.dequeueReusableCellWithIdentifier("SwitchCell", forIndexPath: indexPath) as! SwitchCell
                    cell.switchLable.text = categories[indexPath.row]["name"]
                    cell.delegate = self
                    cell.onSwitch.on = switchStates[indexPath.row] ?? false
                    return cell
            
        default:
            let cell = UITableViewCell()
            return cell
        }
    }

    func switchCell(switchCell: SwitchCell, didChangeValue value: Bool) {
        let indexPath = tableView.indexPathForCell(switchCell)!
        switchStates[indexPath.row] = value
    }
    
    func yelpCategories() -> [[String:String]] {
        return [["name": "Afghan", "code": "afghani"],
        ["name": "African", "code": "african"],
        ["name": "American (New)", "code": "newamerican"],
        ["name": "American (Traditional)", "code": "tradamerican"],
        ["name": "Arabian", "code": "arabian"],
        ["name": "Argentine", "code": "argentine"],
        ["name": "Armenian", "code": "armenian"],
        ["name": "Asian Fusion", "code": "asianfusion"],
        ["name": "Australian", "code": "australian"],
        ["name": "Austrian", "code": "austrian"],
        ["name": "Bangladeshi", "code": "bangladeshi"],
        ["name": "Barbeque", "code": "bbq"],
        ["name": "Basque", "code": "basque"],
        ["name": "Belgian", "code": "belgian"],
        ["name": "Brasseries", "code": "brasseries"],
        ["name": "Brazilian", "code": "brazilian"],
        ["name": "Breakfast & Brunch", "code": "breakfast_brunch"],
        ["name": "British", "code": "british"],
        ["name": "Buffets", "code": "buffets"],
        ["name": "Burgers", "code": "burgers"],
        ["name": "Burmese", "code": "burmese"],
        ["name": "Cafes", "code": "cafes"],
        ["name": "Cafeteria", "code": "cafeteria"],
        ["name": "Cajun/Creole", "code": "cajun"],
        ["name": "Cambodian", "code": "cambodian"],
        ["name": "Caribbean", "code": "caribbean"],
        ["name": "Catalan", "code": "catalan"],
        ["name": "Cheesesteaks", "code": "cheesesteaks"],
        ["name": "Chicken Wings", "code": "chicken_wings"],
        ["name": "Chinese", "code": "chinese"],
        ["name": "Comfort Food", "code": "comfortfood"],
        ["name": "Creperies", "code": "creperies"],
        ["name": "Cuban", "code": "cuban"],
        ["name": "Czech", "code": "czech"],
        ["name": "Delis", "code": "delis"],
        ["name": "Diners", "code": "diners"],
        ["name": "Ethiopian", "code": "ethiopian"],
        ["name": "Fast Food", "code": "hotdogs"],
        ["name": "Filipino", "code": "filipino"],
        ["name": "Fish & Chips", "code": "fishnchips"],
        ["name": "Fondue", "code": "fondue"],
        ["name": "Food Court", "code": "food_court"],
        ["name": "Food Stands", "code": "foodstands"],
        ["name": "French", "code": "french"],
        ["name": "Gastropubs", "code": "gastropubs"],
        ["name": "German", "code": "german"],
        ["name": "Gluten-Free", "code": "gluten_free"],
        ["name": "Greek", "code": "greek"],
        ["name": "Halal", "code": "halal"],
        ["name": "Hawaiian", "code": "hawaiian"],
        ["name": "Himalayan/Nepalese", "code": "himalayan"],
        ["name": "Hot Dogs", "code": "hotdog"],
        ["name": "Hot Pot", "code": "hotpot"],
        ["name": "Hungarian", "code": "hungarian"],
        ["name": "Iberian", "code": "iberian"],
        ["name": "Indian", "code": "indpak"],
        ["name": "Indonesian", "code": "indonesian"],
        ["name": "Irish", "code": "irish"],
        ["name": "Italian", "code": "italian"],
        ["name": "Japanese", "code": "japanese"],
        ["name": "Korean", "code": "korean"],
        ["name": "Kosher", "code": "kosher"],
        ["name": "Laotian", "code": "laotian"],
        ["name": "Latin American", "code": "latin"],
        ["name": "Live/Raw Food", "code": "raw_food"],
        ["name": "Malaysian", "code": "malaysian"],
        ["name": "Mediterranean", "code": "mediterranean"],
        ["name": "Mexican", "code": "mexican"],
        ["name": "Middle Eastern", "code": "mideastern"],
        ["name": "Modern European", "code": "modern_european"],
        ["name": "Mongolian", "code": "mongolian"],
        ["name": "Moroccan", "code": "moroccan"],
        ["name": "Pakistani", "code": "pakistani"],
        ["name": "Persian/Iranian", "code": "persian"],
        ["name": "Peruvian", "code": "peruvian"],
        ["name": "Pizza", "code": "pizza"],
        ["name": "Polish", "code": "polish"],
        ["name": "Portuguese", "code": "portuguese"],
        ["name": "Russian", "code": "russian"],
        ["name": "Salad", "code": "salad"],
        ["name": "Sandwiches", "code": "sandwiches"],
        ["name": "Scandinavian", "code": "scandinavian"],
        ["name": "Scottish", "code": "scottish"],
        ["name": "Seafood", "code": "seafood"],
        ["name": "Singaporean", "code": "singaporean"],
        ["name": "Slovakian", "code": "slovakian"],
        ["name": "Soul Food", "code": "soulfood"],
        ["name": "Soup", "code": "soup"],
        ["name": "Southern", "code": "southern"],
        ["name": "Spanish", "code": "spanish"],
        ["name": "Steakhouses", "code": "steak"],
        ["name": "Sushi Bars", "code": "sushi"],
        ["name": "Taiwanese", "code": "taiwanese"],
        ["name": "Tapas Bars", "code": "tapas"],
        ["name": "Tapas/Small Plates", "code": "tapasmallplates"],
        ["name": "Tex-Mex", "code": "tex-mex"],
        ["name": "Thai", "code": "thai"],
        ["name": "Turkish", "code": "turkish"],
        ["name": "Ukrainian", "code": "ukrainian"],
        ["name": "Uzbek", "code": "uzbek"],
        ["name": "Vegan", "code": "vegan"],
        ["name": "Vegetarian", "code": "vegetarian"],
        ["name": "Vietnamese", "code": "vietnamese"]]
    }
}
