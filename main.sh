#!/usr/bin/bash


init_django() {

}

main() {

    until [ -n "$project_name" ]; do
        clear

        read -p "Enter project name: " project_name

        if [ -z "$project_name" ]; then 
            read -p "Do you want to continue? [Y/n] " yn
            if [[ "$yn" = [Nn]* ]]; then 
                exit 0
            fi
        fi
    done



}


main