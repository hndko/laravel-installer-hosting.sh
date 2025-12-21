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

storage_link() {
  echo ""
  echo "▶ Membuat symbolic link storage..."
  php artisan storage:link
  echo "✅ Storage link berhasil dibuat"
  pause
}

rebuild_vite() {
  echo ""
  echo "▶ Rebuild assets dengan Vite..."
  npm install
  npm run build
  echo "✅ Vite rebuild selesai"
  pause
}

maintenance_mode() {
  echo ""
  echo "Maintenance Mode:"
  echo "1. Aktifkan Maintenance Mode (down)"
  echo "2. Nonaktifkan Maintenance Mode (up)"
  echo "0. Kembali"
  echo ""
  read -p "Pilihan: " MAINT_CHOICE

  case $MAINT_CHOICE in
    1)
      echo "▶ Mengaktifkan maintenance mode..."
      php artisan down
      echo "✅ Maintenance mode aktif"
      ;;
    2)
      echo "▶ Menonaktifkan maintenance mode..."
      php artisan up
      echo "✅ Maintenance mode nonaktif"
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

clear_cache_menu() {
  echo ""
  echo "Clear Cache:"
  echo "1. Optimize Clear (php artisan optimize:clear)"
  echo "2. Manual Clear (config, route, view, cache)"
  echo "0. Kembali"
  echo ""
  read -p "Pilihan: " CACHE_CHOICE

  case $CACHE_CHOICE in
    1)
      echo "▶ Menjalankan optimize:clear..."
      php artisan optimize:clear
      echo "✅ Optimize clear selesai"
      ;;
    2)
      echo "▶ Menjalankan clear cache manual..."
      php artisan config:clear
      php artisan route:clear
      php artisan view:clear
      php artisan cache:clear
      echo "✅ Manual clear cache selesai"
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
  echo "1. Install & Setup Laravel"
  echo "2. Setup .htaccess (redirect public)"
  echo "3. Setup Database (.env)"
  echo "4. Migrate Database"
  echo "5. Storage Link"
  echo "6. Rebuild Vite"
  echo "7. Maintenance Mode"
  echo "8. Clear Cache"
  echo "0. Exit"
  echo ""
  read -p "Pilih menu: " MENU

  case $MENU in
    1) install_laravel_menu ;;
    2) setup_htaccess ;;
    3) setup_env_database ;;
    4) migrate_menu ;;
    5) storage_link ;;
    6) rebuild_vite ;;
    7) maintenance_mode ;;
    8) clear_cache_menu ;;
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
