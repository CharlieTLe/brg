#!/bin/zsh


guilds=(
	'exile 656997348'
	'hope 369351434'
	'hoth 478284627'
	'lop oFnRSXMiRIqJL2TbM0LOzw'
	'mandalorians 873945644'
	'twd 855782277'
	'wk 221913824'
	'tt 861877851'
	'templar 638481212'
	'kotd 126515217'
	'lazerfaces 552198166'
	'ahsoka 842227845'
	'mandos_periperi w53E_OdzQfmvfbZrbu-1kw'
	'space-dragons 499445554'
	'odor 933888673'
	'holocron 684712353'
	'youngling 211844511'
	'umbaran 848839342'
	'away 347197687'
	'sandpeople 559593336'
	'happyaccidents 753267475'
	'dsr 144743434'
	'frozenshard 569316171'
	'guildest 786886424'
	'bolls 663558394'
	'nebeski 749482363'
	'calamity ObLbsNEAR7aAHUTM44vzKA'
	'vaders-wake 623332958'
	'noble 985738122'
	'darkforce 938276726'
	'zeros 287952553'
	'deathless 762819711'
	'high-council zfBluFnbQHGR8ySBhDc7RA'
	'xscoundrels 749817979'
	'fallen ZaPWQdcaQLOd8UhMLUC4Xg'
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
