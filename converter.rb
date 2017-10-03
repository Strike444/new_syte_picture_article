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

class Rename_files
  require 'date'
  require 'fileutils'

  def initialize(arr_files, path)
    @arr_files = arr_files
    @path = path
    @arr_fullpath = Array.new()
  end

  def move_and_rename_files()
    @arr_files.each do |e|
      @arr_fullpath << @path + e
    end

    @d = Date.today
    @date = @d.strftime("%d_%m_%Y")

    if File::directory?(@path + "#{@date}") then
      puts "A directory with this name already exists"
    else
      Dir.mkdir(File.join(@path, "#{@date}"), 0755)
    end

    # This code is terrible. Copy and paste with renaming.
    @arr_fullpath.each do |f|
      if File.file?("#{f}") then    
        fb = File.basename(f)
        fbn = File.basename(f, ".*")
        re = (/\.(jpg|png)$/i.match "#{fb}").to_s 
        re.downcase!
        puts "#{@path}#{@date}/#{fbn}#{re}"
        FileUtils.cp f, "#{@path}#{@date}/#{fbn}#{re}"
      end
    end
  end


#   def rename_files()
#     @arr_files.each do |e|
#       @arr_fullpath << @path + e
#     end

#     i = 0
#     @arr_fullpath.each do |f|
#       if (File.file?("#{f}") and (not (/glav\.(jpg|png)/i.match "#{f}"))) then
#         fb = File.basename(f, ".*")
#         gf = f.gsub(/#{fb}/, "#{i}")

#         # theoretically we have an error if the filename matches the directory name
#         File.rename(f, gf)

#         # downcase rename
#         fbd = File.basename(f).downcase
#         File.rename(f, fbd)
#         i = i + 1
# # TODO не измениять реальные файлы а возможно копировать
#       elsif File.file?("#{f}") and (/glav\.(jpg|png)/i.match "#{f}") then
#         puts f
#         # fbd = File.basename(f).downcase
#         # File.rename(f, fbd)
#       end
#     end
#   end
end

pc = Parse_command_line.new()
pc.parse_cl
puts "Path to the directory: #{pc.path}"
dr = Dir_contents.new(pc.path)
arr_files = dr.dir_contents()
rf = Rename_files.new(arr_files, pc.path)
rf.move_and_rename_files()

