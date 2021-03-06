#!/usr/bin/env bash
# A tar wrapper script to simplify archiving files.
# source: https://github.com/Herd-Base/general-scripts

# help
if [ $# -eq 0 -o "$1" = -h -o "$1" = --help ] ; then
    echo "${0##*/} <file1> <*dir>... - archive files, folders..."
    exit 2
fi

# file existence test
for file in "$@" ; do
    [ ! -e "$file" ] && echo "file non-existent: "$file"" && error=y
done
[ "$error" ] && exit 1

# archive name
read -e -p "archive name [archive.tar.gz]: " arc_nme 
[ ! "$arc_nme" ] && arc_nme=archive.tar.gz

# program existence test
shopt -s extglob
case "$arc_nme" in
    *.@(tar.bz2|tb@(2|z|z2)) )  p=bzip2      ; hash $p 2>&- \
                                || { echo program required: $p ; arc_prrq=y ; } ;;
    *.@(tar.gz|tgz)          )  p=gzip       ; hash $p 2>&- \
                                || { echo program required: $p ; arc_prrq=y ; } ;;
    *.tar.lz                 )  p=lzip       ; hash $p 2>&- \
                                || { echo program required: $p ; arc_prrq=y ; } ;;
    *.@(tar.lzma|tlz)        )  p=xz         ; hash $p 2>&- \
                                || { echo program required: $p ; arc_prrq=y ; } ;;
    *.@(tar.xz|txz)          )  p=xz         ; hash $p 2>&- \
                                || { echo program required: $p ; arc_prrq=y ; } ;;
    *.@(tar.Z|t?(a)z)        )  p=gzip       ; hash $p 2>&- \
                                || { echo program required: $p ; arc_prrq=y ; } ;;
    *.tar                    )  p=tar        ; hash $p 2>&- \
                                || { echo program required: $p ; arc_prrq=y ; } ;;
    *                        )  { echo ext unknown: "$archive" ; arc_prrq=y ; } ;;
esac ; [ "$arc_prrq" ] && exit 1

# archive overwrite prompt
[ -f "$arc_nme" ] && while : ; do
    read -p "archive exists, overwrite? (y/n): " arc_ovr
    shopt -s extglob
    if   [[ "$arc_ovr" = [yY]?(e)?(s) ]] ; then
        opt_ovr=--overwrite
        break
    elif [[ "$arc_ovr" = [nN]?(o)     ]] ; then
        exit 2
    fi
done

# archive creation
tar --create --auto-compress --file "$arc_nme" "$@" $(printf '%s' "$opt_ovr") \
&& [ -f "$arc_nme" ] && echo "archive created: "$arc_nme""
