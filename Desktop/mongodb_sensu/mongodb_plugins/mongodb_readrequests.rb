#!/usr/bin/env ruby
#
#
require 'sensu-plugin/check/cli'

class CheckRead < Sensu::Plugin::Check::CLI

   option :warn,
          short: '-w READ QUERY PER SECOND',
          proc: proc {|a| a.to_i },
          default: 5
   option :crit,
          short: '-c READ QUERY PER SECOND',
          proc: proc {|a| a.to_i },
          default: 10
#Number of read requests received during the selected time period
  def run
    readps=0
  samp =`mongo --eval "printjson(db.serverStatus().opcounters.query)"`
  samp.each_line do |h|
  readps=h.to_i if h.match /[0-9]*/
     end
    critical if readps > config[:crit]
    warning if readps > config[:warn]
    ok
  end
end
