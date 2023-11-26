#!/usr/bin/env bash
set -euo pipefail

# Color codes
NORMAL="\x1b[0m"
STATUS="\x1b[34m"
ERROR="\x1b[31m"
EOL="$NORMAL\n"

# Width of graphs, is shortened if constrained by screen size
BAR_WIDTH=20

CONFIG_PATH="$HOME/.config/weather-sh.json"

# Start and end time, in seconds to display relative to the current time
BEGIN_S=$((-6*60*60))
END_S=$((24*60*60))

RETURN_CODE=0

# Check dependencies
for i in curl jq sed tput; do
    if ! which "$i" &>/dev/null; then
        printf "${ERROR}Dependency error: %s not found$EOL" "$i" >&2
        RETURN_CODE=1
    fi
done
if test $RETURN_CODE != 0; then
    exit $RETURN_CODE
fi

# Generates a 24-bit forground color code (R=$2 G=$3 B=$4)
function color {
    printf "\x1b[38;2;$1;$2;$3m"
}

# Converts $1 (a float or int) to an int with $2 added digets of precision
# For example float_to_int 7.2 3 -> 7200
function float_to_int {
    FORMATTED="$(printf "%.$2f" $1)"
    echo "${FORMATTED%.*}${FORMATTED#*.}"
}

# Linear intERPolation. as $1 moves between $2 and $3, result will move between $4 and $5.
# All inputs should be ints, output is an int
function lerp {
    LERP_VALUE=$1
    IN_LOW=$2
    IN_HEIGH=$3
    OUT_LOW=$4
    OUT_HEIGH=$5
    echo $((($LERP_VALUE-$IN_LOW)*($OUT_HEIGH-$OUT_LOW)/($IN_HEIGH-$IN_LOW)+$OUT_LOW))
}

# $1 is a WMO weather code, $2 is either day or night
# Output is a colored string with an emoji that describes the weather
# See https://www.nodc.noaa.gov/archive/arc0021/0002199/1.1/data/0-data/HTML/WMO-CODE/WMO4677.HTM
# See https://gist.github.com/stellasphere/9490c195ed2b53c707087c8c2db4ec0c
# See https://epic.awi.de/id/eprint/29966/1/WMO2011h.pdf
function weather_code_to_description {
    # A lot of the emojis need an extra space after them to print correctly on my terminal. Might be something to do with a variation selector
    case $1 in
        0) if test $2 == night; then
                printf "$(color 92 119 242)🌛 Clear"
            else
                printf "$(color 255 250 154)🌞 Sunny"
            fi;;
        1) if test $2 == night; then
                printf "$(color 114 133 216)🌛 Mostly clear"
            else
                printf "$(color 236 236 171)🌤️  Mostly sunny"
            fi;;
        2) if test $2 == night; then
                printf "$(color 141 151 196)☁️  Partly cloudy"
            else
                printf "$(color 193 193 176)⛅ Partly cloudy"
            fi;;
        3) printf "$(color 181 181 181)☁️  Cloudy";;
        14|15|16) printf "$(color 107 156 211)🌧️  Distant rain";;
        50|51|52) printf "$(color 155 174 196)🌧️  Slight drizzle";;
        20|53|54|55) printf "$(color 119 161 209)🌧️  Drizzle";;
        58|60|61|62|80|91) printf "$(color 88 148 216)🌧️  Slightly rainy";;
        59|21|25|63|64|81|82|92) printf "$(color 55 136 229)🌧️  Rainy";;
        65) printf "$(color 16 94 183)🌧️  Raining cats and dogs";;
        56|57) printf "$(color 138 197 216)🌨️  Freezing drizzle";;
        23|24|26|66|67|68|69|83|84|93|94) printf "$(color 85 189 224)🌨️  Freezing rain";;
        70|71|72|85) printf "$(color 226 226 226)❄️  Slightly snowy";;
        22|36|37|38|39|73|74|75|86) printf "$(color 255 255 255)❄️  Snowy";;
        27|87|88|89|90) printf "$(color 150 150 150)🌨️  Hailing";;
        76|77|78|79) printf "$(color 179 209 221)🌨️  Wintry";;
        13) printf "$(color 234 233 147)⚡ Lightning";;
        17|29|95|97|98) printf "$(color 234 233 147)⛈️  Thunderstorms";;
        96|99) printf "$(color 234 233 147)⛈️  Thunderstorms and hailing";;
        11) printf "$(color 206 206 206)🌫️  Slightly foggy";;
        12|28|40|41|42|43|44|45|46|47|48|49) printf "$(color 232 232 232)🌫️  Foggy";;
        4) printf "$(color 153 135 104)💨 Smoky";;
        5) printf "$(color 181 170 150)🌫️  Hazy";;
        10) printf "$(color 205 233 244)🌫️  Misty";;
        6|7|8|9) printf "$(color 201 166 126)🌬️  Dusty";;
        30|31|32) printf "$(color 201 166 126)🌬️  Duststorm";;
        33|34|35) printf "$(color 201 166 126)🌬️  Severe duststorm";;
        18) printf "$(color 252 128 128)🌪️  Squalls";;
        19) printf "$(color 252 128 128)🌪️  Tornado clouds";;
        *) printf "$(color 252 128 128)❓ Unusual (WMO $1)";;
    esac
}

