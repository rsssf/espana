############
#  to run use:
#
#    $ ruby mirror/mirror.rb


$LOAD_PATH.unshift( '/sports/rubycocos/webclient/webget-mirror/lib' )
require 'webget/mirror'


require_relative '_cocos_'   ## move upstream into cocos!!!



Webcache.root = './cache'
Webget.config.delay_in_s = 1





site = Webget::Mirror::Website.new

###  check - auto-include  wwww.rsssf.org on rsssf.org  -- why? why not?
###   yes, gets handled by autofix_href  (see  sub('www.rsssf.org', 'rsssf.org')
site.base_url = 'https://rsssf.org'


##
##  defaults to windows-1252  if
###  lookup by path e.g. /curtour.html
PAGE_ENCODINGS = Hash.new { |h,key| h[key] = 'windows-1252'  }

## lookup page encoding by path
##    maybe change later to url - why? why not?
site.page_encoding =   ->( path ) {
       PAGE_ENCODINGS[ path ]
}


##
##  todo/check - use errata_html.txt - why? why not?
##
ERRATA_EDITS = read_edits( './mirror/errata.txt' )

## lookup edits by path e.g. /tablesp/poland-satrip77.html
##                       or  /miscellaneous/torre-madrid.html
site.errata =  ->( html, url: ) {

         page_url = URI( url )

         edits = ERRATA_EDITS[page_url.path]

         ## note - for now always use gsub (not sub)
         ##   maybe add option later
         if edits
            edits.each do |search,replace|
                          html = html.gsub( search, replace )
                       end
         end

         html  ## pass along edited or as is (1:1)
}



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

=begin
         ##
         ## note - workaround for windows
         ##     on windows File.exist? (and Webcache.cached?)
         ##          is case-insensitive
         ##    e.g. /USAdave/ is the same as /usadave/
         ##
         ##   as a workaround ALWAYS hardcode 404
         ##    for /USAdave/    to get (and record) 404  (and not CACHE HITS!!)
         ##   e.g. try https://rsssf.org/USAdave/cncc.html  => 404 (NOT FOUND)
         ##            https://rsssf.org/usadave/cncc.html  => 200 (OK)

        ## if %r{/USAdave/}.match?(page_rec.path)
        ##                                 ['', {status: 404}]
=end


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



site.start_pages = configs

## prefer (boost) pages  (with path like)
##    starting with /tables,/tables[a-z]/
##  => resulting in Page.where( 'path LIKE ?', '/table%' ) query
site.boost_pages_path_like = '/table%'




## MirrorDb.open( './mirror-test.db'  )
MirrorDb.open( './mirror.db'  )

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
