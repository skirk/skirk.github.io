for i in post/*
do
	if [ ! -f "post/thumb/$i" ]
	then
		convert $i -geometry 75% ./post/thumb/`basename $i`
	fi
done
