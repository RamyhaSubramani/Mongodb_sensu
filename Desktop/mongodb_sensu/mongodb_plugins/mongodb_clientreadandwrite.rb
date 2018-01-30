#!/usr/bin/env ruby
#
#
require 'sensu-plugin/check/cli'

class CheckRead < Sensu::Plugin::Check::CLI
 
   option :warn,
          short: '-w WARNING',
          proc: proc {|a| a.to_i },
          default: 10
   option :crit,
          short: '-c CRITICAL',
          proc: proc {|a| a.to_i },
          default: 20
# Number of clients with read and write operations in progress or queued
def run
 write,read=0

  writers=`mongo --eval "printjson( db.serverStatus().globalLock.activeClients.writers)"`
  
  writers.each_line do |line|
  write=line if line.match /^[0-9]*/
 end
 readers=`mongo --eval "printjson( db.serverStatus().globalLock.activeClients.readers)"`
  readers.each_line do |line|
  read=line if line.match /^[0-9]*/
 end

 message "#{write}  activeClient writers and  #{read}  activeClient Readers"
   warning if write.to_i > config[:warn] && read.to_i > config[:warn] 
   critical if write.to_i > config[:crit] && read.to_i > config[:crit]
  ok
 end
end
