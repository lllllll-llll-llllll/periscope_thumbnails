#include <array.au3>

;https://www.periscope.tv/username/broadcast_id
$user = 'xxxxxxxxxx'  ;username
$bid  = 'xxxxxxxxxx'  ;broadcast_id
$url = 'https://www.periscope.tv/' & $user & '/' & $bid
$filename = @scriptdir & '\html.txt'
InetGet($url, $filename)

$page = filereadline(@scriptdir & '\html.txt', 20)
filedelete(@scriptdir & '\html.txt')
$results = stringregexp($page, 'session_id&quot;:&quot;(.*)&quot;}' , 1)
$split = stringsplit($results[0], '&', 2)
$sid = $split[0]

$url = 'https://api.periscope.tv/api/v2/publicReplayThumbnailPlaylist?broadcast_id=' & $bid & '&session_id=' & $sid
$filename = @scriptdir & '\playlist.txt'
InetGet($url, $filename)

$page = filereadline(@scriptdir & '\playlist.txt', 1)
filedelete(@scriptdir & '\playlist.txt')
$split = stringsplit($page, '"tn":"', 3)

$path = @scriptdir & '\' & $user & '\' & $bid
if not fileexists($path) then dircreate($path)

for $i = 1 to (ubound($split) - 1) step 1
  $first = stringsplit($split[$i], '"', 3)
  $image = stringreplace($first[0], '\u0026', '&')
  $filename = $path & '\' & $i & ".jpg"
  InetGet($image, $filename)
next

exit
