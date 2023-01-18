require "csv"
require "yaml"

file = File.read("#{__dir__}/instances.csv")
table = CSV.parse(file, headers: true)

options = []

sorted = table.sort_by{|entry|
  memory = entry["Memory"].split(" ").first.to_f
  cpus = entry["vCPUs"].split(" ").first.to_f
  [memory, cpus]
}

$slow_instance_classes = ['t2', 't3', 'm3']
$warm_instances_classes = ['ultrawarm1']

sorted.each do |entry|

  name = entry["Name"]
  cpus = entry["vCPUs"]
  memory = entry["Memory"]
  storage = entry["Storage"]

  instance_class = entry["API Name"].split(".").first
  next if $slow_instance_classes.include?(instance_class)
  next if $warm_instances_classes.include?(instance_class)

  # TODO: remove EBS Only exclusion
  next if storage == "EBS Only"

  options << {
    "title" => "#{name} (#{cpus}, #{memory} RAM)",
    "const" => entry["API Name"] # instance name
  }
end

puts options.to_yaml({:line_width => -1})
