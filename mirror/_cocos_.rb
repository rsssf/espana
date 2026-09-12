

## "words" or "word array.
##  move upstream
##
##  follows  %w[] rules
##    splits on whitespace (space or newline)
##    BUT include support for inline comments!!!!
##
##    %w[apple banana cherry]
##        => ["apple", "banana", "cherry"]
##      note - allows more than one word on a line!!!!
##
##    %w[
##        ruby
##        python
##        javascript
##        go
##     ]
##      => ["ruby", "python", "javascript", "go"]
##
##  %w[] is a shorthand syntax (known as a percent literal)
##    used to create an array of strings.
##   It allows you to write an array of words without typing
##    repetitive quotation marks and commas.
##   Instead, you separate each item using whitespace (spaces or newlines).
##   note - You CANNOT use standard # comments inside %w[].
##    Ruby treats the # character as part of a literal string, which will ruin your array.
##
##
##  todo/check:
##   Option 1: The "Strict Space" Rule (Simplest & Safest)
##   In most text/config files, a comment is separated by a space
##    (e.g., key = value # comment).
##   If a # is glued to a word without a space, it is usually part of the data
##    (like a hex color #ffffff or a tag #important).
##     You can modify your code to only remove # if it is preceded by whitespace
##         color#ff0000     # red
##         color = #ff0000  # red
##   check - if this is how # is handled in yaml?
##      - Inline Comments: A # can be placed at the end of a line of data,
##                          but it must be preceded by a space.
##     e.g.  port: 8080# This will break or fail to parse correctly
##
##  e.g. use
##        line.sub( ??, '' ).strip

def parse_words( txt )
   words = []     ## array of strings
   txt.each_line( chomp: true ) do |line|

      line = line.strip

      next  if line.empty? || line.start_with?('#')

      ##  strip (inline) end-of-line comments (from line) too - keep why? why not?
      ##    ## (eat-up) REQUIRED leading (preceding) space(s) too - why? why not?
      line = line.sub( /[ \t]+#.*/, '' )

      ##  support __END__ marker for inline comments
      break  if line == '__END__'

      words += line.split( /[ \t]+/ )
   end

   words
end

##  alias_method :parse_wordarray, :parse_words
###





EDIT_PATH_HEADER_RE = %r{^   [ ]*
                          (?<path> [/a-z0-9._-]+)
                             [ ]*:[ ]*
                           $}ix

EDIT_SUB_CONTINUATION_RE = %r{  [ ]*
                                   =>
                                 [ ]*\n
                               }x

EDIT_SUB_SPLIT_RE = %r{   [ ]*
                              =>
                            [ ]*
                          }x

def parse_edits( txt )

   ### collapse  => with newline into one line
   txt = txt.gsub( "\r\n", "\n")   ## make sure universal newlines
   txt = txt.gsub( EDIT_SUB_CONTINUATION_RE, '  =>  ' )

   edits = {}
   last_path = nil
   txt.each_line do |line|
      line = line.strip
      next  if line.start_with?('#') || line.empty?

      if m=EDIT_PATH_HEADER_RE.match( line )
           last_path = m[:path]
      else
         ## check for substitution rule - search => replace
         parts = line.split( EDIT_SUB_SPLIT_RE, 2 )  ## note - only get max. two parts

         raise ArgumentError, "(path) header for search/replace line required >#{line}<"  if last_path.nil?

         if parts.size == 2
              edits[last_path] ||= []
              edits[last_path] << parts
         else
            raise ArgumentError, "two parts for search/replace line required >#{line}<"
         end
      end
   end

   edits
end

def read_edits( path )  parse_edits(read_text( path )); end
