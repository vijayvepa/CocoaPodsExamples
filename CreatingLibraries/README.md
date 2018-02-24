# 1. Creating Pod Libraries

- make sure cocoa pods is installed
```
brew install cocoapods
```

<!-- TOC -->

- [1. Creating Pod Libraries](#1-creating-pod-libraries)
	- [1.1. Creating the Pod](#11-creating-the-pod)
	- [1.2. Adding the Code](#12-adding-the-code)
		- [1.2.1. Swift 4 Compiler Issues](#121-swift-4-compiler-issues)
			- [1.2.1.1. Issue 1: NSTimeInterval is now TimeInterval](#1211-issue-1-nstimeinterval-is-now-timeinterval)
			- [1.2.1.2. Issue 2: Passing non-escaping parameter 'completion' to function expecting an @escaping](#1212-issue-2-passing-non-escaping-parameter-completion-to-function-expecting-an-escaping)
			- [1.2.1.3. Issue 3: Type 'UIView' does not conform to protocol 'Fadeable'](#1213-issue-3-type-uiview-does-not-conform-to-protocol-fadeable)
		- [1.2.2. Issue 4: Closure cannot implicitly capture a mutating self parameter](#122-issue-4-closure-cannot-implicitly-capture-a-mutating-self-parameter)
				- [1.2.2.0.1. Option 1: Class-Type Protocol](#12201-option-1-class-type-protocol)
				- [1.2.2.0.2. Option 2: Generic Protocol](#12202-option-2-generic-protocol)
	- [1.3. Changing Pod Metadata](#13-changing-pod-metadata)
	- [1.4. Changing Usage Code](#14-changing-usage-code)
		- [1.4.1. Setup ViewController](#141-setup-viewcontroller)
		- [1.4.2. Add the view](#142-add-the-view)
		- [1.4.3. Wire up the View](#143-wire-up-the-view)

<!-- /TOC -->


## 1.1. Creating the Pod
Create libraries using this command:
```
pod lib create Fadeable
```
- ObjectiveC or Swift? swift
- Create Demo Application? yes
- Add automated test framework? quick
- Add view-based test framework? no

Since it is part of an existing git repo, delete the `.git` folder in the subfolder.  

## 1.2. Adding the Code

- Open `Fadeable\Example\Fadeable.xcworkspace` in XCode
- Expand the `Pods` project, `Development Pods` folder, `Fadeable`->`Pods`->`Classes` folder

![AddingCode]

- Change code in `ReplaceMe.swift`

[AddingCode]:Images/AddingCode.png

Add code that fadesIn or fadesOut a view. 
Below is the code that adds a fade behavior to any UIView.


- Add a protocol with an `alpha` property and `fadeIn` and `fadeOut` behavior.
```swift
import UIKit

public protocol Fadeable {
	var alpha: CGFloat {get set}
	
	mutating func fadeIn(duration: NSTimeInterval, delay: NSTimeInterval, completion: (Bool) -> Void)
	mutating func fadeOut(duration: NSTimeInterval, delay: NSTimeInterval, completion: (Bool) -> Void)
}

```
- Add a default behavior for the protocol (extension)

```swift
public extension Fadeable {
	public mutating func fadeIn (duration: NSTimeInterval = 1.0,
								delay: NSTimeInterval = 0.0,
								completion: ((Bool)->Void) = {(finished: Bool)->Void in}){
		
		UIView.animate(
			withDuration: duration,
			delay: delay,
			options: UIViewAnimationOptions.curveEaseOut,
			animations:  {
				self.alpha = 1.0;
			},
			completion: completion)
	}
	
	public mutating func fadeOut (duration: NSTimeInterval = 1.0,
								delay: NSTimeInterval = 0.0,
								completion: ((Bool)->Void) = {(finished: Bool)->Void in}){
		UIView.animate(
			withDuration: duration,
			delay: delay,
			options: UIViewAnimationOptions.curveEaseOut,
			animations:  {
				self.alpha = 0.0;
		},
			completion: completion)
	}
}
```

- Add Fadeable behavior to `UIView` by "extending" it
```swift
extension UIView : Fadeable {

}
```

### 1.2.1. Swift 4 Compiler Issues

#### 1.2.1.1. Issue 1: NSTimeInterval is now TimeInterval
We can fix this issue by using the `Fix It` button. 
Just replace `NSTimeInterval` with `TimeInterval`

#### 1.2.1.2. Issue 2: Passing non-escaping parameter 'completion' to function expecting an @escaping 
We can fix this issue by using the `Fix It` button as well. It will add an `@escaping` attribute to the `completion` delegate in the `extension`.

```swift
public extension Fadeable {
    public mutating func fadeIn (...
                                 completion: @escaping ((Bool)->Void)...
        
```
#### 1.2.1.3. Issue 3: Type 'UIView' does not conform to protocol 'Fadeable'
This occurs if we did not update the `protocol` with `@escaping` attribute fix. (XCode won't update it.)

```swift
public protocol Fadeable {
    var alpha: CGFloat {get set}
    
    mutating func fadeIn(duration: TimeInterval, delay: TimeInterval, completion: @escaping (Bool) -> Void)
    mutating func fadeOut(duration: TimeInterval, delay: TimeInterval, completion: @escaping (Bool) -> Void)
}


```
 
### 1.2.2. Issue 4: Closure cannot implicitly capture a mutating self parameter

I had to struggle for 3 hours with this issue. The answers at https://stackoverflow.com/questions/41940994/closure-cannot-implicitly-capture-a-mutating-self-parameter/41941810#_=_ did not make sense to me as I am new to swift. Finally figured out the solutions.

##### 1.2.2.0.1. Option 1: Class-Type Protocol
We can constrain the protocol to `class` type members by adding a `: class` to the `protocol` declaration.

```swift
import UIKit

public protocol Fadeable : class{
    var alpha: CGFloat {get set}
    
    func fadeIn(duration: TimeInterval, delay: TimeInterval, completion: @escaping (Bool) -> Void)
    func fadeOut(duration: TimeInterval, delay: TimeInterval, completion: @escaping (Bool) -> Void)
}

```


##### 1.2.2.0.2. Option 2: Generic Protocol

Similar to javascript `this` fixes, we can capture the `self` parameter in a `_self` var. But It has to be done in outer scope. This "worked" but I am not sure if it is the right solution. If it is indeed okay, then it is more generic solution, as `Fadeable` can now be used on `struct`s as well.

```swift
public extension Fadeable {
	public mutating func fadeIn (duration: TimeInterval = 1.0,
								delay: TimeInterval = 0.0,
								completion: @escaping ((Bool)->Void) = {(finished: Bool)->Void in}){
		//--------Capture Self outside
		var _self = self;  //<--------
		//-------------
		UIView.animate(
			withDuration: duration,
			delay: delay,
			options: UIViewAnimationOptions.curveEaseOut,
			animations:  {
				_self.alpha = 1.0;
			},
			completion: completion)
	}

```

## 1.3. Changing Pod Metadata

- Under `Fadeable` project -> `Podspec Metadata` -> open `Fadeable.podspec`
- It is a ruby script. XCode provides syntax highlighting. Click on the file-> On the right side, choose `Identity` pane and Select `Type` as `Ruby Script`.

![PodSpecSyntax]

[PodSpecSyntax]:Images/PodSpecSyntax.png


## 1.4. Changing Usage Code

To change the example code that uses this pod library
- Under `Fadeable` project -> `Example for Fadeable` folder, modify the code.

![ExampleCode]

[ExampleCode]:Images/ExampleCode.png

### 1.4.1. Setup ViewController

In the example code in `ViewController.swift`, we will consume the `Fadeable` framework, use to to fade out or fade in a `UIView` object on a view.

- Add an `@IBOutlet` for a `UIView` object

```swift
	@IBOutlet weak var box : UIView!
```
NOTE: The `!` at the end indicates that this object will be "unboxed" when accessing. i.e., if the object is not set, we want the runtime to throw an error.

- Add an `@IBAction` behavior when a button is tapped.

```swift
    @IBAction func fadeToggleTapped(sender: UIButton){
        if(box.alpha == 0){
            box.fadeIn()
        }else{
            box.fadeOut()
        }
    }
```
- Import our framework module so that `box` object has the `fadeIn` method available.

```swift
import Fadeable
``` 
### 1.4.2. Add the view

- Go to `Main.storyboard` 
- Drag and drop a `UIView` and a `Button` onto the layout.

![SetupView]

[SetupView]:Images/SetupView.png


### 1.4.3. Wire up the View

- Open the `Main.storyboard` file.
- `[OPTION-Click]` (or `Alt-Click` if using windows keyboard on mac mini)  `ViewController.swift` so that both files are opened side-by-side.
- Click on the `circle` next to `@IBOutlet` code and drag it on to the `UIView` control on the storyboard. This will allow the view control to be associated with this variable.

![IBOutletCircle]

[IBOutletCircle]:Images/IBOutletCircle.png
- Click on the `circle` next to `@IBAction` code and drag it onto the `Button` control on the storyboard. This will associate the tap of the button control to this code.

