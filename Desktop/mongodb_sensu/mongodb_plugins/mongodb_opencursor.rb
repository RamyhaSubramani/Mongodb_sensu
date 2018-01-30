#!/usr/bin/env ruby
#
#
require 'sensu-plugin/check/cli'

class CheckRead < Sensu::Plugin::Check::CLI
 
   option :warn,
          short: '-w CURSOR WARNING',
          proc: proc {|a| a.to_i },
          default: 60 
   option :crit,
          short: '-c CURSOR CRITICAL',
          proc: proc {|a| a.to_i },
          default: 80 
#A gradual increase in the number of open cursors without a corresponding growth of traffic is often symptomatic of poorly indexed queries

def run

 open_cursor=0

  total=`mongo --eval "printjson(db.serverStatus().metrics.cursor.open.total)"`
   total.each_line do |tot|
    open_cursor=tot if  tot.match /[0-9]*\)$/

   end

   message "#{open_cursor} open cursors  obtained"
   warning if open_cursor.to_i >  config[:warn]
   critical if  open_cursor.to_i > config[:crit]
  ok

 end

end
