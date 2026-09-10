# Notes



```
## add seed/start pages
##
##   note - read_csv (CsvReader) returns "" for empty fields and nil for non-existing fields
##           e.g.
##         page1, encoding1   =>    ['page1', 'encoding1']
##         page2,             =>    ['page2', '']
##         page3              =>    ['page3']   -- note: encoding results in nil!!


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
```




log

```
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

```