# RSSSF Mirror How-To


use `mirror` to mirror
the complete rsssf.org website
(about 40 000+ .html pages - about 800 MB)
by following (and recording) all internal links.
the command will download (and cache all .html pages
converted to utf-8)
and build-up a local (sqlite) `mirror.db` (about 20 MB)
with the link structure (ingoing and outgoing) & titles
using a `pages` and `links` table.

> [!NOTE]
> with a one second delay between downloads
> you can expect a run of 40 000 times 2 seconds,
> that is, about 22 hours.


```
$ ruby mirror/mirror.rb
```

note - the web pages get (by default) cached in `./cache`



use control-c to stop the mirror
and use ``ruby mirror/mirror.rb` to restart.
all visited pages and queued links
are stored in the `./mirror.db` and, thus,
the mirror can continue / resume  (without starting from zero / scratch again)
automatically.






> [!TIP]
>
>  Use the `report` command in the `mirror` tool to generate a page &
>   diretory statistics summary. Example:
>
>      $ ruby mirror/report.rb
>
>  resulting in [`mirror/SUMMARY.md`](mirror/SUMMARY.md).
>
>
>  Or use the `export` command to export all pages to datasets
>  in the comma-separated values (.csv) format. Example:
>
>      $ ruby mirror/export.rb
>
>  resulting in `pages_html.csv`, `pages_html_404.csv`, `pages_pdf.csv`,
>  `pages_other.csv` in the `tmp-mirror/` directory.
