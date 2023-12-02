# InternetArchive-scripts
Various little scripts for using Internet Archive

Most of these scripts require the [ia command line tool](https://archive.org/developers/quick-start-cli.html). Some require [jq](https://jqlang.github.io/jq/). Some also require [GNU Parallel](https://opensource.com/article/18/5/gnu-parallel).

clone.sh — when you want to use the web-based uploader to upload a new item to Internet Archive with metadata that is very similar to an existing item, do _clone.sh identifiername_ and it will output a link that will prefill the metadata for your newly uploaded item.

hinge.sh — a dating app (haha) — iterates though a collection, finds items without date metadata, and asks you to enter the date. It tries to guess the date if it sees YYYY or YYYY-MM or YYYY-MM-DD format in the item title.

nothumb.sh — lists items in a collection that lack a thumbnail image.

nofiles.sh — lists items in a collection that lack any files at all (except xml files).

See also [The Internet Archive Research Assistant](https://github.com/savetz/tiara) and [InternetArchive-xtree](https://github.com/savetz/InternetArchive-xtree)

You should [donate to Internet Archive](https://archive.org/donate).
