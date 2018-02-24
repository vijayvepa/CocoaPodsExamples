# Creating Pod Libraries

- make sure cocoa pods is installed
```
brew install cocoapods
```

## Creating the Pod
Create libraries using this command:
```
pod lib create Fadeable
```
- ObjectiveC or Swift? swift
- Create Demo Application? yes
- Add automated test framework? quick
- Add view-based test framework? no

Since it is part of an existing git repo, delete the `.git` folder in the subfolder.  

## Adding the Code

- Open `Fadeable\Example\Fadeable.xcworkspace` in XCode
- Expand the `Pods` project, `Development Pods` folder, `Fadeable`->`Pods`->`Classes` folder

![AddingCode]

- Change code in `ReplaceMe.swift`

[AddingCode]:images/AddingCode.png

## Changing Pod Metadata

- Under `Fadeable` project -> `Podspec Metadata` -> open `Fadeable.podspec`
- It is a ruby script. XCode provides syntax highlighting. Click on the file-> On the right side, choose `Identity` pane and Select `Type` as `Ruby Script`.

![PodSpecSyntax]

[PodSpecSyntax]:images/PodSpecSyntax.png

## Changing Usage Code

To change the example code that uses this pod library
- Under `Fadeable` project -> `Example for Fadeable` folder, modify the code.

![ExampleCode]

[ExampleCode]:images/ExampleCode.png

