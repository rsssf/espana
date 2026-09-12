####
#  to run use:
#
#    $ ruby mirrortest/test_edits.rb

require 'cocos'
require_relative '../mirror/_cocos_'



edits = read_edits( './mirror/errata.txt' )
pp edits



puts "bye"
