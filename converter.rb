# Program for converting jpg and getting text from word formats

VERSION = '0.0.1'

class Parse_command_line 

  require 'optparse'

  def initialize() 
    @path = ''
    @version = VERSION
  end

  def path
    @path
  end

  def parse_cl()
    parser = OptionParser.new do|opts|
      opts.banner = "Usage: ruby converter.rb [options]"
      opts.on('-p', '--path path', 'Path') do |path|
        @path = path;
      end
      opts.on('-h', '--help', 'Displays Help') do
        puts opts
        exit
      end
      opts.on('-v', '--version', 'Displays Version') do
        puts "Current version is " + @version
        exit
      end
    end

    parser.parse!

    if @path == nil
      print 'Enter path to dir with files: '
      @path = gets.chomp
    end

    loop do
      if File.directory?(@path)
        break
      else
        puts "Path is wrong or not exist, plis enter valid path:"
        @path = gets.chomp
      end
    end
  end
end

class Dir_contents

  def initialize(path)
    @path = path
  end

  def path
    @path
  end

  def dir_contents()
    dir_c = Array.new
    dir = Dir.open("#{@path}")
    dir.each {|e| dir_c << e}
    return dir_c
  end
end

pc = Parse_command_line.new()
pc.parse_cl
puts "Путь к каталогу: #{pc.path}"
dr = Dir_contents.new(pc.path)
puts dr.dir_contents()

    # @i = 0
    # dir.each do |file| 
    #   if File.file?(@path + file) then
    #     puts file
    #     old_name = File.basename(file,'.*')
    #     # if old_name.include?(search)
    #     # File.rename( file, new_path )
    #     # new_name = File.basename(file).gsub(target,replace)
    #     # puts "Renamed #{file} to #{new_name}" if $DEBUG
    #     puts old_name
    #     new_name = file.gsub(File.basename(file,'.*'),@i)
    #     @i++
    #     puts new_name
    #   end
