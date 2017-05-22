$i = 0
do
{
    new-item d:\test\$i.txt -type file
    $i++

} while ($i -lt 100)