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

		Usage: django [-h] [-m (optional)] [-m | -r | -n] <project_name> 
                      [-g | -p (optional)] <repository_link>

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
		    django -m todo-list
		    django -r todo-list          
		    django -n todo-list -g        
		    django -n todo-list -p https://github.com/sample/

		    django -m -n todo-list -g 
		    django -m -r todo-list -p https://github.com/sample/


	EOF
}


# Initialize Django project with MVT (Model-View-Template) architecture
init_django_mvt() {
    local root_dir="$(pwd)"
    local venv_dir="$root_dir/venv"
    local app_dir="$root_dir/app"
    local static_dir="$root_dir/static"
    local templates_dir="$root_dir/templates"

    # Directories to create within the app directory
    local directories=(
        "views" "models" "admin" 
        "forms" "tests" "utils"
    )

    # Start setup
    echo -e "${GREEN}Initializing Django MVT app. Please wait...${WHITE}"

    # Changing current location to root directory
    cd "$root_dir" || exit 1
    
    # Activating virtual environment
    source "$venv_dir/Scripts/activate" || exit 1
    
    # Create Django app and necessary directories
    django-admin startapp app || exit 1
    cd "$app_dir" || exit 1

    # Remove unnecessary files and create urls.py
    rm "tests.py" "views.py" "admin.py" "models.py" || exit 1
    touch urls.py || exit 1

    # Create required directories and __init__.py files
    for directory in "${directories[@]}"; do 
        mkdir "$app_dir/$directory" && cd "$app_dir/$directory" || exit 1
        touch "__init__.py" || exit 1
    done

    # Create template directory and base.html file
    cd "$app_dir" || exit 1
    mkdir "$templates_dir" || exit 1
    touch "$templates_dir/base.html"

    # Create static directories for CSS, JS, and images
    cd "$app_dir" || exit 1
    mkdir "$static_dir" || exit 1
    mkdir "$static_dir/js" "$static_dir/css" "$static_dir/images" || exit 1 

    # Deactivate virtual environment
    deactivate

    # Finish setup
    echo -e "${GREEN}MVT app setup completed successfully.${WHITE}"
    cd "$root_dir" || exit 1
}


# Initialize Django project with Rest API architecture
init_django_api() {
    local root_dir="$(pwd)"
    local venv_dir="$root_dir/venv"
    local api_dir="$root_dir/api"
    local v1_dir="$api_dir/v1"
    local directories=($1)

    # Start setup
    echo -e "${GREEN}Initializing Django project. Please wait...${WHITE}\n"

    # Changing current location to root directory
    cd "$root_dir" || exit 1

    # Activating virtual environment
    source "$venv_dir/Scripts/activate" || exit 1

    # Install required packages
    pip install $2 || exit 1

    # Update installed packages to requirements.txt
    pip freeze > requirements.txt || exit 1

    # Create API app and required directories
    mkdir "$api_dir" && cd "$api_dir" || exit 1
    touch "__init__.py" || exit 1
    django-admin startapp "v1" || exit 1
    cd "$v1_dir" || exit 1
    rm "tests.py" "views.py" "admin.py" "models.py" || exit 1
    touch urls.py || exit 1

    # Create additional directories within API app
    for directory in "${directories[@]}"; do 
        mkdir "$v1_dir/$directory" && cd "$v1_dir/$directory" || exit 1
        touch "__init__.py" || exit 1
    done

    # Deactivate virtual environment
    deactivate

    # Finish setup
    echo -e "\n${GREEN}REST API setup completed successfully.${WHITE}"
    cd "$root_dir" || exit 1
}


# Initialize Django project
init_django() {
    local root_dir="$(pwd)/$1"
    local venv_dir="$root_dir/venv"
    local config_dir="$root_dir/config"

    echo -e "${GREEN}Initializing Django project. Please wait...\n${WHITE}"

    # Create project directory
    mkdir -p "$root_dir" && cd "$root_dir" || exit 1

    # Create virtual environment
    virtualenv "$venv_dir" || exit 1
    source "$venv_dir/Scripts/activate" || exit 1

    # Install required packages
    pip install django python-dotenv django-cors-headers || exit 1

    # Save installed packages to requirements.txt
    pip freeze > requirements.txt || exit 1

    # Initialize gitignore file
    touch README.md .gitignore .dockerignore Dockerfile .env || exit 1
    echo -e ".env\n*.db\n*.sqlite3\n**/__pycache\n/venv" > .gitignore || exit 1

    # Create Django project
    django-admin startproject config . || exit 1
    cd "$config_dir" || exit 1

    # Organize Django settings
    mkdir "settings" && mv settings.py "settings/base.py" || exit 1
    cd "settings" || exit 1
    touch "__init__.py" "local.py" "production.py" || exit 1

    # Deactivate virtual environment
    deactivate

    # Finish setup
    echo -e "\n${GREEN}Project setup completed successfully.${WHITE}"
    cd "$root_dir" || exit 1
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
    local root_dir="$(pwd)"
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

        cd "$root_dir" || exit 1

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
            elif [ "$r_flag" = true ] && [ "$n_flag" = true ]; then 
                echo "${RED}Error: Conflicting options. Use either -r or -n.${WHITE}"
                continue
            elif [ "$g_flag" = true ] && [ "$p_flag" = true ]; then 
                echo "${RED}Error: Conflicting options. Use either -g or -p.${WHITE}"
                continue
            elif [ -z "$project_name" ]; then 
                echo "${RED}Error: Missing project name option.${WHITE}"
                continue
            fi

            init_django "$project_name"

            if [ "$m_flag" = true ]; then 
                init_django_mvt
            fi 

            # Initialize Django project based on flags
            if [ "$r_flag" = true ]; then  
                init_django_api "models tests admin viewsets serializers permissions utils" \
                                "djangorestframework djangorestframework-simplejwt drf-yasg"

                if [ "$g_flag" = true ] || [ "$p_flag" = true ]; then 
                    init_git "$p_flag" "$repository_link"
                fi
                continue             
            fi

            # Initialize Django Ninja project based on flags
            if [ "$n_flag" = true ]; then 
                init_django_api "models tests admin controllers services repositories utils exceptions schemas" \
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