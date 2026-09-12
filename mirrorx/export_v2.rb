###
#  to run use:
#
#   $ ruby mirrorx/export_v2.rb


##
##  note - output  html.csv index datasets/files per directory !!!


require_relative 'helper'


MirrorDb.open( './mirror2.db')


puts " #{MirrorDb::Model::Page.count} page(s) " +
         "(#{MirrorDb::Model::Page.cached.count} cached, " +
         "#{MirrorDb::Model::Page.not_cached.count} missing)"

puts "  #{MirrorDb::Model::Link.count} links(s)"




def build
  rows_html     = {}   ## note - html pages per directory  !!!

  ## keep rest all-in-one
  rows_html_404 = []
  rows_pdf      = []
  rows_other    = []


  ## note - use COLLATE NOCASE ASC - for case-insensitive ordering
  MirrorDb::Model::Page.order( 'dirname COLLATE NOCASE ASC',
                               'extname COLLATE NOCASE ASC',
                               'basename COLLATE NOCASE ASC' ).each_with_index do |page,i|

      ## note - for now only .html/.htm pages can be 404
      if page.http_status == 404
          rows_html_404 << [page.path,
                             "-/#{page.backlink_pages.count}",
                             '']
      elsif page.extname == '.html' || page.extname == '.htm'
          rows_dir  = rows_html[ page.dirname] ||= []
          rows_dir <<  [page.path,
                           "#{page.linked_pages.count}/#{page.backlink_pages.count}",
                           page.title ? page.title : '-'
                       ]
      elsif page.extname == '.pdf'
          rows_pdf << [page.path,
                             "-/#{page.backlink_pages.count}",
                             '']
      else  ## add (rest) to other
          rows_other << [page.path,
                             "-/#{page.backlink_pages.count}",
                             '']
      end

      print "." if i % 100 == 0
  end
  print "\n"

  [rows_html, rows_html_404, rows_pdf, rows_other]
end




rows_html, rows_html_404, rows_pdf, rows_other = build()



headers = ['path', 'links', 'title' ]



outdir = './tmp-mirror'
## outdir = '/sports/rsssf/mirror/pages'

write_csv( "#{outdir}/pages_404.csv", rows_html_404,      headers: headers )
write_csv( "#{outdir}/pages_pdf.csv",      rows_pdf,      headers: headers )
write_csv( "#{outdir}/pages_other.csv",    rows_other,    headers: headers )

## write_csv( "#{outdir}/pages_html.csv",     rows_html,     headers: headers )
rows_html.each do |dirname, rows|
    outpath =  File.join( outdir+dirname, "pages.csv" )
    write_csv( outpath, rows, headers: headers )
end


puts "bye"
