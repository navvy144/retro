#!/bin/sh
#
# Retrospect Client Docker install script
#

CLIENTDIR=/usr/local/retrospect/client
STATEFILE=/var/log/retroclient.state
EXCLUDEFILE=/etc/retroclient.excludes

ISROOT="Yes"

INITD=/etc/init.d
RCD=rc.d/

/bin/mkdir /usr/local/retrospect
/bin/mkdir $CLIENTDIR

tar -xf ./RCL.tar
/bin/mv -f ./retroclient ./retrocpl  $CLIENTDIR
/bin/mv -f ./rcl $INITD
ln -sf $INITD/rcl $CLIENTDIR/rcl
/bin/mv -f ./retroclient.excludes /etc

#interactive setpass
echo -n "$CLIENTDIR/retroclient -setpass"

#install guides
if [ ! -d "/usr/local/man/man1" ]; then
   /bin/mkdir -p /usr/local/man/man1
fi
/bin/mv -f ./retroclient.1.gz ./retrocpl.1.gz /usr/local/man/man1
if [ -f ./retroclient.1 ]; then
        /bin/mv -f ./retroclient.1 ./retrocpl.1 /usr/local/man/man1
fi
if [ -d "/usr/man/man1" ]; then
        cp -f /usr/local/man/man1/retroclient.* /usr/man/man1
        cp -f /usr/local/man/man1/retrocpl.* /usr/man/man1
fi

if [ ! -d "/usr/share/info" ]; then
   /bin/mkdir -p /usr/share/info
fi
/bin/mv -f ./retroclient.info.gz /usr/share/info
if  [ -L /usr/share/info/dir ]; then
        INFODIRFILE=/etc/info-dir
else
        INFODIRFILE=/usr/share/info/dir
fi
cat<< EOF >> $INFODIRFILE

Retrospect Client 
* retroclient: (retroclient).                                   Retrospect Client.
* retrocpl: (retroclient)retrocpl.                              Retrospect Client Control Panel.
EOF

#
#  Set up the environment variables
#
#  Bash/sh first
echo ""
echo -n "Adding RETROSPECT_HOME to system profile and login scripts..."

if [ -f /etc/profile ]
then
        ISTHERE=`grep RETROSPECT_HOME /etc/profile`
        if [ ! -z "$ISTHERE" ]
        then
                cp /etc/profile /etc/profile.old
                sed -e "/RETROSPECT_HOME/d" < /etc/profile.old > /etc/profile
        fi
        echo "RETROSPECT_HOME=$CLIENTDIR" >> /etc/profile
        echo "export RETROSPECT_HOME" >> /etc/profile
fi
#
#  csh now
#
if [ -f /etc/.login ]
then
        ISTHERE=`grep RETROSPECT_HOME /etc/.login`
        if [ ! -z "$ISTHERE" ]
        then
                cp /etc/.login /etc/.login.old
                sed -e "/RETROSPECT_HOME/d" < /etc/.login.old > /etc/.login
        fi
        echo "setenv RETROSPECT_HOME $CLIENTDIR" >> /etc/.login
fi
echo "Done!"

exit 0