# Draws a unicode graph bar with value $1 between $2 and $3 in $4 characters
function draw_graph_bar {
    VALUE=$1
    LOW=$2
    HEIGH=$3
    WIDTH=$4
    TOTAL_STEPS=$(lerp $VALUE $LOW $HEIGH 0 $(($WIDTH*8)))
    if test $TOTAL_STEPS -lt 0; then
        TOTAL_STEPS=0
    fi
    # printf " $VALUE $LOW $HEIGH 0 $(($WIDTH*8)) "
    # printf " $TOTAL_STEPS "
    BIG_STEPS=$((TOTAL_STEPS/8))
    SMOL_STEPS=$((TOTAL_STEPS%8))
    REPEAT=$(printf "%${BIG_STEPS}s")
    printf "${REPEAT// /█}"
    if test $BIG_STEPS -eq $WIDTH; then
        return
    fi
    # printf " $TOTAL_STEPS $BIG_STEPS $SMOL_STEPS $REPEAT "
    case $SMOL_STEPS in
        0) printf ' ';;
        1) printf '▏';;
        2) printf '▎';;
        3) printf '▍';;
        4) printf '▌';;
        5) printf '▋';;
        6) printf '▊';;
        7) printf '▉';;
        *) printf "${ERROR}Invalid SMOL_STEPS: %s" "$SMOL_STEPS" >&2; return;;
    esac
        # *) printf "${ERROR}Invalid SMOL_STEPS: %s$EOL" "$SMOL_STEPS" >&2; return;;
    printf "%$(($WIDTH-$BIG_STEPS-1))s"
}

# Returns a 24-bit color (RR GG BB) for a given temperature fahrenheit ($1)
function temp_to_color {
    TEMP_10X=$1
    # TEMP_10X=$(lerp $TEMP_10X 500 800 320 500)
    if test $TEMP_10X -lt 320; then
        lerp $TEMP_10X 150 320 255  79 # R
        lerp $TEMP_10X 150 320 255 185 # G
        lerp $TEMP_10X 150 320 255 234 # B
    elif test $TEMP_10X -lt 500; then
        lerp $TEMP_10X 320 500  79  74 # R
        lerp $TEMP_10X 320 500 185 137 # G
        lerp $TEMP_10X 320 500 234 135 # B
    elif test $TEMP_10X -lt 800; then
        lerp $TEMP_10X 500 800  74 239 # R
        lerp $TEMP_10X 500 800 137 229 # G
        lerp $TEMP_10X 500 800 135  83 # B
    elif test $TEMP_10X -lt 1050; then
        lerp $TEMP_10X 800 1050 239 249 # R
        lerp $TEMP_10X 800 1050 229 203 # G
        lerp $TEMP_10X 800 1050  83  49 # B
    else
        lerp $TEMP_10X 1050 1300 249 209 # R
        lerp $TEMP_10X 1050 1300 203  68 # G
        lerp $TEMP_10X 1050 1300  49  12 # B
    fi
}

# Test temp_to_color using this:
# for i in {0..120}; do echo $(color "███ $i" $(temp_to_color $i)); done

# Returns a 24-bit color (RR GG BB) for a given percentage probability ($1) and temperature fahrenheit ($2)
function precip_prob_to_color {
    PROB=$1
    TEMP_10X=$2
    if test $TEMP_10X -ge 320; then
        lerp $PROB 0 100 105  13 # R
        lerp $PROB 0 100 208  38 # G
        lerp $PROB 0 100 224 163 # B
    else
        lerp $PROB 0 100 105 255 # R
        lerp $PROB 0 100 208 255 # G
        lerp $PROB 0 100 224 255 # B
    fi
}

