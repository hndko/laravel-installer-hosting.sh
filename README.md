# Laravel SSH Installer & Setup 🚀

> **Interactive bash script for quick Laravel project setup via SSH on shared hosting or VPS.**

A simple yet powerful CLI tool to automate common Laravel deployment tasks directly from your terminal. Perfect for shared hosting environments where you have SSH access but limited control.

## ✨ Features

| Feature              | Description                      |
| -------------------- | -------------------------------- |
| **Install Laravel**  | Standard or with Vite support    |
| **Setup .htaccess**  | Auto-redirect to public folder   |
| **Database Config**  | Interactive .env database setup  |
| **Migration**        | With seed or fresh migration     |
| **Storage Link**     | Create symbolic link for storage |
| **Rebuild Vite**     | Reinstall npm & rebuild assets   |
| **Maintenance Mode** | Toggle on/off easily             |
| **Clear Cache**      | Optimize clear or manual clear   |

## 📋 Requirements

- SSH access to your server
- PHP & Composer installed
- Node.js & NPM (for Vite features)
- Git (optional)

## 🚀 Quick Start

### Option 1: Direct Run

```bash
curl -sL https://raw.githubusercontent.com/hndko/laravel-installer-hosting.sh/main/laravel-installer.sh | bash
```

### Option 2: Download & Run

```bash
# Download the script
wget https://raw.githubusercontent.com/hndko/laravel-installer-hosting.sh/main/laravel-installer.sh

# Make it executable
chmod +x laravel-installer.sh

# Run it
./laravel-installer.sh
```

## 📖 Menu Options

```
======================================
 Laravel SSH Installer Menu
 Directory: /your/project/path
======================================
1. Install & Setup Laravel
2. Setup .htaccess (redirect public)
3. Setup Database (.env)
4. Migrate Database
5. Storage Link
6. Rebuild Vite
7. Maintenance Mode
8. Clear Cache
0. Exit
```

### 1️⃣ Install & Setup Laravel

- **Standard**: `composer install` + `.env` setup + `key:generate`
- **With Vite**: Includes `npm install` + `npm run build`

### 2️⃣ Setup .htaccess

Creates `.htaccess` file to redirect all requests to the `public` folder (useful for shared hosting).

### 3️⃣ Setup Database

Interactive prompts to configure database credentials in `.env`:

- DB_HOST
- DB_PORT
- DB_DATABASE
- DB_USERNAME
- DB_PASSWORD

### 4️⃣ Migrate Database

- `php artisan migrate --seed`
- `php artisan migrate:fresh --seed`

### 5️⃣ Storage Link

Creates symbolic link: `php artisan storage:link`

### 6️⃣ Rebuild Vite

Reinstalls dependencies and rebuilds assets:

```bash
npm install
npm run build
```

### 7️⃣ Maintenance Mode

- **On**: `php artisan down`
- **Off**: `php artisan up`

### 8️⃣ Clear Cache

- **Optimize Clear**: `php artisan optimize:clear`
- **Manual Clear**: Runs config, route, view, and cache clear separately

## 🤝 Contributing

Contributions are welcome! Feel free to submit issues and pull requests.

## 📄 License

MIT License - feel free to use and modify as needed.

---

Made with ❤️ for Laravel developers
