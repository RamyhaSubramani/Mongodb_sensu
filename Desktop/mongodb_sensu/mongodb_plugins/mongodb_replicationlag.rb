#!/usr/bin/env ruby
#
#
require 'sensu-plugin/check/cli'

class CheckRead < Sensu::Plugin::Check::CLI
 
   option :warn,
          short: '-w WARNING',
          proc: proc {|a| a.to_i },
          default: 60 
   option :crit,
          short: '-c CRITICAL',
          proc: proc {|a| a.to_i },
          default: 240 
 #Replication Lag: delay between a write operation on the primary and its copy to a secondary (milliseconds) 
def run
writeop,readop=0
 writelag=`mongo --eval "printjson(replSetGetStatus.members.optimeDate[primary])"`

writelag.each_line do |line|
 writeop=line if line.match /^[0-9]*/
end
 readop=`mongo --eval "printjson(replSetGetStatus.members.optimeDate[Secondary member])"`

readlag.each_line do |line|
 readop=line if line.match /^[0-9]*/
end
  repllag=writeop.to_i-readop.to_i

  message "#{repllag} Replication Lag"
   warning if repllag > config[:warn] 
   critical if repllag > config[:crit] 
   ok
 end
end
