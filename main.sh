#!/usr/bin/bash


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


init_git() {
    echo "Initializing Git..."
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

    local project_path="$(pwd)/$project_name"

    init_django "$project_path"

}


main