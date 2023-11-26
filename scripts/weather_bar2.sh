#!/bin/bash

# Color codes
NORMAL="\x1b[0m"
STATUS="\x1b[34m"
ERROR="\x1b[31m"
EOL="$NORMAL\n"

# Generates a 24-bit forground color code (R=$2 G=$3 B=$4)
# function color {
#     printf "\x1b[38;2;$1;$2;$3m"
# }

# 🌒☀️ 

function weather_code_to_description {
    # A lot of the emojis need an extra space after them to print correctly on my terminal. Might be something to do with a variation selector
    case $1 in
        0) if test $2 == night; then
                printf "🌒 Clear"
            else
                printf "☀️ Sunny"
            fi;;
        1) if test $2 == night; then
                printf "🌃 Mostly clear"
            else
                printf "🌇 Mostly sunny"
            fi;;
        2) if test $2 == night; then
                printf "☁️ Partly cloudy"
            else
                printf "⛅ Partly cloudy"
            fi;;
        3) printf "☁️ Cloudy";;
        14|15|16) printf "🌧️ Distant rain";;
        50|51|52) printf "🌧️ Slight drizzle";;
        20|53|54|55) printf "🌧️ Drizzle";;
        58|60|61|62|80|91) printf "🌧️ Slightly rainy";;
        59|21|25|63|64|81|82|92) printf "🌧️ Rainy";;
        65) printf "🌧️ Raining cats and dogs";;
        56|57) printf "🌨️ Freezing drizzle";;
        23|24|26|66|67|68|69|83|84|93|94) printf "🌨️ Freezing rain";;
        70|71|72|85) printf "❄️ Slightly snowy";;
        22|36|37|38|39|73|74|75|86) printf "❄️ Snowy";;
        27|87|88|89|90) printf "🌨️ Hailing";;
        76|77|78|79) printf "🌨️ Wintry";;
        13) printf "⛈️ Lightning";;
        17|29|95|97|98) printf "⛈️ Thunderstorms";;
        96|99) printf "⛈️ Thunderstorms and hailing";;
        11) printf "🌫️ Slightly foggy";;
        12|28|40|41|42|43|44|45|46|47|48|49) printf "🌫️ Foggy";;
        4) printf "💨 Smoky";;
        5) printf "🌫️ Hazy";;
        10) printf "🌫️ Misty";;
        6|7|8|9) printf "🌬️ Dusty";;
        30|31|32) printf "🌬️ Duststorm";;
        33|34|35) printf "🌬️ Severe duststorm";;
        18) printf "🌪️ Squalls";;
        19) printf "🌪️ Tornado clouds";;
        *) printf "";;
    esac
}

# URL='http://ip-api.com/json/'
LOCAL=$(curl -s "http://ip-api.com/json/")
LAT="$(jq '.lat' <<< "$LOCAL")"
LON="$(jq '.lon' <<< "$LOCAL")"

# dynamic LAT, LON
URL="https://api.open-meteo.com/v1/forecast?latitude=$LAT&longitude=$LON&current=temperature_2m,relative_humidity_2m&hourly=weather_code&daily=temperature_2m_max,temperature_2m_min,sunrise,sunset,precipitation_sum,rain_sum,precipitation_probability_max&temperature_unit=fahrenheit&timezone=GMT&forecast_days=1"
# echo "URL: $URL" >&2
DATA=$(curl -s "$URL")

CURRENT_TIMESTAMP="$(date "+%s")"
# Find the first and last index we want to display, as well as the index closest to the current time
START_I=0
END_I=0
NOW_I=0
MIN_TIME_DIFF=100000
DATA_TIMESTAMPS=()
i=0
for ISO_GMT_TIME in $(jq -r '.hourly.time[]' <<< "$DATA"); do
    TIMESTAMP="$(date -d "$ISO_GMT_TIME+0000" "+%s")"
    DATA_TIMESTAMPS+=($TIMESTAMP)
    SECONDS_AFTER_CURRENT=$(($TIMESTAMP-$CURRENT_TIMESTAMP))
    TIME_DIFF=${SECONDS_AFTER_CURRENT#-}
    if test $TIME_DIFF -lt $MIN_TIME_DIFF; then
        MIN_TIME_DIFF=$TIME_DIFF
        NOW_I=$i
    fi
    i=$(($i+1))
done

SUNRISE_HOUR=$(date -d "$(jq -r ".daily.sunrise[0]" <<< "$DATA")+0000" "+%H")
SUNSET_HOUR=$(date -d "$(jq -r ".daily.sunset[0]" <<< "$DATA")+0000" "+%H")

TIMESTAMP=${DATA_TIMESTAMPS[$NOW_I]}
# Calculate the number of seconds in the past or future this data point is
# SECONDS_AFTER_CURRENT=$(($TIMESTAMP-$CURRENT_TIMESTAMP))
# The hour in 24-hour time
HOUR_24="$(date -d "@$TIMESTAMP" "+%H")"

if test $HOUR_24 -gt $SUNRISE_HOUR -a $HOUR_24 -le $SUNSET_HOUR; then
    DAYNIGHT=day
else
    DAYNIGHT=night
fi

TODAY_MIN=($(jq -r ".daily.temperature_2m_min[0]" <<< "$DATA"))
TODAY_MAX=($(jq -r ".daily.temperature_2m_max[0]" <<< "$DATA"))
TODAY_PRECIP_PROB_MAX=($(jq -r ".daily.precipitation_probability_max[0]" <<< "$DATA"))

CURRENT_TEMP=($(jq -r ".current.temperature_2m" <<< "$DATA"))
CURRENT_HUMID=($(jq -r ".current.relative_humidity_2m" <<< "$DATA"))

# WMO_CODE=${DATA_CODE[$i]}
CURRENT_CODE=($(jq -r ".hourly.weather_code[$NOW_I]" <<< "$DATA"))
DESCRIPTION=$(weather_code_to_description $CURRENT_CODE $DAYNIGHT)

# echo " $SUNRISE_HOUR $SUNSET_HOUR $DAYNIGHT $CURRENT_TEMP° $CURRENT_HUMID% $DESCRIPTION "
# echo " $CURRENT_TEMP° $CURRENT_HUMID% $DESCRIPTION "
if test $# -gt 0; then
    case $1 in
        -l) echo "$CURRENT_TEMP° $CURRENT_HUMID% ~$TODAY_PRECIP_PROB_MAX% $DESCRIPTION $TODAY_MIN $TODAY_MAX"
    esac
else
    echo " $CURRENT_TEMP° $CURRENT_HUMID% ~$TODAY_PRECIP_PROB_MAX% $DESCRIPTION "
fi

