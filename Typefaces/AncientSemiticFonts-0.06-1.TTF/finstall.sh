#!/bin/bash

VERSION=0.06-1

# install/uninstall the Ancient Semitic fonts package

usage()
{
    echo "usage ./finstall.sh --help       (display   help)"
    echo "      ./finstall.sh              (install   fonts)"
    echo "      ./finstall.sh --uninstall  (uninstall fonts)"
}

#------------------------------------------------------------
FDIR=AncientSemitic
DOCDIR=AncientSemiticFonts-$VERSION
DCDU=$HOME/doc/$DOCDIR
DCDR=/usr/share/doc/$DOCDIR
DFILES="README LICENSE CHANGES GNU-GPL"

# list of fonts in the package
PROTOCANAAN="Proto-Canaanite.ttf"
PHOENICIAN="Phoenician-Ahiram.ttf"
PALEOHEB="Hebrew-Paleo-Gezer.ttf Hebrew-Paleo-Mesha.ttf Hebrew-Paleo-Siloam.ttf Hebrew-Paleo-Lachish.ttf  Hebrew-Paleo-Qumran.ttf  Hebrew-Samaritan.ttf"
ARAMAIC="Aramaic-Early-Br-Rkb.ttf Aramaic-VIIBCE.ttf Aramaic-Imperial-Yeb.ttf"
JUDEAN="Hebrew-Square-Isaiah.ttf Hebrew-Square-Habakkuk.ttf Hebrew-Square-BenKosba.ttf"
SQUARE="Hebrew-Square-Bet-Shearim.ttf KeterAramTsova.ttf"
NEW="Hebrew-SoferStam-Ashkenaz.ttf KeterYG-Medium.ttf KeterYG-MediumOblique.ttf KeterYG-Bold.ttf KeterYG-BoldOblique.ttf MakabiYG.ttf"

ALLTTF="$PROTOCANAAN $PHOENICIAN $PALEOHEB $ARAMAIC $JUDEAN $SQUARE $NEW"

#-------------------------------------------------------------------


if [ "$1" = "--help" ]; then
    usage
    exit 0
fi
if [ $# -gt 1 ]; then
    echo
    echo "only one parameter allowed"
    echo
    usage
    exit 1
fi


if [ "$#" = "0" ]; then
    HERE=`pwd`
    if [ $USER != root ]; then
	    mkdir -p $HOME/.fonts;
	    cp -f fonts/* $HOME/.fonts
	    mkdir -p  $DCDU
	    cp $DFILES $DCDU
    else
	    mkdir -p /usr/share/fonts/$FDIR
	    cp fonts/* /usr/share/fonts/$FDIR
	    cd /usr/share/fonts/$FDIR
	    chmod 644 *
	    cd $HERE
	    mkdir -p $DCDR
	    cp $DFILES $DCDR
	    cd $DCDR
	    chmod 644 *	
    fi
    fc-cache
    echo
    echo "Fonts installed"
    exit
else
    if [ "$1" != "--uninstall" ]; then
        echo
        echo "Wrong parameter $1"
        echo
        usage
        exit 1
    fi
    if [ $USER != root ]; then
	    cd $HOME
        if [ -d doc ]; then
	        rm -rf doc/$DOCDIR
	        cd doc
	        NF=`ls|wc -l`
	        if [ "$NF" = "0" ]; then
	            cd ..
	            rm -rf doc
	        fi
	    fi
	    cd $HOME/.fonts
	    rm -f $ALLTTF
	    rm -f fonts.dir  fonts.scale
	    NF=`ls|wc -l`
	    if [ "$NF" = "0" ]; then
	        cd ..
	        rm -rf .fonts
	    fi
    else
	    cd /usr/share/fonts
	    rm -rf $FDIR
	    cd /usr/share/doc
	    rm -rf $DOCDIR
    fi
	fc-cache
	echo
	echo "Fonts and Documentation uninstalled"
fi

