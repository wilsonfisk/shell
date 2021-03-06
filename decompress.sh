#!/usr/bin/env bash
# A wrapper script to decompress various archive types.
# source: https://github.com/Herd-Base/general-scripts

shopt -s extglob

# options: help and list
if (( ! $# )) \
|| [[ "$*" =~ (^| )(-h|--help)( |$) ]] || [[ "$*" = @(-l|--list) ]] ; then
    printf "${0##*/} [*-l] <file>... — wrapper script to decompress various "
    echo   "archive types"
    echo   "  -l, --list  - list archive contents"
    exit 2
elif [[ "$*" =~ (^| )(-l|--list)( |$) ]] ; then
    list=y
fi 

# archive existence test
for archive in "$@" ; do
    [[ "$archive" = @(-l|--list) ]] && continue
    [ ! -f "$archive" ] && { echo archive non-existent: "$archive" ;arc_noex=yes;}
done ; [ "$arc_noex" ] && exit 1

# program existence test
prg_test () { hash $prg 2>&- || { echo program required: $prg ; arc_prrq=y ; };}

for archive in "$@" ; do
case "$archive" in
    -l | --list              )  continue                   ;;
    *.tar                    )  prg=tar        ; prg_test  ;;
    *.@(tar.bz2|tb@(2|z|z2)) )  prg=bzip2      ; prg_test  ;;
    *.@(tar.gz|tgz)          )  prg=gzip       ; prg_test  ;;
    *.tar.lz                 )  prg=lzip       ; prg_test  ;;
    *.@(tar.lzma|tlz)        )  prg=xz         ; prg_test  ;;
    *.@(tar.xz|txz)          )  prg=xz         ; prg_test  ;;
    *.@(tar.Z|t?(a)z)        )  prg=gzip       ; prg_test  ;;
    *.7z                     )  prg=7zr        ; prg_test  ;;
    *.bz2                    )  prg=bunzip2    ; prg_test  ;;
    *.exe                    )  prg=cabextract ; prg_test  ;;
    *.gz                     )  prg=gunzip     ; prg_test  ;;
    *.lz                     )  prg=lzip       ; prg_test  ;;
    *.rar                    )  prg=unrar      ; prg_test  ;;
    *.xz                     )  prg=xz         ; prg_test  ;;
    *.Z                      )  prg=gzip       ; prg_test  ;;
    *.zip                    )  prg=unzip      ; prg_test  ;;
    *                        )  echo extension unknown: "$archive" ; arc_prrq=y ;;
esac
done ; [ "$arc_prrq" ] && exit 1

# list
[ "$list" ] && \
for archive in "$@" ; do
    [[ "$archive" = @(-l|--list) ]] && continue
echo -e "\e[1m "$archive" \e[0m"
case "$archive" in
    *.tar                    )  tar tvf           "$archive"      ;;  
    *.@(tar.bz2|tb@(2|z|z2)) )  tar tvf           "$archive"      ;;  
    *.@(tar.gz|tgz)          )  tar tvf           "$archive"      ;;  
    *.tar.lz                 )  tar tvf           "$archive"      ;;  
    *.@(tar.lzma|tlz)        )  tar tvf           "$archive"      ;;  
    *.@(tar.xz|txz)          )  tar tvf           "$archive"      ;;  
    *.@(tar.Z|t?(a)z)        )  tar tvf           "$archive"      ;;  
    *.7z                     )  7zr l -bd         "$archive"      ;;  
    *.bz2                    )  echo              "${archive%.*}" ;;  
    *.exe                    )  cabextract --list "$archive"      ;;  
    *.gz                     )  echo              "${archive%.*}" ;;  
    *.lz                     )  echo              "${archive%.*}" ;;  
    *.rar                    )  unrar l           "$archive"      ;;  
    *.xz                     )  echo              "${archive%.*}" ;;    
    *.Z                      )  gzip --list       "$archive"      ;;  
    *.zip                    )  unzip -l -qq      "$archive"      ;;  
esac
done ; [ "$list" ] && exit

# decompress
arc () { echo "$archive"..." " ; }

for archive in "$@" ; do
case "$archive" in
    *.tar                    )  arc ; tar    -xf    "$archive" 2>&1 > /dev/null ;;
    *.@(tar.bz2|tb@(2|z|z2)) )  arc ; tar    -xf    "$archive" 2>&1 > /dev/null ;;
    *.@(tar.gz|tgz)          )  arc ; tar    -xf    "$archive" 2>&1 > /dev/null ;;
    *.tar.lz                 )  arc ; tar    -xf    "$archive" 2>&1 > /dev/null ;;
    *.@(tar.lzma|tlz)        )  arc ; tar    -xf    "$archive" 2>&1 > /dev/null ;;
    *.@(tar.xz|txz)          )  arc ; tar    -xf    "$archive" 2>&1 > /dev/null ;;
    *.@(tar.Z|t?(a)z)        )  arc ; tar    -xf    "$archive" 2>&1 > /dev/null ;;
    *.7z                     )  arc ; 7zr      x    "$archive" 2>&1 > /dev/null ;;
    *.bz2                    )  arc ; bunzip2 -k    "$archive" 2>&1 > /dev/null ;;
    *.exe                    )  arc ; cabextract    "$archive" 2>&1 > /dev/null ;;
    *.gz                     )  arc ; gunzip  -k    "$archive" 2>&1 > /dev/null ;;
    *.lz                     )  arc ; lzip    -k -d "$archive" 2>&1 > /dev/null ;;
    *.rar                    )  arc ; unrar    x    "$archive" 2>&1 > /dev/null ;;
    *.xz                     )  arc ; unxz    -k    "$archive" 2>&1 > /dev/null ;;
    *.Z                      )  arc ; gunzip  -k    "$archive" 2>&1 > /dev/null ;;
    *.zip                    )  arc ; unzip   -q    "$archive" 2>&1 > /dev/null ;;
esac
done
