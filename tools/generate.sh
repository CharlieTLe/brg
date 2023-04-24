#!/bin/zsh


guilds=(
	'mandos_periperi w53E_OdzQfmvfbZrbu-1kw'
	'high-council zfBluFnbQHGR8ySBhDc7RA'
)

# prime the pipe -- fetch the first guild
echo "==============="
echo "FETCH: $guilds[1]"
args=("${(@s/ /)guilds[1]}")

echo "~/bin/swgoh-tool fetch --id $args[2] --guild $args[1].json"
time ~/bin/swgoh-tool fetch --id $args[2] --guild $args[1].json || exit 1


for ((i = 1; i < $#guilds; i++)) ; do 
	args=("${(@s/ /)guilds[i]}")
	
	# now build the guild we just fetched
	echo "~/bin/swgoh-tool site-guild --brg --guild $args[1].json --output docs"
	time ~/bin/swgoh-tool site-guild --brg --guild $args[1].json --output docs &
	
	# and fetch the next one
	
	echo "==============="
	args=("${(@s/ /)guilds[i + 1]}")
	echo "FETCH: $args"

	echo "~/bin/swgoh-tool fetch --id $args[2] --guild $args[1].json"
	time ~/bin/swgoh-tool fetch --id $args[2] --guild $args[1].json || exit 1
	
	# wait for both to complete
	wait
	
done

# finish the pipeline
args=("${(@s/ /)guilds[$#guilds]}")
echo "~/bin/swgoh-tool site-guild --brg --guild $args[1].json --output docs"
time ~/bin/swgoh-tool site-guild --brg --guild $args[1].json --output docs &

echo "==============="
echo "ALLIANCE"

time ~/bin/swgoh-tool site-alliance --brg --output docs --guilds *.json

wait

ret=$?; times; exit "$ret"
