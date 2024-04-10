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


init_django() { 
    local root_dir="$1"

    local venv_path="$root_dir/venv"
    local config_path="$root_dir/config"
    local api_path="$root_dir/api"
    local v1_path="$api_path/v1"

    local directories=(
        "models" "tests" "admin" "viewsets" 
        "serializers" "permissions"
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

    for directory in "${directories[@]}"; do 
        mkdir "$v1_path/$directory" && cd "$v1_path/$directory" || exit 1
        touch "__init__.py" || exit 1
    done

    cd "$root_dir" || exit 1
    deactivate
}

usage() {
    clear

    cat <<- EOF

		${GREEN}╺┳┓ ┏┏━┓┏┓╻┏━┓┏━┓${WHITE}┏┳┓┏━┓┏┳┓╻┏━╸
		${GREEN} ┃┃ ┃┣━┫┃┗┫┃ ┓┃ ┃${WHITE}┃┃┃┣━┫ ┃ ┃┃  
		${GREEN}╺┻┛┗┛╹ ╹╹ ╹┗━┛┗━┛${WHITE}╹ ╹╹ ╹ ╹ ╹┗━╸
		
		Djangomatic V1.0 : Generate Django project structure.
		Developed By     : Lirae Que Data (@WannaCry081)
			
		Usage : django [-h] [-m | -r | -n | -mr] [project_name] [-g] [-p] [repository_link]

		Options:
		   -h	Show this help message
		   -n	Use Django Ninja instead of Django Rest Framework
		   -m	Use MVT Architecture for the project template
		   -r	Use REST API for the project template
		   -mr	Use both MVT and REST for the project template
		   -g	Initialize version control
		   -p	Push project to a public repository
		   
	EOF

    cat <<- EOF
		Examples: 
		    django -r note_api     Create 'note_api' django API template
		    django -m todo_app -g  Create 'todo_app' django MVT and initialize git
		

	EOF
}


init_git() {
    echo "Initializing Git..."
}


main() {

    local tool_line="${GREEN}djm${WHITE}"

    until [ -n "$project_name" ]; do
        usage
        read -p "${tool_line} > " project_name

        if [ -z "$project_name" ]; then 
            read -p "${tool_line} Do you want to continue? [Y/n] " yn
            if [[ "$yn" = [Nn]* ]]; then 
                exit 0
            fi
        fi
    done

    local project_path="$(pwd)/$project_name"

    init_django "$project_path"

}


main