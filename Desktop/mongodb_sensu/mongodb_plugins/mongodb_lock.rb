#!/usr/bin/env ruby
#
#
require 'sensu-plugin/check/cli'

class CheckRead < Sensu::Plugin::Check::CLI
 
   option :warn,
          short: '-w CONNECTIONS',
          proc: proc {|a| a.to_i },
          default: 5 
   option :crit,
          short: '-c CONNECTIONS',
          proc: proc {|a| a.to_i },
          default: 10
#Lock Statistics, like number of operations that are queued and waiting for the read-lock or write-lock and number of active client connections to the database currently performing read/write operations.
def run
  read_lock,write_lock,total_lock=0

  stat1=` mongo --eval "printjson( db.serverStatus().globalLock.currentQueue.readers)"`
 stat1.each_line do |line|
 read_lock=line if line.match /^[0-9]*/
end
stat2=` mongo --eval "printjson( db.serverStatus().globalLock.currentQueue.writers)"`
stat2.each_line do |line|
 write_lock=line if line.match /^[0-9]*/
end
stat3=` mongo --eval "printjson( db.serverStatus().globalLock.currentQueue.total)"`
stat3.each_line do |line|
 total_lock=line if line.match /^[0-9]*/
end
 
     warning if read_lock.to_i > config[:warn] && write_lock.to_i > config[:warn] && total_lock.to_i > config[:warn]
   critical if read_lock.to_i > config[:crit] && write_lock.to_i > config[:crit] && total_lock.to_i > config[:crit] 
  ok

 end

end
