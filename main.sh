#!/usr/bin/bash


## Author : Lirae Que Data (@WannaCry081)
## Mail   : liraedata59@gmail.com
## Github : @WannaCry081


## ANSI Colors (FG & BG)
RED="$(printf '\033[31m')"        GREEN="$(printf '\033[32m')"
ORANGE="$(printf '\033[33m')"     BLUE="$(printf '\033[34m')"
MAGENTA="$(printf '\033[35m')"    CYAN="$(printf '\033[36m')"
WHITE="$(printf '\033[37m')"      BLACK="$(printf '\033[30m')"
REDBG="$(printf '\033[41m')"      GREENBG="$(printf '\033[42m')"
ORANGEBG="$(printf '\033[43m')"   BLUEBG="$(printf '\033[44m')"
MAGENTABG="$(printf '\033[45m')"  CYANBG="$(printf '\033[46m')"
WHITEBG="$(printf '\033[47m')"    BLACKBG="$(printf '\033[40m')"


usage() {
    cat <<- EOF

		${GREEN}╺┳┓ ┏┏━┓┏┓╻┏━┓┏━┓${WHITE}┏┳┓┏━┓┏┳┓╻┏━╸
		${GREEN} ┃┃ ┃┣━┫┃┗┫┃ ┓┃ ┃${WHITE}┃┃┃┣━┫ ┃ ┃┃  
		${GREEN}╺┻┛┗┛╹ ╹╹ ╹┗━┛┗━┛${WHITE}╹ ╹╹ ╹ ╹ ╹┗━╸

		Djangomatic v1.0 : Generate django project structure.
		Developed By     : Lirae Que Data (@WannaCry081)

		Usage: django [-h] [-m (optional)] [-r | -n] [project_name] 
                      [-g | -p (optional)] [repository_link (optional)]

		Options:
		   -h	Display the help view
		   -m	Utilize the MVT (Model-View-Template)
		        architecture for the project template

		   -n	Use Django Ninja instead of Django Rest Framework
		   -r	Utilize REST API for the project template
		   -g	Initialize version control
		   -p	Push the project to a public repository

	EOF

    cat <<- EOF
		Examples: 
		    django -r note-app          Creates a django Rest API template
		    django -m -n ecommerce -g   Creates a django MVT + Ninja and initialize git
		    django -r todolist -p link  Creates a django Rest API and push it to GitHub


	EOF
}


# Initialize Django project with MVT (Model-View-Template) architecture
init_django_mvt() {
    local app_path="$1/app"
    local static_path="$1/static"
    local template_path="$1/templates"

    # Directories to create within the app directory
    local directories=(
        "views" "models" "admin" 
        "forms" "tests" "utils"
    )

    # Create Django app and necessary directories
    django-admin startapp app || exit 1
    cd "$app_path" || exit 1

    # Remove unnecessary files and create urls.py
    rm "tests.py" "views.py" "admin.py" "models.py" || exit 1
    touch urls.py || exit 1

    # Create required directories and __init__.py files
    for directory in "${directories[@]}"; do 
        mkdir "$app_path/$directory" && cd "$app_path/$directory" || exit 1
        touch "__init__.py" || exit 1
    done

    # Create template directory and base.html file
    cd "$app_path" || exit 1
    mkdir "$template_path" || exit 1
    touch "$template_path/base.html"

    # Create static directories for CSS, JS, and images
    cd "$app_path" || exit 1
    mkdir "$static_path" || exit 1
    mkdir "$static_path/js" "$static_path/css" "$static_path/images" || exit 1 
}

init_api() {
    
}


# Initialize Django project
init_django() {
    local root_dir="$(pwd)/$2"
    local venv_path="$root_dir/venv"
    local api_path="$root_dir/api"
    local v1_path="$api_path/v1"
    local config_path="$root_dir/config"
    local directories=($3)

    echo -e "Initializing Django project. Please wait...\n"

    # Create project directory
    mkdir -p "$root_dir" && cd "$root_dir" || exit 1

    # Create virtual environment
    virtualenv "$venv_path" || exit 1
    source "$venv_path/Scripts/activate" || exit 1

    # Install required packages
    pip install django python-dotenv \
                django-cors-headers $4 || exit 1

    # Save installed packages to requirements.txt
    pip freeze > requirements.txt || exit 1

    # Initialize gitignore file
    touch README.md .gitignore .dockerignore Dockerfile .env || exit 1
    echo -e ".env\n*.db\n*.sqlite3\n**/__pycache\n/venv" > .gitignore || exit 1

    # Create Django project
    django-admin startproject config . || exit 1
    cd "$config_path" || exit 1

    # Organize Django settings
    mkdir "settings" && mv settings.py "settings/base.py" || exit 1
    cd "settings" || exit 1
    touch "__init__.py" "local.py" "production.py" || exit 1

    # Create API app and required directories
    cd "$root_dir" || exit 1
    mkdir "$api_path" && cd "$api_path" || exit 1
    touch "__init__.py" || exit 1
    django-admin startapp "v1" || exit 1
    cd "$v1_path" || exit 1
    rm "tests.py" "views.py" "admin.py" "models.py" || exit 1
    touch urls.py || exit 1

    # Create additional directories within API app
    for directory in "${directories[@]}"; do 
        mkdir "$v1_path/$directory" && cd "$v1_path/$directory" || exit 1
        touch "__init__.py" || exit 1
    done

    # If MVT architecture is chosen, initialize MVT structure
    cd "$root_dir" || exit 1
    if [ "$1" = true ]; then 
        init_django_mvt "$root_dir"
    fi

    # Finish setup
    cd "$root_dir" || exit 1
    echo -e "\n${GREEN}Project setup completed successfully. Happy coding!${WHITE}"
    deactivate
}