function humid_to_color {
    HUMIDITY=$1
    if test $HUMIDITY -gt 80; then
        HUMIDITY=80
    elif test $HUMIDITY -lt 20; then
        HUMIDITY=20
    fi
    lerp $HUMIDITY 20 80 222  92 # R
    lerp $HUMIDITY 20 80 222 119 # G
    lerp $HUMIDITY 20 80 222 242 # B
}

# Shows the forcast for a given location $1 in the format of LAT,LON
function show_forcast {
    # Extract lat and lon from the argument
    LAT=${1%,*}
    LON=${1#*,}
    CURRENT_TIMESTAMP="$(date "+%s")"

    # Fetch the forcast from the open-meteo API
    # printf "${STATUS}Fetching weather...$EOL" >&2
    # See https://open-meteo.com/en/docs
    # URL="https://api.open-meteo.com/v1/forecast?latitude=$LAT&longitude=$LON&hourly=temperature_2m,relative_humidity_2m,precipitation_probability,weather_code&daily=sunrise,sunset&timezone=GMT&temperature_unit=fahrenheit&past_days=1&forecast_days=2"
    # URL="https://api.open-meteo.com/v1/forecast?latitude=$LAT&longitude=$LON&current=temperature_2m,relative_humidity_2m&hourly=weather_code&daily=temperature_2m_max,temperature_2m_min,sunrise,sunset,precipitation_sum,rain_sum&temperature_unit=fahrenheit&forecast_days=1"
    URL="https://api.open-meteo.com/v1/forecast?latitude=36.039&longitude=-78.878&current=temperature_2m,relative_humidity_2m&hourly=weather_code&daily=temperature_2m_max,temperature_2m_min,sunrise,sunset,precipitation_sum,rain_sum&temperature_unit=fahrenheit&forecast_days=1"
    # echo "URL: $URL" >&2
    DATA=$(curl -s "$URL")
    # printf "${STATUS}Parsing data" >&2

    # Error detection
    if test "$(jq .error <<< "$DATA")" == true; then
        printf "${ERROR}API returned error: %s$EOL" "$(jq ".reason" <<< "$DATA")" >&2
        RETURN_CODE=1
        return
    fi
    # printf "." >&2

    # Find the first and last index we want to display, as well as the index closest to the current time
    START_I=0
    END_I=0
    NOW_I=0
    MIN_TIME_DIFF=100000
    DATA_TIMESTAMPS=()
    i=0
    for ISO_GMT_TIME in $(jq -r '.hourly.time[]' <<< "$DATA"); do
        # if test $(($i % 5)) -eq 0; then
            # printf "." >&2
        # fi
        TIMESTAMP="$(date -d "$ISO_GMT_TIME+0000" "+%s")"
        DATA_TIMESTAMPS+=($TIMESTAMP)
        SECONDS_AFTER_CURRENT=$(($TIMESTAMP-$CURRENT_TIMESTAMP))
        if test $SECONDS_AFTER_CURRENT -lt $BEGIN_S; then
            START_I=$(($i+1))
        fi
        if test $SECONDS_AFTER_CURRENT -lt $END_S; then
            END_I=$i
        fi
        TIME_DIFF=${SECONDS_AFTER_CURRENT#-}
        if test $TIME_DIFF -lt $MIN_TIME_DIFF; then
            MIN_TIME_DIFF=$TIME_DIFF
            NOW_I=$i
        fi
        i=$(($i+1))
    done
    # printf "$EOL" >&2

    # Print the column labels at the top
    # LABEL_WIDTH=$(($BAR_WIDTH+8))
    # printf "          %-${LABEL_WIDTH}.${LABEL_WIDTH}s  " "Temperature (°F)"

    # Set needed variables before the loop
    # TEMP_NOW_10X=$(float_to_int $(jq ".hourly.temperature_2m[$NOW_I]" <<< "$DATA") 1)
    # TEMP_RANGE_10X=200
    # TEMP_MIN_10X=$((TEMP_NOW_10X - $TEMP_RANGE_10X))
    # TEMP_MAX_10X=$((TEMP_NOW_10X + $TEMP_RANGE_10X))
    SUNRISE_HOUR=$(date -d "$(jq -r ".daily.sunrise[0]" <<< "$DATA")+0000" "+%H")
    SUNSET_HOUR=$(date -d "$(jq -r ".daily.sunset[0]" <<< "$DATA")+0000" "+%H")
    # PREV_DAY_OF_WEEK=""

    # printf "%-${LABEL_WIDTH}.${LABEL_WIDTH}s\n" "Precipitation"

    # DATA_TEMP=($(jq -r ".hourly.temperature_2m[]" <<< "$DATA"))
    # DATA_PRECIP=($(jq -r ".hourly.precipitation_probability[]" <<< "$DATA"))
    # DATA_HUMID=($(jq -r ".hourly.relative_humidity_2m[]" <<< "$DATA"))
    # DATA_CODE=($(jq -r ".hourly.weather_code[$NOW_I]" <<< "$DATA"))

    TIMESTAMP=${DATA_TIMESTAMPS[$NOW_I]}
    # Calculate the number of seconds in the past or future this data point is
    SECONDS_AFTER_CURRENT=$(($TIMESTAMP-$CURRENT_TIMESTAMP))
    # The hour in 24-hour time
    HOUR_24="$(date -d "@$TIMESTAMP" "+%H")"

    if test $HOUR_24 -gt $SUNRISE_HOUR -a $HOUR_24 -le $SUNSET_HOUR; then
        DAYNIGHT=day
    else
        DAYNIGHT=night
    fi

    CURRENT_TEMP=($(jq -r ".current.temperature_2m" <<< "$DATA"))

    # WMO_CODE=${DATA_CODE[$i]}
    CURRENT_CODE=($(jq -r ".hourly.weather_code[$NOW_I]" <<< "$DATA"))
    DESCRIPTION=$(weather_code_to_description $CURRENT_CODE $DAYNIGHT)
    # printf "%5s° " "$TEMP"
    echo " $CURRENT_TEMP° "
}

# function show_help {
#     echo "weather.sh"
#     echo "Arguments:"
#     echo "  -h --help: show this help text and exit"
#     echo "  -c --coordinates: latitude and longitude coordinates in the form LAT,LON"
#     echo
#     echo "Persistent configuration can be set in $CONFIG_PATH"
#     echo "  tess_place_link: a tess.place share link, to get location from"
#     exit $RETURN_CODE
# }

if ! test -e "$CONFIG_PATH"; then
    echo "Creating config file $CONFIG_PATH..." >&2
    echo '{
    "tess_place_link": ""
}' > "$CONFIG_PATH"
fi
CONFIG_DATA="$(cat "$CONFIG_PATH")"

LATLON=""
while test $# -gt 0; do
    case $1 in
        -c|--coordinates)
            LATLON="$2"
            shift; shift
            ;;
        *)
            printf "${ERROR}Unknown argument %s$EOL" "$1" >&2
            RETURN_CODE=1
            shift
            ;;
    esac
