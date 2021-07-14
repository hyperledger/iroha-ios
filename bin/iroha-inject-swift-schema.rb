#
# Copyright 2021 Soramitsu Co., Ltd.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http:#www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

if ARGV.empty?
  puts "No `xcodeproj` lib path provided"
  exit
end

$:.unshift(ARGV[0])
require 'xcodeproj'

if ARGV[1].empty?
  puts "No .xcodeproj path provided"
  exit
end

if ARGV[2].empty?
  puts "No path for generated IrohaSwift model provided"
  exit
end

def sync_dir(project, target, path, group_path)
  file_refs = []
  group = project.main_group.find_subpath(group_path, true)
  files = Dir[path + '/*']

  files.each do |file|
    file_name = File.basename(file)
    if File.directory?(file)
      sync_dir(project, target, path + '/' + file_name, group_path + '/' + file_name)
      next
    end

    file_found = false
    group.files.each do |group_file|
      if group_file.name === file_name
        file_found = true
      end
    end

    if !file_found then
      file_ref = group.new_reference(file)
      file_refs << file_ref
    end
  end

  group.files.each do |group_file|
    file_found = false
    files.each do |file|
      file_name = File.basename(file)
      if file_name === group_file.name
        file_found = true
        break
      end
    end

    if !file_found then
      group_file.remove_from_project
    end
  end

  target.add_file_references(file_refs)
end


project_path = ARGV[1]
group_path = ARGV[2]

project = Xcodeproj::Project.open(project_path)
target = project.targets.first

project_dir_path = File.dirname(project_path)
generated_files_path = project_dir_path + '/' + group_path

sync_dir(project, target, generated_files_path, group_path)
project.save

# cleanup empty build file references (CocoaPods' Xcodeproj bug with no foreseen fix)
system("sed -i '' '/(null) in Sources /d' " + project_path + "/project.pbxproj")
system("sed -i '' '/BuildFile in Sources /d' " + project_path + "/project.pbxproj")