# Initialize Git repository and optionally push to a remote repository
init_git() {
    echo -e "Initializing Git repository...\n"

    # Initialize local Git repository
    git init 
    git add . 
    git commit -m 'Initial commit'
    git branch -M main

    # Check if pushing to a remote repository is requested
    if [ "$1" = true ]; then
        # Check if the repository link is valid
        if curl --output /dev/null --silent --head --fail "$2"; then
            echo -e "\nPushing project to the repository...\n"
            git remote add origin "$2"
            git push -u origin main
        else
            echo -e "\n${RED}Repository link does not exist or is inaccessible.${WHITE}"
        fi
    fi

    # Create and checkout 'develop' branch
    git checkout -b develop
    echo -e "\n${GREEN}Git operations completed.${WHITE}"
}


# Main function to handle Djangomatic commands and operations
main() {
    local h_flag=false
    local m_flag=false
    local n_flag=false
    local r_flag=false
    local g_flag=false
    local p_flag=false
    local project_name=""
    local repository_link=""
    local cmd_line="${GREEN}djm${WHITE}"

    clear && usage

    # Loop to continuously process user input
    while [ true ]; do

        unset h_flag
        unset m_flag
        unset n_flag
        unset r_flag
        unset g_flag
        unset p_flag
        unset project_name
        unset repository_link
        
        read -p "$cmd_line > " command args

        # Process 'django' command
        if [ -n "$args" ] && [ "$command" = "django" ]; then

            # Parse command arguments
            IFS=' ' read -r -a parts <<< "$args"
            for arg in "${parts[@]}"; do
                case "$arg" in
                    -h)
                        h_flag=true
                        ;;
                    -m)
                        m_flag=true
                        ;;
                    -r)
                        r_flag=true
                        ;;
                    -n)
                        n_flag=true
                        ;;
                    -g)
                        g_flag=true
                        ;;
                    -p)
                        p_flag=true
                        ;;
                    *)
                        if [ -z "$project_name" ]; then
                            project_name="$arg"
                        elif [ -z "$repository_link" ]; then
                            repository_link="$arg"
                        fi
                        ;;
                esac
            done
            
            # Display help message and continue loop if -h flag is set
            if [ "$h_flag" = true ]; then 
                usage
                continue
            fi

            if [ -z "$project_name" ]; then 
                echo "${RED}Error: Missing project name option.${WHITE}"
                continue
            fi

            # Initialize Django project based on flags
            if [ "$r_flag" = true ]; then  
                if [ "$n_flag" = true ]; then
                    echo "${RED}Error: Conflicting options. Use either -r or -n.${WHITE}"
                    continue
                fi

                init_django "$m_flag" \
                            "$project_name" \
                            "models tests admin viewsets serializers permissions utils" \
                            "djangorestframework djangorestframework-simplejwt drf-yasg"

                if [ "$g_flag" = true ] || [ "$p_flag" = true ]; then 
                    init_git "$p_flag" "$repository_link"
                fi
                continue             
            fi

            # Initialize Django Ninja project based on flags
            if [ "$n_flag" = true ]; then 
                init_django "$m_flag" \
                            "$project_name" \
                            "models tests admin controllers services repositories utils exceptions schemas" \
                            "django-ninja-extra" 

                if [ "$g_flag" = true ] || [ "$p_flag" = true ]; then 
                    init_git "$p_flag" "$repository_link"
                fi
                continue
            fi

        # Process other commands
        elif [ -n "$command" ]; then
            if [ "$command" = "exit" ]; then 
                echo "${GREEN}Happy Hacking!"
                exit 0
            elif [ "$command" = "clear" ]; then 
                clear 
            elif [[ "$command" = "help" || "$command" = "django" ]]; then 
                usage
            else
                echo "$cmd_line: $command: command not found"
            fi
        fi 
    done
}

# Invoke the main function
main