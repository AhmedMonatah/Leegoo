require 'xcodeproj'
project_path = 'Leegoo.xcodeproj'
project = Xcodeproj::Project.open(project_path)
target = project.targets.first
group = project.main_group.find_subpath(File.join('Leegoo', 'Core', 'Utils'), true)
file_ref = group.new_file('GenericLoadingView.swift')
target.source_build_phase.add_file_reference(file_ref)
project.save
