<!DOCTYPE html>
<html lang="id">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>@yield('title', 'Admin Panel') - E-Learning</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap');
        
        * {
            font-family: 'Inter', sans-serif;
        }

        body {
            background: linear-gradient(135deg, #0f0c29 0%, #302b63 50%, #24243e 100%);
            min-height: 100vh;
        }

        /* Animated Background */
        .bg-animated {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            z-index: -1;
            overflow: hidden;
        }

        .bg-animated::before {
            content: '';
            position: absolute;
            width: 200%;
            height: 200%;
            background: radial-gradient(circle at 20% 80%, rgba(120, 119, 198, 0.3) 0%, transparent 50%),
                        radial-gradient(circle at 80% 20%, rgba(255, 119, 198, 0.3) 0%, transparent 50%),
                        radial-gradient(circle at 40% 40%, rgba(120, 219, 255, 0.3) 0%, transparent 50%);
            animation: gradientMove 15s ease infinite;
        }

        @keyframes gradientMove {
            0%, 100% { transform: translate(0, 0); }
            50% { transform: translate(-25%, -25%); }
        }

        /* Glassmorphism Sidebar */
        .sidebar {
            background: rgba(255, 255, 255, 0.05);
            backdrop-filter: blur(20px);
            border-right: 1px solid rgba(255, 255, 255, 0.1);
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3);
        }

        .sidebar-link {
            position: relative;
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
            overflow: hidden;
        }

        .sidebar-link::before {
            content: '';
            position: absolute;
            left: 0;
            top: 0;
            width: 3px;
            height: 100%;
            background: linear-gradient(180deg, #667eea 0%, #764ba2 100%);
            transform: scaleY(0);
            transition: transform 0.3s ease;
        }

        .sidebar-link:hover::before,
        .sidebar-link.active::before {
            transform: scaleY(1);
        }

        .sidebar-link:hover {
            background: linear-gradient(90deg, rgba(102, 126, 234, 0.2) 0%, transparent 100%);
            transform: translateX(5px);
        }

        .sidebar-link.active {
            background: linear-gradient(90deg, rgba(102, 126, 234, 0.3) 0%, transparent 100%);
        }

        .sidebar-link i {
            transition: all 0.3s ease;
        }

        .sidebar-link:hover i {
            transform: scale(1.2);
            color: #667eea;
        }

        .sidebar-link.active i {
            color: #667eea;
        }

        /* Logo Animation */
        .logo-text {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 50%, #f093fb 100%);
            background-size: 200% 200%;
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            animation: gradientText 3s ease infinite;
        }

        @keyframes gradientText {
            0%, 100% { background-position: 0% 50%; }
            50% { background-position: 100% 50%; }
        }

        /* Header Glassmorphism */
        .header {
            background: rgba(255, 255, 255, 0.05);
            backdrop-filter: blur(20px);
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        }

        /* User Avatar Glow */
        .user-avatar {
            position: relative;
            animation: glow 2s ease-in-out infinite;
        }

        @keyframes glow {
            0%, 100% { box-shadow: 0 0 20px rgba(102, 126, 234, 0.5); }
            50% { box-shadow: 0 0 40px rgba(102, 126, 234, 0.8); }
        }

        /* Dropdown Animation */
        .dropdown-menu {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(20px);
            border: 1px solid rgba(255, 255, 255, 0.2);
            animation: slideDown 0.3s ease;
        }

        @keyframes slideDown {
            from {
                opacity: 0;
                transform: translateY(-10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        /* Content Area */
        .content-area {
            background: rgba(255, 255, 255, 0.02);
            backdrop-filter: blur(10px);
        }

        /* Scrollbar */
        ::-webkit-scrollbar { width: 8px; }
        ::-webkit-scrollbar-track { background: rgba(255, 255, 255, 0.05); }
        ::-webkit-scrollbar-thumb { 
            background: linear-gradient(180deg, #667eea 0%, #764ba2 100%);
            border-radius: 4px;
        }
        ::-webkit-scrollbar-thumb:hover { 
            background: linear-gradient(180deg, #764ba2 0%, #667eea 100%);
        }

        /* Alert Animations */
        .alert-success {
            background: linear-gradient(135deg, rgba(16, 185, 129, 0.2) 0%, rgba(5, 150, 105, 0.2) 100%);
            border: 1px solid rgba(16, 185, 129, 0.3);
            backdrop-filter: blur(10px);
            animation: slideIn 0.5s ease;
        }

        .alert-error {
            background: linear-gradient(135deg, rgba(239, 68, 68, 0.2) 0%, rgba(185, 28, 28, 0.2) 100%);
            border: 1px solid rgba(239, 68, 68, 0.3);
            backdrop-filter: blur(10px);
            animation: slideIn 0.5s ease;
        }

        @keyframes slideIn {
            from {
                opacity: 0;
                transform: translateX(-20px);
            }
            to {
                opacity: 1;
                transform: translateX(0);
            }
        }

        /* Floating Particles */
        .particle {
            position: absolute;
            width: 4px;
            height: 4px;
            background: rgba(102, 126, 234, 0.5);
            border-radius: 50%;
            animation: float 20s infinite;
        }

        @keyframes float {
            0%, 100% {
                transform: translateY(0) translateX(0);
                opacity: 0;
            }
            10% {
                opacity: 1;
            }
            90% {
                opacity: 1;
            }
            100% {
                transform: translateY(-100vh) translateX(100px);
                opacity: 0;
            }
        }
    </style>
</head>

<body class="text-white">
    <div class="bg-animated">
        @for($i = 0; $i < 20; $i++)
        <div class="particle" style="left: {{ rand(0, 100) }}%; top: {{ rand(0, 100) }}%; animation-delay: {{ rand(0, 20) }}s;"></div>
        @endfor
    </div>

    <div class="flex h-screen overflow-hidden">
        <!-- Sidebar -->
        <aside class="sidebar w-72 flex-shrink-0 flex flex-col">
            <div class="p-8">
                <h1 class="text-2xl font-bold logo-text flex items-center gap-3">
                    <i class="fas fa-graduation-cap text-3xl"></i>
                    <span>E-Learning Admin</span>
                </h1>
            </div>

            <nav class="mt-4 flex-1 px-4">
                <a href="{{ route('admin.dashboard') }}" class="sidebar-link {{ request()->routeIs('admin.dashboard') ? 'active' : '' }} flex items-center px-6 py-4 text-gray-300 hover:text-white transition-all duration-300 rounded-xl mb-2">
                    <i class="fas fa-home w-6 text-lg"></i>
                    <span class="ml-4 font-medium">Dashboard</span>
                </a>

                <a href="{{ route('admin.users') }}" class="sidebar-link {{ request()->routeIs('admin.users*') ? 'active' : '' }} flex items-center px-6 py-4 text-gray-300 hover:text-white transition-all duration-300 rounded-xl mb-2">
                    <i class="fas fa-users w-6 text-lg"></i>
                    <span class="ml-4 font-medium">Users</span>
                </a>

                <a href="{{ route('admin.topics') }}" class="sidebar-link {{ request()->routeIs('admin.topics*') ? 'active' : '' }} flex items-center px-6 py-4 text-gray-300 hover:text-white transition-all duration-300 rounded-xl mb-2">
                    <i class="fas fa-book w-6 text-lg"></i>
                    <span class="ml-4 font-medium">Topics</span>
                </a>

                <a href="{{ route('admin.materials') }}" class="sidebar-link {{ request()->routeIs('admin.materials*') ? 'active' : '' }} flex items-center px-6 py-4 text-gray-300 hover:text-white transition-all duration-300 rounded-xl mb-2">
                    <i class="fas fa-video w-6 text-lg"></i>
                    <span class="ml-4 font-medium">Learning Materials</span>
                </a>

                <a href="{{ route('admin.packages.index') }}" class="sidebar-link {{ request()->routeIs('admin.packages*') ? 'active' : '' }} flex items-center px-6 py-4 text-gray-300 hover:text-white transition-all duration-300 rounded-xl mb-2">
                    <i class="fas fa-box-open w-6 text-lg"></i>
                    <span class="ml-4 font-medium">Paket Kursus</span>
                </a>

                <a href="{{ route('admin.payments.index') }}" class="sidebar-link {{ request()->routeIs('admin.payments*') ? 'active' : '' }} flex items-center px-6 py-4 text-gray-300 hover:text-white transition-all duration-300 rounded-xl mb-2">
                    <i class="fas fa-credit-card w-6 text-lg"></i>
                    <span class="ml-4 font-medium">Pembayaran</span>
                </a>
            </nav>

            <div class="p-4 border-t border-white/10">
                <div class="flex items-center gap-3 px-4 py-3 rounded-xl bg-white/5">
                    <div class="w-10 h-10 rounded-full bg-gradient-to-br from-green-400 to-blue-500 flex items-center justify-center">
                        <i class="fas fa-leaf text-white"></i>
                    </div>
                    <div>
                        <p class="text-sm font-semibold">Eco Mode</p>
                        <p class="text-xs text-gray-400">Energy Saving</p>
                    </div>
                </div>
            </div>
        </aside>

        <!-- Main Content -->
        <div class="flex-1 flex flex-col overflow-hidden">
            <!-- Header -->
            <header class="header z-10">
                <div class="flex items-center justify-between px-8 py-5">
                    <div>
                        <h2 class="text-3xl font-bold bg-gradient-to-r from-white to-gray-300 bg-clip-text text-transparent">@yield('page-title', 'Dashboard')</h2>
                        <p class="text-gray-400 text-sm mt-1">Welcome back, {{ auth()->user()->name ?? 'Admin' }} 👋</p>
                    </div>
                    <div class="flex items-center space-x-6">
                        <!-- Search -->
                        <div class="relative hidden md:block">
                            <input type="text" placeholder="Search..." class="w-64 px-4 py-2 pl-10 rounded-xl bg-white/10 border border-white/20 text-white placeholder-gray-400 focus:outline-none focus:border-purple-500 focus:ring-2 focus:ring-purple-500/20 transition-all">
                            <i class="fas fa-search absolute left-3 top-1/2 -translate-y-1/2 text-gray-400"></i>
                        </div>

                        <!-- Notifications -->
                        <button class="relative p-2 rounded-xl bg-white/10 hover:bg-white/20 transition-all">
                            <i class="fas fa-bell text-xl"></i>
                            <span class="absolute -top-1 -right-1 w-5 h-5 bg-red-500 rounded-full text-xs flex items-center justify-center">3</span>
                        </button>

                        <!-- User dropdown -->
                        <div class="relative">
                            <button onclick="document.getElementById('userMenu').classList.toggle('hidden')"
                                class="flex items-center gap-4 px-4 py-2 rounded-xl bg-white/10 hover:bg-white/20 transition-all border border-white/10">
                                <div class="user-avatar w-10 h-10 rounded-full bg-gradient-to-br from-purple-500 via-pink-500 to-red-500 flex items-center justify-center text-white font-bold text-lg">
                                    {{ strtoupper(substr(auth()->user()->name ?? 'A', 0, 1)) }}
                                </div>
                                <div class="text-left hidden sm:block">
                                    <p class="text-sm font-semibold text-white leading-tight">{{ auth()->user()->name ?? 'Admin' }}</p>
                                    <p class="text-xs text-gray-400 leading-tight">{{ auth()->user()->email ?? '' }}</p>
                                </div>
                                <i class="fas fa-chevron-down text-xs text-gray-400 transition-transform"></i>
                            </button>

                            <div id="userMenu" class="dropdown-menu hidden absolute right-0 mt-3 w-56 rounded-2xl py-3 z-50">
                                <div class="px-4 py-3 border-b border-white/10 sm:hidden">
                                    <p class="text-sm font-semibold text-white">{{ auth()->user()->name ?? 'Admin' }}</p>
                                    <p class="text-xs text-gray-400">{{ auth()->user()->email ?? '' }}</p>
                                </div>
                                <a href="#" class="flex items-center gap-3 px-4 py-3 text-sm text-gray-300 hover:bg-white/10 hover:text-white transition">
                                    <i class="fas fa-user w-5"></i>
                                    Profile
                                </a>
                                <a href="#" class="flex items-center gap-3 px-4 py-3 text-sm text-gray-300 hover:bg-white/10 hover:text-white transition">
                                    <i class="fas fa-cog w-5"></i>
                                    Settings
                                </a>
                                <div class="border-t border-white/10 my-2"></div>
                                <form action="{{ route('admin.logout') }}" method="POST">
                                    @csrf
                                    <button type="submit" class="w-full flex items-center gap-3 px-4 py-3 text-sm text-red-400 hover:bg-red-500/20 hover:text-red-300 transition">
                                        <i class="fas fa-right-from-bracket w-5"></i>
                                        Logout
                                    </button>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </header>

            <!-- Content Area -->
            <main class="content-area flex-1 overflow-y-auto p-8">
                @if(session('success'))
                <div class="mb-6 alert-success p-4 rounded-2xl">
                    <div class="flex items-center">
                        <i class="fas fa-check-circle text-2xl mr-4 text-green-400"></i>
                        <p class="font-medium">{{ session('success') }}</p>
                    </div>
                </div>
                @endif

                @if(session('error'))
                <div class="mb-6 alert-error p-4 rounded-2xl">
                    <div class="flex items-center">
                        <i class="fas fa-exclamation-circle text-2xl mr-4 text-red-400"></i>
                        <p class="font-medium">{{ session('error') }}</p>
                    </div>
                </div>
                @endif

                @yield('content')
            </main>
        </div>
    </div>

    <script>
        // Auto hide alerts after 5 seconds
        setTimeout(() => {
            const alerts = document.querySelectorAll('.alert-success, .alert-error');
            alerts.forEach(alert => {
                alert.style.transition = 'all 0.5s ease';
                alert.style.opacity = '0';
                alert.style.transform = 'translateX(20px)';
                setTimeout(() => alert.remove(), 500);
            });
        }, 5000);

        // Close user menu when clicking outside
        document.addEventListener('click', function (e) {
            const menu = document.getElementById('userMenu');
            const btn = e.target.closest('button');
            if (menu && !menu.classList.contains('hidden')) {
                const insideMenu = menu.contains(e.target);
                const isToggle = btn && btn.getAttribute('onclick')?.includes('userMenu');
                if (!insideMenu && !isToggle) {
                    menu.classList.add('hidden');
                }
            }
        });

        // Add smooth scroll behavior
        document.querySelectorAll('a[href^="#"]').forEach(anchor => {
            anchor.addEventListener('click', function (e) {
                e.preventDefault();
                document.querySelector(this.getAttribute('href')).scrollIntoView({
                    behavior: 'smooth'
                });
            });
        });
    </script>
</body>

</html>