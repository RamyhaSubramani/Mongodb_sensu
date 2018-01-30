#!/usr/bin/env ruby
#
#
require 'sensu-plugin/check/cli'

class CheckRead < Sensu::Plugin::Check::CLI
 
   option :warn,
          short: '-w WORKSET',
          proc: proc {|a| a.to_i },
          default:50 #percent
   option :crit,
          short: '-c CRIT',
          proc: proc {|a| a.to_i },
          default: 80
#Storage size metrics (from dbStats) for WiredTiger

def run

d,c,sum,tot=0

 memtotal=`grep MemTotal /proc/meminfo`
  x=memtotal.split(" ")
   ramsize=x[1].to_i
    datasize=`mongo --eval "printjson(db.stats().dataSize)"`
    indexsize=`mongo --eval "printjson(db.stats().indexSize)"`
   datasize.each_line do |line|
  d=line if line.match /^[0-9]*/
 end
  indexsize.each_line do |line|
  c=line if line.match /^[0-9]*/
 end
   sum=d.to_i + c.to_i
     tot=(sum/ramsize)*100

  unknown "invalid percentage" if config[:crit] > 100 or config[:warn] > 100

      message "#{tot}%  storage used "
     warning if tot.to_i > config[:warn]
   critical if tot.to_i > config[:crit]
  ok
 end
end
