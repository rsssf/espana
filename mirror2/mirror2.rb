####
#
#   experiment with mirror/mirror BUT use
#      ./mirror2.db for local storage and
#      ./cache2 for download cache
#
#  to run use:
#
#    $ ruby mirror2/mirror2.rb



require_relative 'helper'



Webcache.root = './cache2'
Webget.config.delay_in_s = 1




##
##  todo/check - use errata_html.txt - why? why not?
##
ERRATA_EDITS = read_edits( './mirror/errata.txt' )

##
##  defaults to windows-1252  if
###  lookup by path e.g. /curtour.html
PAGE_ENCODINGS = Hash.new { |h,key| h[key] = 'windows-1252'  }


site = Webget::Mirror::Website.new

###  check - auto-include  wwww.rsssf.org on rsssf.org  -- why? why not?
###   yes, gets handled by autofix_href  (see  sub('www.rsssf.org', 'rsssf.org')
site.base_url       = 'https://rsssf.org'

site.errata_edits   = ERRATA_EDITS
site.page_encodings = PAGE_ENCODINGS



## prefer (boost) pages  (with path like)
##    starting with /tables,/tables[a-z]/
##  => resulting in Page.where( 'path LIKE ?', '/table%' ) query
site.boost_pages_path_like = '/table%'


#####################
## auto-fix ("site-wide") known quirks:
site.autofix_href =   ->(href) {

        ##   www.rsssf.org/miscellaneous/penalties.html =>
        ##               /miscellaneous/penalties.html
        href = href.sub( %r{^www.rsssf.org}i, '' )

        ##
        ##   http.//  => http://
        href = href.sub( %r{^http\.//}i, 'http://' )

        ##   .html.html  => .html
        ##   e.g.  /tablesf/francarib2010.html.html
        ##         /tablest/tsje22.html.html
        href = href.sub( %r{\.html\.html}i, '.html' )


        ###
        ##  always downcase  /USAdave/ => /usadave/
        href = href.sub( '/USAdave/', '/usadave/' )

        ##
        ##    auto-change
        ##  if www.rsssf.org  change to  rsssf.org
        ##    maybe check for www.rsssf.org/ or such - why? why not?
        href = href.sub( 'www.rsssf.org', 'rsssf.org' )

        href
}




configs = parse_csv( <<TXT )

## starter pages for (recursive) mirror
##   if no encoding specified - assumes windows-1252 !!

page, encoding

##  /index.html
##  not really use all pages link to  /nersssf.html  (basically the same page)
##

/archive.html
/guide.html

/curtour.html
/curdom.html
/histdom.html
/intclub.html
/intland.html

/misc.html
/recent.html


# /tableso/oost2026.html
# /tablesi/ital2015.html

TXT

pp configs
=begin
[{"page"=>"/archive.html", "encoding"=>nil},
 {"page"=>"/guide.html",   "encoding"=>nil},
 {"page"=>"/curtour.html", "encoding"=>nil},
 {"page"=>"/curdom.html",  "encoding"=>nil},
 {"page"=>"/histdom.html", "encoding"=>nil},
 {"page"=>"/intclub.html", "encoding"=>nil},
 {"page"=>"/intland.html", "encoding"=>nil},
 {"page"=>"/misc.html",    "encoding"=>nil},
 {"page"=>"/recent.html",  "encoding"=>nil}]
=end




##
## to be done - add known encodings
=begin
def add_encodings( configs )
  configs.each do |config|
## todo / double check fix read_csv upstream
##    if   empty column has comment it is "" empty string otherwise
##                it is nil!!!  ??
        if config['encoding'].nil? || config['encoding'].empty?
            ## do nothing; use default (that is, windows-1252)
        else
           PAGES_ENCODING[config['page']] = config['encoding']
        end
  end
end
##
##  add/populate (known) encodings
## add_encodings( configs )
=end



site.start_pages = configs


## MirrorDb.open( './mirror-test.db'  )
MirrorDb.open( './mirror2.db'  )

=begin
-- create_table(:pages)
   -- add_index(:pages, :path, {:unique=>true})
-- create_table(:links, {:id=>false})
   -- add_index(:links, [:from_page_id, :to_page_id], {:unique=>true})
   -- add_index(:links, :from_page_id)
   -- add_index(:links, :to_page_id)
=end


##  kick-off mirror (operation/run)
site.mirror



puts "bye"





__END__



  add page /archive.html (cached: false) to mirror.db
#<MirrorDb::Model::Page:0x000001182c676778
 id: 1,
 path: "/archive.html",
 basename: "archive",
 dirname: "/",
 extname: ".html",
 title: nil,
 updated: nil,
 encoding: "windows-1252",
 ascii7bit: nil,
 tabs: nil,
 html_doctype: nil,
 html_charset: nil,
 http_content_type: nil,
 http_content_length: nil,
 http_status: nil,
 cached: false>

==> download https://rsssf.org/archive.html (encoding: windows-1252)...
GET https://rsssf.org/archive.html...
200 OK
[cache] saving ./cache2/rsssf.org/archive.html...
  [debug] try converting response.text encoding from >windows-1252< to >UTF-8<
 ---    0:01 mins -  1.15 secs/page  (1 pages)
   14 internal (& 0 anchor) & 11 external link(s) found in /archive.html:

 [1/1] update page /archive.html w/ 14 page(s) linked - >The RSSSF Archive<


==> download https://rsssf.org/curdom.html (encoding: windows-1252)...
  sleep 1 sec(s)...
GET https://rsssf.org/curdom.html...
200 OK
[cache] saving ./cache2/rsssf.org/curdom.html...
  [debug] try converting response.text encoding from >windows-1252< to >UTF-8<
 ---    0:02 mins -  1.35 secs/page  (2 pages)
   264 internal (& 0 anchor) & 0 external link(s) found in /curdom.html:

  [1/5] update page /curdom.html w/ 264 page(s) linked - >The RSSSF Archive - Current Domestic Results<

  ==> download https://rsssf.org/curtour.html (encoding: windows-1252)...
  sleep 1 sec(s)...
GET https://rsssf.org/curtour.html...
200 OK
[cache] saving ./cache2/rsssf.org/curtour.html...
  [debug] try converting response.text encoding from >windows-1252< to >UTF-8<
 ---    0:04 mins -  1.59 secs/page  (3 pages)
   147 internal (& 0 anchor) & 0 external link(s) found in /curtour.html:
