# Program for converting jpg and getting text from word formats

VERSION = '0.1.3'

$glav, $pic = false, false

class Parse_command_line 

  require 'optparse'

  def initialize() 
    @path = nil
    @version = VERSION
  end

  def path
    @path
  end

  def parse_cl()
    if ARGV.length == 0
      puts "The options not set, you can set options: -p path for path, -h for help, -v for version."
      exit
    end

    begin
      
    parser = OptionParser.new do|opts|
      opts.banner = "Usage: ruby converter.rb [options]"
      opts.on('-p', '--path path', 'Path') do |path|
        @path = path;
        loop do
          if File.directory?(@path)
            break
          else
            puts "Path is wrong or not exist, plis enter valid path:"
            @path = gets.chomp
          end
        end
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
      puts "You insert not correct key, you can set options: -p path for path, -h for help, -v for version."
      exit
    end

    rescue 
      puts "You did not correctly specify the key or forgot to specify the argument to the -p key."
      exit
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

class Date_today
  def self.date_today
    @d = Date.today
    @date = @d.strftime("%d_%m_%Y")
    return @date
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

    @date = Date_today.date_today

    if File::directory?(@path + "#{@date}") then
      puts "A directory with this name already exists."
    else
      Dir.mkdir(File.join(@path, "#{@date}"), 0755)
    end

    # This code is terrible. Copy and paste with renaming.
    @i = 0
    @arr_fullpath.each do |f|
      if File.file?("#{f}") then    
        fb = File.basename(f)
        fbn = File.basename(f, ".*")
        re = (/\.(jpg|png)$/i.match "#{fb}").to_s 
        re.downcase!
        # puts "#{@path}#{@date}/#{fbn}#{re}"
        if File.basename(f, ".*") == 'glav'
          FileUtils.cp f, "#{@path}#{@date}/#{fbn}#{re}"
          $glav = true
        elsif (/\.(jpg|png)$/i.match File.basename(f)) then
          $pic = true
          FileUtils.cp f, "#{@path}#{@date}/#{@i}#{re}"
          @i += 1
        end
      end
    end
    return @date
  end
end

class Resize_pic
  def initialize(path)
    @path = path
  end

  def resize_pic
    puts @path
    `cd #{@path} && mogrify -path #{@path} -resize 1024 *`
  end
end

class Get_text
  require 'yomu'
  def initialize(files,path)
    @files = files
    @path = path
  end

  def files_with_text
    @files.each do |f|
      if File.file?("#{@path}#{f}") then
        if /\.(doc|docx|xls|xlsx|ppt|pptx|odt|ods|odp|rtf|pdf)$/i.match "#{f}" then
          yomu = Yomu.new "#{@path}#{f}"
          text = yomu.text
          ft = Format_text.new(text, "#{@path}#{f}")
          ft.format_text          
        end
      end
    end
    # puts "#{@path}" + "#{@files}"   
  end
end

class Format_text
  def initialize(text, path)
    @text = text
    @path = path
  end

  def format_text
    @text.squeeze! 
    @text.strip!
    @text.gsub!(/^\s*/, '')
    
    # puts @text  
    @date = Date_today.date_today
    if $glav then
      @text = "<img src=\"images\/doc_admin\/glav\/#{@date}\/glav.jpg\" alt=\"\" width=\"200\" height=\"170\" style=\"margin: 5px; float: left;\" />\r\n" +
      "----------\r\n" +
      @text
    end
    if $pic then
      @text << "\r\n<p>{gallery slider=boxplus.carousel}doc_admin\/glav\/#{@date}{\/gallery}</p>"
    end
    # puts @text
    wf = Write_files.new(@text, "#{@path}.txt")
    wf.write_files
  end
end

class Write_files
  def initialize(text, path)
    @text = text
    @path = path
  end
  
  def write_files
    f = File.new(@path, 'w')
    f << @text
    f.close
  end    
end

pc = Parse_command_line.new()
pc.parse_cl
puts "Path to the directory: #{pc.path}"
dr = Dir_contents.new(pc.path)
arr_files = dr.dir_contents()
if arr_files.find_all{ |elem| /.+(jpg|png)$/i.match elem }.size != 0
  puts "Found pictures."
  rf = Rename_files.new(arr_files, pc.path)
  date = rf.move_and_rename_files()
  rp = Resize_pic.new(pc.path + date)
  rp.resize_pic()
end
gt = Get_text.new(arr_files, pc.path)
gt.files_with_text
