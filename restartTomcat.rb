# encoding: utf-8
#!/usr/bin/ruby -w

require 'open3'

def checkPID(process)
  process.each do |line|
    if line.include? "java"
    return true
    end
  end
  return false
end

def kill(process)
  process.each do |line|
    if line.include? "java"
      process_no = line.split[0]
      `kill -9 #{process_no}`
    end
  end
end

puts "tomcat shutdown"
Open3.popen3('sudo <PATH TO TOMCAT>/bin/shutdown.sh') { |stdin, stdout, stderr| stderr.read }
puts "well, shutdowned!"

sleep 1
retry_count = 0

while true
  retry_count += 1
  # check if tomcat is alive!
  tomcat = `ps ax | grep tomcat`
  process = tomcat.split(/\n/)
  if checkPID(process)
    print "."
    if retry_count < 3
      print "."
    else
      puts " try to kill.."
        kill(process)

      end
  else
    puts "completely dead"
  break
  end

end
