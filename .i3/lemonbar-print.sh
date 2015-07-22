#!/usr/bin/bash

# Define the clock
Clock() {
        DATE=$(date "+%a %b %d, %T")

        echo -n "$DATE"
}



#Define the battery
Battery() {
        BATPERC=$(acpi --battery | cut -d, -f2)
        echo "$BATPERC"
}

# Print the clock

while true; do
        echo "%{c}%{Fyellow}%{Bblue} $(Clock)%{F-} | %{r}$(Battery)"
        sleep 1;
done
