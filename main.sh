#!/usr/bin/bash


GREEN="$(printf '\033[32m')"
WHITE="$(printf '\033[37m')" 


usage() {
    cat <<- EOF

		${GREEN}╺┳┓ ┏┏━┓┏┓╻┏━┓┏━┓${WHITE}┏┳┓┏━┓┏┳┓╻┏━╸
		${GREEN} ┃┃ ┃┣━┫┃┗┫┃ ┓┃ ┃${WHITE}┃┃┃┣━┫ ┃ ┃┃  
		${GREEN}╺┻┛┗┛╹ ╹╹ ╹┗━┛┗━┛${WHITE}╹ ╹╹ ╹ ╹ ╹┗━╸
		
		Djangomatic V1.0 : Generate Django project structure.
		Developed By     : Lirae Que Data (@WannaCry081)
			
		Usage : django [-h] [-m] [-r | -n] [project_name] [-g | -p] [repository_link]

		Options:
		   -h	Show this help message
		   -n	Use Django Ninja instead of Django Rest Framework
		   -m	Use MVT Architecture for the project template
		   -r	Use REST API for the project template
		   -g	Initialize version control
		   -p	Push project to a public repository
		   
	EOF

    cat <<- EOF
		Examples: 
		    django -r note_api     Create 'note_api' django API template
		    django -m todo_app -g  Create 'todo_app' django MVT and initialize git
		

	EOF
}


init_django_mvt() {
    local app_path="$1/app"
    local static_path="$1/static"
    local template_path="$1/templates"

    local directories=(
        "views" "models" "admin" 
        "forms" "tests" "utils"
    )

    django-admin startapp app || exit 1
    cd "$app_path" || exit 1

    rm "tests.py" "views.py" "admin.py" "models.py" || exit 1
    touch urls.py || exit 1

    for directory in "${directories[@]}"; do 
        mkdir "$app_path/$directory" && cd "$app_path/$directory" || exit 1
        touch "__init__.py" || exit 1
    done
        
    cd "$app_path" || exit 1
    mkdir "$template_path" || exit 1
    touch "$template_path/base.html"
    
    cd "$app_path" || exit 1
    mkdir "$static_path" || exit 1
    mkdir "$static_path/js" "$static_path/css" "$static_path/images" || exit 1 
}


init_django_rest() { 
    local root_dir="$(pwd)/$2"

    local venv_path="$root_dir/venv"
    local api_path="$root_dir/api"
    local v1_path="$api_path/v1"
    local config_path="$root_dir/config"

    local directories=(
        "models" "tests" "admin" "viewsets" 
        "serializers" "permissions" "utils"
    )

    echo "Initializing Django project..."

    mkdir -p "$root_dir" && cd "$root_dir" || exit 1

    virtualenv "$venv_path" || exit 1
    source "$venv_path/Scripts/activate" || exit 1

    pip install django djangorestframework \
                djangorestframework-simplejwt \
                django-cors-headers \
                drf-yasg pydantic \
                python-dotenv || exit 1

    pip freeze > requirements.txt || exit 1
    touch README.md .gitignore .dockerignore Dockerfile || exit 1

    echo -e "*.db\n*.sqlite3\n**/__pycache\n/venv" > .gitignore || exit 1
    
    django-admin startproject config . || exit 1
    cd "$config_path" || exit 1

    mkdir "settings" && mv settings.py "settings/base.py" || exit 1
    cd "settings" || exit 1
    touch "__init__.py" "local.py" "production.py" || exit 1

    cd "$root_dir" || exit 1
    mkdir "$api_path" && cd "$api_path" || exit 1
    touch "__init__.py" || exit 1
    django-admin startapp "v1" || exit 1
    cd "$v1_path" || exit 1
    rm "tests.py" "views.py" "admin.py" "models.py" || exit 1
    touch urls.py || exit 1

    for directory in "${directories[@]}"; do 
        mkdir "$v1_path/$directory" && cd "$v1_path/$directory" || exit 1
        touch "__init__.py" || exit 1
    done

    cd "$root_dir" || exit 1

    if [ "$1" = true ]; then 
        init_django_mvt "$root_dir"
    fi
    deactivate
}


init_django() {
    local root_dir="$(pwd)/$2"

    local venv_path="$root_dir/venv"
    local api_path="$root_dir/api"
    local v1_path="$api_path/v1"
    local config_path="$root_dir/config"

    local directories="$3"

    echo "Initializing Django project..."

    mkdir -p "$root_dir" && cd "$root_dir" || exit 1

    virtualenv "$venv_path" || exit 1
    source "$venv_path/Scripts/activate" || exit 1

    pip install django python-dotenv \
                django-cors-headers "$4" || exit 1

    pip freeze > requirements.txt || exit 1
    touch README.md .gitignore .dockerignore Dockerfile || exit 1

    echo -e "*.db\n*.sqlite3\n**/__pycache\n/venv" > .gitignore || exit 1
    
    django-admin startproject config . || exit 1
    cd "$config_path" || exit 1

    mkdir "settings" && mv settings.py "settings/base.py" || exit 1
    cd "settings" || exit 1
    touch "__init__.py" "local.py" "production.py" || exit 1

    cd "$root_dir" || exit 1
    mkdir "$api_path" && cd "$api_path" || exit 1
    touch "__init__.py" || exit 1
    django-admin startapp "v1" || exit 1
    cd "$v1_path" || exit 1
    rm "tests.py" "views.py" "admin.py" "models.py" || exit 1
    touch urls.py || exit 1

    for directory in "${directories[@]}"; do 
        mkdir "$v1_path/$directory" && cd "$v1_path/$directory" || exit 1
        touch "__init__.py" || exit 1
    done

    cd "$root_dir" || exit 1

    if [ "$1" = true ]; then 
        init_django_mvt "$root_dir"
    fi
    deactivate
}


init_git() {
    echo "Initializing Git..."
}


main() {
    local h_flag=false
    local m_flag=false
    local n_flag=false
    local r_flag=false
    local g_flag=false
    local p_flag=false
    local cmd_line="${GREEN}djm${WHITE}"

    clear && usage

    while [ true ]; do
        read -p "$cmd_line > " command args

        if [ -n "$args" ] && [ "$command" = "django" ]; then

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
            
            if [ "$h_flag" = true ]; then 
                usage
                continue
            fi

            if [ "$r_flag" = true ] && [ -n "$project_name" ]; then  
                init_django "$m_flag" \
                            "$project_name" \
                            ("models" "tests" "admin" "viewsets" "serializers" "permissions" "utils") \
                            "djangorestframework djangorestframework-simplejwt drf-yasg"

                if [ "$g_flag" = true ] || [ "$p_flag" = true ]; then 
                    init_git "$p_flag" "$repository_link"
                fi
                continue
            fi

            if [ "$n_flag" = true ]; then 
                init_django "$m_flag" \
                            "$project_name" \
                            ("models" "tests" "admin" "controllers" "services" "repositories" "utils" "exceptions" "schemas") \
                            "django-ninja-extra"
                if [ "$g_flag" = true ] || [ "$p_flag" = true ]; then 
                    init_git "$p_flag" "$repository_link"
                fi
                continue
            fi

        elif [ -n "$command" ]; then
            if [ "$command" = "exit" ]; then 
                echo "Happy Hacking!"
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


main