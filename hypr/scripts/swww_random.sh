# up random wallpaper
#
# NOTE: this script is in bash (not posix shell), because the RANDOM variable
# we use is not defined in posix

directory=$1

if [[ $# -lt 1 ]] || [[ ! -d $directory ]]; then
	echo "Usage:
	$0 <dir containing images>"
	exit 1
fi

swww query || swww init

current_img=$(
	basename $(
		swww query \
		| awk -F'[: ]+' '/currently displaying/{print $NF}'
	)
)

wallpapers=($(
	ls "$directory" --ignore "$current_img" 
))

random_wallpaper=${wallpapers[ ((RANDOM % ${#wallpapers[@]})) ]}

swww img "$directory/$random_wallpaper" \
	--transition-type=any \
	--transition-fps=60  \
	--transition-duration=4 \
