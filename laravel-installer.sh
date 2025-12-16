#!/bin/bash

clear
echo "======================================"
echo "   Laravel SSH Installer & Setup"
echo "======================================"
echo ""

PROJECT_DIR=$(pwd)

pause() {
  read -p "Tekan ENTER untuk lanjut..."
}

clone_repo() {
  echo ""
  read -p "Masukkan URL GitHub repo: " REPO_URL

  TEMP_DIR=".tmp_repo_clone"

  if [ -d "$TEMP_DIR" ]; then
    rm -rf "$TEMP_DIR"
  fi

  echo ""
  echo "▶ Cloning repository ke folder sementara..."
  git clone "$REPO_URL" "$TEMP_DIR"

  if [ $? -ne 0 ]; then
    echo "❌ Gagal clone repository"
    pause
    return
  fi

  echo "▶ Memindahkan file ke directory saat ini..."

  shopt -s dotglob
  mv "$TEMP_DIR"/* .
  shopt -u dotglob

  rm -rf "$TEMP_DIR"

  echo "✅ Repository berhasil di-clone ke directory aktif"
  pause
}


install_laravel_menu() {
  echo ""
  echo "Pilih tipe instalasi:"
  echo "1. Laravel Standar"
  echo "2. Laravel + Vite"
  echo "0. Kembali"
  echo ""
  read -p "Pilihan: " INSTALL_CHOICE

  case $INSTALL_CHOICE in
    1)
      echo "▶ Install Laravel Standar"
      composer install
      cp .env.example .env
      php artisan key:generate
      echo "✅ Laravel Standar selesai"
      ;;
    2)
      echo "▶ Install Laravel + Vite"
      composer install
      npm install
      cp .env.example .env
      php artisan key:generate
      npm run build
      echo "✅ Laravel + Vite selesai"
      ;;
    0)
      return
      ;;
    *)
      echo "❌ Pilihan tidak valid"
      ;;
  esac
  pause
}

setup_htaccess() {
  echo "▶ Setup .htaccess redirect ke public"
  cat > .htaccess <<EOL
<IfModule mod_rewrite.c>
RewriteEngine On

RewriteCond %{REQUEST_URI} !/public
RewriteRule ^(.*)$ public/\$1 [L]

</IfModule>
EOL
  echo "✅ .htaccess berhasil dibuat"
  pause
}

setup_env_database() {
  if [ ! -f .env ]; then
    echo "❌ File .env belum ada"
    pause
    return
  fi

  echo "▶ Setup Database di .env"
  read -p "DB_HOST [127.0.0.1]: " DB_HOST
  read -p "DB_PORT [3306]: " DB_PORT
  read -p "DB_DATABASE: " DB_DATABASE
  read -p "DB_USERNAME: " DB_USERNAME
  read -s -p "DB_PASSWORD: " DB_PASSWORD
  echo ""

  DB_HOST=${DB_HOST:-127.0.0.1}
  DB_PORT=${DB_PORT:-3306}

  sed -i "s/^DB_HOST=.*/DB_HOST=$DB_HOST/" .env
  sed -i "s/^DB_PORT=.*/DB_PORT=$DB_PORT/" .env
  sed -i "s/^DB_DATABASE=.*/DB_DATABASE=$DB_DATABASE/" .env
  sed -i "s/^DB_USERNAME=.*/DB_USERNAME=$DB_USERNAME/" .env
  sed -i "s/^DB_PASSWORD=.*/DB_PASSWORD=$DB_PASSWORD/" .env

  echo "✅ Database .env berhasil diset"
  pause
}

migrate_menu() {
  echo ""
  echo "Pilih migrasi database:"
  echo "1. php artisan migrate --seed"
  echo "2. php artisan migrate:fresh --seed"
  echo "0. Kembali"
  echo ""
  read -p "Pilihan: " MIGRATE_CHOICE

  case $MIGRATE_CHOICE in
    1)
      php artisan migrate --seed
      ;;
    2)
      php artisan migrate:fresh --seed
      ;;
    0)
      return
      ;;
    *)
      echo "❌ Pilihan tidak valid"
      ;;
  esac
  pause
}

while true; do
  clear
  echo "======================================"
  echo " Laravel SSH Installer Menu"
  echo " Directory: $PROJECT_DIR"
  echo "======================================"
  echo "1. Clone GitHub Repository"
  echo "2. Install & Setup Laravel"
  echo "3. Setup .htaccess (redirect public)"
  echo "4. Setup Database (.env)"
  echo "5. Migrate Database"
  echo "0. Exit"
  echo ""
  read -p "Pilih menu: " MENU

  case $MENU in
    1) clone_repo ;;
    2) install_laravel_menu ;;
    3) setup_htaccess ;;
    4) setup_env_database ;;
    5) migrate_menu ;;
    0)
      echo "👋 Keluar..."
      exit 0
      ;;
    *)
      echo "❌ Menu tidak valid"
      pause
      ;;
  esac
done
