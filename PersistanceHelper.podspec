Pod::Spec.new do |spec|
  spec.name         = "PersistanceHelper"
  spec.version      = "1.0.0"
  spec.summary      = "Efficient library for storing and managing persistent data, with seamless data type handling."
  spec.description  = <<-DESC
                       A robust and efficient data persistence library designed to simplify and streamline the process of storing, retrieving, and managing persistent data in applications. It offers a seamless interface for handling various data types and ensures data integrity and security. Ideal for applications requiring reliable data storage solutions.
                       DESC
  spec.homepage     = "https://github.com/abhishekbiswas772/PersistenceHelper"
  spec.license      = "GNU GPLv3"
  spec.author       = { "Abhishek Biswas" => "abhishekbiswas772@gmail.com" }
  spec.platform     = :ios, "15.0"
  spec.source       = { :git => "https://github.com/abhishekbiswas772/PersistenceHelper.git", :tag => spec.version.to_s }
  spec.source_files  = "Data Persistance Helper/**/*.{swift}"
  spec.framework    = "SQLite3"
  spec.requires_arc = true
  spec.swift_versions = "5.0"
end
