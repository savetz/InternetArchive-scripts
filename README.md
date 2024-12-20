# InternetArchive-scripts
Various little scripts for using Internet Archive

These scripts require the [ia command line tool](https://archive.org/developers/quick-start-cli.html). Some require [jq](https://jqlang.github.io/jq/). Some also require [GNU Parallel](https://opensource.com/article/18/5/gnu-parallel).

clone.sh — when you want to use the web-based uploader to upload a new item to Internet Archive with metadata that is very similar to an existing item, do _clone.sh identifiername_ and it will output a link that will prefill the metadata for your newly uploaded item.

hinge.sh — a dating app (haha) — iterates though a collection, finds items without date metadata, and asks you to enter the date. It tries to guess the date if it sees YYYY or YYYY-MM or YYYY-MM-DD format in the item title. Now also looks for YYYY MM or YYYY MM DD, and looks for written out month names like Nov or November
```
=== vhfuhfdigestapri00unse_8
Title: Vhf-UhfDigest April 1999
vhfuhfdigestapri00unse_8 already has a date field: 1999
My guess is: 1999-04
Enter a replacement date, or return for my guess, or 'x' to skip.

vhfuhfdigestapri00unse_8 - success: https://catalogd.archive.org/log/4583810060

=== vhfuhfdigestdece00unse_3
Title: Vhf-UhfDigest December 1992
vhfuhfdigestdece00unse_3 already has a date field: 1992-12
My guess is: 1992-12
   ...which is the same. Moving on.

=== space-show-1997-programme
Title: South Pacific Region Satellite & Cable Show 1997 programme
space-show-1997-programme already has a date field: 1997-01-21
My guess is: 1997
   ...but my guess is less precise than the existing date. Skipping.
```
searchreplacetitles.sh — search and replace item titles across a collection (or other type of search)
```
Item ID: vhfuhfdigestjuly00unse_4
Original Title: Vhf-UhfDigest July 1993
Proposed Title: VHF-UHF Digest July 1993
Do you want to update the title? (y/N): y
Updating title for vhfuhfdigestjuly00unse_4...
vhfuhfdigestjuly00unse_4 - success: https://catalogd.archive.org/log/4585735625
```

nothumb.sh — lists items in a collection that lack a thumbnail image.

nofiles.sh — lists items in a collection that lack any files at all (except xml files).

translate-description.py - use ChatGPT to translate an Internet Archive item description to English, put the translation in the item's Notes field.

See also [The Internet Archive Research Assistant](https://github.com/savetz/tiara) and [InternetArchive-xtree](https://github.com/savetz/InternetArchive-xtree)

You should [donate to Internet Archive](https://archive.org/donate).
