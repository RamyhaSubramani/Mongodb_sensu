#!/usr/bin/env ruby
#
#
require 'sensu-plugin/check/cli'

class CheckRead < Sensu::Plugin::Check::CLI
 
   option :warn,
          short: '-w CONNECTIONS',
          proc: proc {|a| a.to_i },
          default: 250
   option :crit,
          short: '-c CONNECTIONS',
          proc: proc {|a| a.to_i },
          default: 500
# Frequent page faults may indicate that your data set is too large for the allocated memory
def run
  page_faults=0

  extra_info=`mongo --eval "printjson(db.serverStatus().extra_info.page_faults)"`
 extra_info.each_line do |line|
 page_faults=line if line.match /^[0-9]*/
end

  message "#{page_faults}  pagefaults occured "
     warning if page_faults.to_i > config[:warn]
   critical if page_faults.to_i > config[:crit]
  ok

 end

end
