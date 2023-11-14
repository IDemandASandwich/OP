#!/bin/bash
cat << THE_END
<!DOCTYPE html>
<html>
<head>
  <meta http-equiv="Content-type" content="text/html;charset=UTF-8" />
</head>
<body>
THE_END

ZOZ="n"

while IFS= read LINE
do
	if echo "$LINE" | grep '##' > /dev/null
	then
		LINE=$(echo "$LINE" | sed "s@## @<h2>@")
		echo "$LINE</h2>"
		continue
	elif echo "$LINE" | grep '#' > /dev/null
	then
		LINE=$(echo "$LINE" | sed "s@# @<h1>@")
		echo "$LINE</h1>"
		continue
	elif echo "$LINE" | grep '__' > /dev/null
	then
		echo $(echo "$LINE" | sed 's@__\([^_]\+\)__@<strong>\1</strong>@g')
		continue
	elif echo "$LINE" | grep '_' > /dev/null
	then
		echo $(echo "$LINE" | sed 's@_\([^_]\+\)_@<em>\1</em>@g')
		continue
	elif echo "$LINE" | grep '^$' > /dev/null
	then
		echo "<p>"
		continue
	elif echo "$LINE" | grep '<https://.*>' > /dev/null
	then
		echo $(echo "$LINE" | sed 's@<https:\([^>]\+\)>@<a href=\"https:\1\">https:\1</a>@g')
		continue
	elif echo "$LINE" | grep ' - ' > /dev/null 
	then
		if [ "$ZOZ" = "n" ]
		then
			echo "<ol>"
			ZOZ="y"
		fi
		echo $(echo "$LINE" | sed 's@- \(.*\)@<li>\1</li>@g')
		continue
	else
		if [ "$ZOZ" = "y" ]
		then
			echo "</ol>"
			ZOZ="n"
		fi
		echo "$LINE"
	fi
done

cat << THE_END
</body>
</html>
THE_END
