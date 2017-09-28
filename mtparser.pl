#!/usr/bin/perl
#Marine traffic parser
#Blind Pew <blind.pew96@gmail.com> GNU GPL v3

use DBI;

$tab = $ARGV[0];
$inside = 0;

if($ARGV[1] =~ /dry/) {
    $dry = 1;
}
else {
    my %config = do 'config-db.pl';
    $dry = 0;
    $databaze = DBI->connect("DBI:mysql:database=".$config{db},
                    $config{user},
                    $config{pass})
                    or die "Neco se pokazilo... ",DBI->errstr, "\n";
}

while ($radek = <STDIN>) {
    chomp($radek);
    #uvnitr elementu <div>
    if($radek =~/id="tabs-last-pos"/) {
        $inside = 1;
    }
    
    if($inside) {
        
        #hledani casoveho razitka
        if($radek =~/data-time=/ and !$nalezeno) {
            if($dry) {
                print $radek."\n\n\n----------------------------\n";
            }
            $radek =~ /data-time="(.*?)"/;
            $ts = $1;
            $nalezeno = 1;
        }
        #hledani pozice
        if($radek =~/&deg;<\/a>/) {
            #print "$radek\n\n";
            ($lon, $lat) = $radek =~ /:(.*?)\//g;       
        }
    }
    
    if($radek =~/<i class="fa fa-chevron-right">/) {
        $inside = 0;
    }
}

if(!$dry and ($lat and $lon)) {
    my($ts_last) = $databaze->selectrow_array("select max(ts) from $tab");
    #ochrana vlozeni duplicit
    if ( $ts > $ts_last ) {
        $databaze->do("insert into $tab (ts, lat, lon) values ($ts, $lat, $lon)");
    }

    $databaze->disconnect();
}

else {
    print "Lod:\t".$tab."\n";
    print "Ts:\t".$ts."\n";
    print scalar localtime($ts)."\n";
    print "Lat:\t".$lat."\n";
    print "Lon:\t".$lon."\n";
    print "--------------END---------------\n\n";
}
