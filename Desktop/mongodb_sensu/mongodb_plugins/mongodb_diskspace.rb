#!/usr/bin/env ruby
#
#
require 'sensu-plugin/check/cli'

class CheckRead < Sensu::Plugin::Check::CLI
  
   option :warn,
          short: '-w WARNING',
          proc: proc {|a| a.to_i },
          default: 80 #percent
   option :crit,
          short: '-c CRITICAL',
          proc: proc {|a| a.to_i },
          default: 90
# The storageSize metric is equal to the size (in bytes) of all the data extents in the database
#The dataSize metric is the sum of the the sizes (in bytes) of all the documents and padding stored in the database

def run

 space,storage,data=0
  storage=`mongo --eval "printjson( db.stats().storageSize)"`

storage_size.each_line do |line|
  storage=line if line.match /^[0-9]*/
 end

  data=`mongo --eval "printjson( db.stats().dataSize)"`

data_size.each_line do |line|
  data=line if line.match /^[0-9]*/
 end

if storage == 0
raise 'Divide by Zero Error'
exit 0
else
  space=(data.to_i/storage.to_i) * 100
end
rescue
puts "Divide By Zero Error"

 unknown "invalid percentage" if config[:crit] > 100 or config[:warn] > 100

 message "#{space} disk space utilized"
    warning if space >= config[:warn] 
   critical if space >= config[:crit] 
  ok
 end
end
