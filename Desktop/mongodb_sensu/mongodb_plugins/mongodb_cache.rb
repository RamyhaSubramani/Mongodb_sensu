#!/usr/bin/env ruby
#
#
require 'sensu-plugin/check/cli'

class CheckRead < Sensu::Plugin::Check::CLI
 
   option :warn,
          short: '-w CONNECTIONS',
          proc: proc {|a| a.to_i },
          default: 200 #MB
   option :crit,
          short: '-c CONNECTIONS',
          proc: proc {|a| a.to_i },
          default: 220
# The size limit of the WiredTiger cache defined by the engineConfig.cacheSizeGB parameter shouldn’t be increased above its default value(256MB)
def run
  cache=0

  cache_size=`mongo --eval "printjson(db.serverStatus().wiredTiger.cache["maximum bytes configured"])"`
 cache_size.each_line do |line|
 cache=line if line.match /^[0-9]*/
end

cache=cache/1024 * 1024
  message "#{cache}  MB of cache size "
     warning if cache.to_i > config[:warn]
   critical if cache.to_i > config[:crit]
  ok

 end

end
