
###
#  to run use:
#
#   $ ruby mirror/query_enc.rb


require_relative 'mirror'


MirrorDb.open


puts " #{MirrorDb::Model::Page.count} page(s) " +
         "(#{MirrorDb::Model::Page.cached.count} cached, " +
         "#{MirrorDb::Model::Page.not_cached.count} missing)"

puts "  #{MirrorDb::Model::Link.count} links(s)"



puts "==> encoding not default:"
MirrorDb::Model::Page.order( 'path' ).where( 'encoding != ?', 'windows-1252' ).each do |page|
   dump_page( page )
end



puts "bye"
