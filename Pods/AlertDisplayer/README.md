# AlertDisplayer

[![CI Status](https://img.shields.io/travis/JCTec/AlertDisplayer.svg?style=flat)](https://travis-ci.org/JCTec/AlertDisplayer)
[![Version](https://img.shields.io/cocoapods/v/AlertDisplayer.svg?style=flat)](https://cocoapods.org/pods/AlertDisplayer)
[![License](https://img.shields.io/cocoapods/l/AlertDisplayer.svg?style=flat)](https://cocoapods.org/pods/AlertDisplayer)
[![Platform](https://img.shields.io/cocoapods/p/AlertDisplayer.svg?style=flat)](https://cocoapods.org/pods/AlertDisplayer)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

This library runs by itself, it was created to replace the old and not stylish UIAlertView.

## Installation

AlertDisplayer is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'AlertDisplayer'
```

After installing AlertDisplayer you need to configurate a ViewController that has clear color in background, a view with top:0, bottom:0, leading:0, trailing:0 constraints relative to margins and a UIColor (light gray or black) with an alpha to create the dark (but still transparent) background. 
Then you add the view that inherits from AlertDisplayer and reference it in the VC and configure in the viewDidLoad like this:

```swift

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .clear
        self.alertDisplayer.configureWith(self, 350, 250)

        // Do any additional setup after loading the view.
    }

```

And to configure it you also need to implement the Delegate:

```swift
extension ViewController: AlertDisplayerDelegate{
    
    func setUpButtons() {
        self.alertDisplayer.setUpButtons("Aceptar")
    }
    
    //Optional Method to set UIImage
    /*func setExitImage() -> UIImage? {
        return nil
    }*/
    
    func setFont(to label: UILabel) {
        label.font = UIFont.systemFont(ofSize: 15)
    }
    
    func setBoldFont(to label: UILabel) {
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
    }
    
    func alertDisplayerDidLoad() {
        //Aditional Setup
        
        self.alertDisplayer.normalLabel.text = text
        self.alertDisplayer.boldLabel.text = titleText
        
        if(self.rightText != nil){
            self.alertDisplayer.setUpButtons(self.leftText, self.rightText)
        }else{
            self.alertDisplayer.setUpButtons(self.leftText)
        }
    }
    
    func didPressOk() {
        print("didPressOkDelegate")
        self.dismiss(animated: true, completion: nil)
    }
    
    func didPressCancel() {
        print("didPressCancelDelegate")
        self.dismiss(animated: true, completion: nil)
    }   
}
```

## Author

JCTec, jc_estevezr@hotmail.com

## License

AlertDisplayer is available under the MIT license. See the LICENSE file for more info.
