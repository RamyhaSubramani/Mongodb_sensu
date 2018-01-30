#!/usr/bin/env ruby
#
#
require 'sensu-plugin/check/cli'

class CheckRead < Sensu::Plugin::Check::CLI
 
   option :warn,
          short: '-w CONNECTIONS',
          proc: proc {|a| a.to_i },
          default: 60 #seconds
   option :crit,
          short: '-c CONNECTIONS',
          proc: proc {|a| a.to_i },
          default: 80
# Mongostat  reports real-time statistics about connections, inserts, queries, updates, deletes.
# This stat shows how often mongod is flushing data to disk
def run
  sec=0

  stat=`mongostat --rowcount 1`
 flush=stat.split("\n")
 count=flush[1].split(" ")
 sec=count[8]

  message "#{sec}  seconds data flushed into disk "
     warning if sec.to_i > config[:warn]
   critical if sec.to_i > config[:crit]
  ok

 end

end
