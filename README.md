# swagger-swift-models-generator
Simple ruby script to generate all Swift models from swagger documentation.

Works with Swagger 2.0.

## About
This script makes it faster for you to generate all needed API Data Models included in Swagger documentation. 
Each of created models is written to separate file. Every file is including 'import Foundation', and typical Xcode header, where we can find information like who is the author, what is the project name, file name or when the file was created.
```swift
//
//  Sort.swift
//  TodoApp
//
//  Created by Jędrzej Chołuj on 27/10/2021.
//

import Foundation
```
Script creates a folder named "Models" where all results will be added. 
All models are Stucts and all properties are created as non-optional variables.
```swift
struct Sort: Codable {
    var id: Int
    var description: String
    var empty: Bool
    var sorted: Bool
}

```

## Usage
The script takes as input a simple JSON file including 4 attributes:
- Swagger JSON file name, eg. "data.json"
- Project name, eg. "TodoApp"
- Author name, eg. "Jędrzej Chołuj"
- Protocols which we would like to add to each model, eg. "Codable"

Protocols should be in form of String, where each protocol is separate same way as in Xcode - comma and whitespace.
If you will remove "protocols" key-value pair from JSON, then models are created without any protocol added.

To run script you just have to type:
```sh
ruby parse_models.rb my_arguments.json
```
Where my_arguments.json are input JSON, eg.:
```json
{
  "json_file": "data.json",
  "app_name": "TodoApp",
  "author": "Jędrzej Chołuj",
  "protocols": "Codable"
}
```
