for i in {0..255}; do
    printf "\e[48;5;${i}m%3d " "${i}"
    if (( (i + 1) % 16 == 0 )); then
        echo;
    fi
done