done
if test $RETURN_CODE != 0; then
    show_help
    exit $RETURN_CODE
fi

function get_coords {
    TESS_PLACE_LINK="$(jq -r '.tess_place_link' <<< "$CONFIG_DATA")"
    if test ! -z $LATLON; then
        echo $LATLON
    elif test ! -z "$TESS_PLACE_LINK"; then
        # printf "${STATUS}Fetching coordinates from tess.place...$EOL" >&2
        URL=$(sed 's:/view/:/locations?t=:' <<< "$TESS_PLACE_LINK")
        DATA=$(curl -s "$URL")
        LAT="$(jq '.locations[0].lat' <<< "$DATA")"
        LON="$(jq '.locations[0].lon' <<< "$DATA")"
        echo "$LAT,$LON"
    else
        # printf "${STATUS}Fetching coordinates from ip-api...$EOL" >&2
        URL='http://ip-api.com/json/'
        DATA=$(curl -s "$URL")
        LAT="$(jq '.lat' <<< "$DATA")"
        LON="$(jq '.lon' <<< "$DATA")"
        echo "$LAT,$LON"
    fi
}

MAX_BAR_WIDTH=$((($(tput cols)-46)/2))
if test $BAR_WIDTH -gt $MAX_BAR_WIDTH; then
    BAR_WIDTH=$MAX_BAR_WIDTH
fi

show_forcast $(get_coords)
exit $RETURN_CODE
