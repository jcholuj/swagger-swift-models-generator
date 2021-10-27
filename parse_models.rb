#!/usr/bin/env ruby
list = `gem list`
json = 'json'
`gem install json` unless list.include? json
require 'json'

args = JSON.parse(ARGF.read)
json_file = args['json_file']
app_name = args['app_name']
author = args['author']
date = Time.now.strftime("%d/%m/%Y")
protocols = args['protocols']

def swap_types(type)
  right_type = case type
    when "number"
      then "Int"
    when "integer"
      then "Int"
    when "int64"
      then "Int"
    when "string"
      then "String"
    when "boolean"
      then "Bool"
    when "array"
      then ""
  end
end

def create_var(file, name, type)
  val = "\tvar " + name + ": " + type
  file.puts(val)
end

def write_var_declaration(type_value, value, out_file, key)
  if type_value == "array"
    type = '[' + value['items']['$ref'].sub('#/definitions/', '') + ']'
    create_var(out_file, key, type)
  else
    type = swap_types(type_value)
    unless type.nil?
      create_var(out_file, key, type)
    end
  end
end

def create_header(file, file_name, app_name, author, date)
  file.puts('//')
  file.puts('//  ' + file_name)
  file.puts('//  ' + app_name)
  file.puts('//')
  file.puts('//  Created by ' + author + ' on ' + date + '.')
  file.puts('//')
  file.puts("\n")
  file.puts('import Foundation')
  file.puts("\n")
end

file = File.read(json_file)
data = JSON.parse(file)
`mkdir Models`

def create_models(data, app_name, author, date, protocols)
  definitions = data['definitions']
  definitions.each { |k, v|
    next if v['properties'].nil?
      file_name = k + ".swift"
      out_file = File.new(File.join(Dir.pwd, "/Models/#{file_name}"), "w")
      create_header(out_file, file_name, app_name, author, date)
        unless protocols.nil?
          out_file.puts('struct ' + k + ': ' + protocols + ' {')
        else
          out_file.puts('struct ' + k + ' {')
        end
      v['properties'].each { |key, value|
        next if value['type'].nil?
          type_value = value['type']
          write_var_declaration(type_value, value, out_file, key)
      }
      out_file.puts('}')
      out_file.close
  }
end

create_models(data, app_name, author, date, protocols)
