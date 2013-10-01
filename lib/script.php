<?php
/*test form booking URL de synchronisation*/
#echo phpinfo(); exit;
#get variables
$my=$_GET['my'];
$test=$_GET['test'];
$id=$_GET['id'];
$hash=$_GET['hash'];
$mhash=$_GET['mhash'];
$REMOTE_ADDR=$_SERVER["REMOTE_ADDR"];
$uri=$_SERVER["SCRIPT_URI"];

#fixed var
$secret_key="zrL$\Rp5ImNsFWO,jv4THJ=@+Qn;t:(*|]!!2jf#.t";
$goodRemote="129.194.18.217"; //test
$goodRemote="193.111.202.14"; //prod

$to="frederic.radeff@unige.ch";

#calculs: hash concatenation cle secrete+idbooking
$cle=$secret_key.$id;

$controle=hash('sha256','$cle');
$controle2=md5('$cle');


$txt="
TEST URL DE SYNCHRONISATION booking
uri                 : $uri
my                  : $my
test                : $test
id                  : $id
hash                : $hash
mhash               : $mhash
REMOTE_ADDR         : $REMOTE_ADDR
cle                 : $cle
controle SHA256     : $controle
controle MD5        : $controle2
";



#if($hash!=$controle||$mhash!=$controle2){
if($hash!=$controle){
$txt="HACK???" .$txt ."

HASH INCORRECT!
";
echo nl2br($txt);
$headers ='From: ' .$REMOTE_ADDR ."\n";
$headers .='Content-Type: text/plain; charset="iso-8859-1"'.'\n';
    $couriel=mail($to, 'hack booking hash' , $txt, $headers);
exit;


} elseif($REMOTE_ADDR!=$goodRemote) {
$txt="HACK???" .$txt ."

SERVER INCORRECT!
";
echo nl2br($txt);
$headers ='From: ' .$REMOTE_ADDR ."\n";
$headers .='Content-Type: text/plain; charset="iso-8859-1"'.'\n';
    $couriel=mail($to, 'hack booking server' , $txt, $headers);
exit;


}else {
$txt=$txt ."

OK test url synchro!
";
echo nl2br($txt);
$headers ='From: ' .$REMOTE_ADDR ."\n";
$headers .='Content-Type: text/plain; charset="iso-8859-1"'.'\n';
    $couriel=mail($to, 'url synchro booking OK' , $txt, $headers);

echo "OK, continue with a script...";
}
?>
