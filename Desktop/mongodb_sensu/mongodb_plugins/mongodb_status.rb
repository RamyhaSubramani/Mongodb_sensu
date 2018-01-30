#!/usr/bin/env ruby
#
#
process=`ps aux`
status=false
process.each_line do |proc|
   status=true if proc.include?('mongodb')
end
if status
 puts 'mongodb running'
 exit 0
else
 warning
exit 1
end
