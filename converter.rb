require 'optparse'

options = {:path => nil}

parser = OptionParser.new do|opts|
  opts.banner = "Usage: ruby converter.rb [options]"
  opts.on('-p', '--path path', 'Path') do |path|
    options[:path] = path;
  end

  opts.on('-h', '--help', 'Displays Help') do
    puts opts
    exit
  end
end

parser.parse!

if options[:path] == nil
  print 'Enter path to dir with files: '
  options[:path] = gets.chomp
end

loop do
  if File.directory?(options[:path])
    break
  else
    puts "Path is wrong or not exist, plis enter valid path:"
    options[:path] = gets.chomp
  end
end

puts options[:path]
    

