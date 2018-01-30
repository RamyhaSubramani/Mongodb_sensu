#!/usr/bin/env ruby
#
#
require 'sensu-plugin/check/cli'

class CheckRead < Sensu::Plugin::Check::CLI
 
   option :warn,
          short: '-w CONNECTIONS',
          proc: proc {|a| a.to_i },
          default: 50000
   option :crit,
          short: '-c CONNECTIONS',
          proc: proc {|a| a.to_i },
          default: 60000
# Number of clients currently connected to the mongodb server
def run

connection=0
  conn=`mongo --eval "printjson(db.serverStatus().connections.current)"`

conn.each_line do |line|
  connection=line if line.match /^[0-9]*/
 end

  message "#{connection}  connections established "
     warning if connection.to_i > config[:warn]
   critical if connection.to_i > config[:crit]
  ok
 end
end
