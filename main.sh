#!/usr/bin/bash

echo -e '\n'
echo ' /$$$$$$$                                                                        /$$     /$$              '
echo '| $$__  $$                                                                      | $$    |__/              '
echo '| $$  \ $$ /$$  /$$$$$$  /$$$$$$$   /$$$$$$   /$$$$$$  /$$$$$$/$$$$   /$$$$$$  /$$$$$$   /$$  /$$$$$$$    '
echo '| $$  | $$|__/ |____  $$| $$__  $$ /$$__  $$ /$$__  $$| $$_  $$_  $$ |____  $$|_  $$_/  | $$ /$$_____/    '
echo '| $$  | $$ /$$  /$$$$$$$| $$  \ $$| $$  \ $$| $$  \ $$| $$ \ $$ \ $$  /$$$$$$$  | $$    | $$| $$          '
echo '| $$  | $$| $$ /$$__  $$| $$  | $$| $$  | $$| $$  | $$| $$ | $$ | $$ /$$__  $$  | $$ /$$| $$| $$          '
echo '| $$$$$$$/| $$|  $$$$$$$| $$  | $$|  $$$$$$$|  $$$$$$/| $$ | $$ | $$|  $$$$$$$  |  $$$$/| $$|  $$$$$$$    '
echo '|_______/ | $$ \_______/|__/  |__/ \____  $$ \______/ |__/ |__/ |__/ \_______/   \___/  |__/ \_______/    '
echo '     /$$  | $$                     /$$  \ $$                                                              '
echo '    |  $$$$$$/                    |  $$$$$$/                                                              '
echo '     \______/                      \______/                                                               '
echo -e '\n'

read -p "Enter projec name: " project_name

project_path="$(pwd)/$project_name"
env_path="$project_path/venv"

mkdir "$project_path" && cd "$project_path"
virtualenv "$env_path" && source "$env_path/Scripts/activate"
pip install django djangorestframework drf-yasg django-cors-headers
pip freeze > requirements.txt
touch .env 
touch .gitignore
touch .dockerignore
touch README.md
touch Dockerfile

django-admin startproject config .  && cd config 
mkdir settings && mv settings.py settings/base.py && cd settings
touch __init__.py 
touch local.py
touch production.py
cd ../..

mkdir api && cd api && touch __init__.py 
django-admin startapp v1 && cd v1
rm tests.py
rm models.py 
rm admin.py
rm views.py
mkdir models && cd models && touch __init__.py && cd ..
mkdir tests && cd tests && touch __init__.py && cd ..
mkdir admin && cd admin && touch __init__.py && cd ..
mkdir viewsets && cd viewsets && touch __init__.py && cd ..
mkdir serializers && cd serializers && touch __init__.py && cd ..
mkdir permissions && cd permissions && touch __init__.py && cd ..
cd "$project_path"

git init 
git branch -M main 
git add .
git commit -m "Initial commit"
git checkout -b develop
deactivate