<!DOCTYPE html>
<html lang="id">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>@yield('title', 'Admin Panel') - E-Learning</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        .sidebar-link {
            transition: all 0.2s ease;
        }
        .sidebar-link:hover {
            background: linear-gradient(90deg, #3b82f6 0%, #2563eb 100%);
        }
        .sidebar-link.active {
            background: linear-gradient(90deg, #3b82f6 0%, #2563eb 100%);
        }
        ::-webkit-scrollbar { width: 6px; }
        ::-webkit-scrollbar-track { background: #f1f5f9; }
        ::-webkit-scrollbar-thumb { background: #cbd5e1; border-radius: 3px; }
        ::-webkit-scrollbar-thumb:hover { background: #94a3b8; }
    </style>
</head>

<body class="bg-gray-50">
    <div class="flex h-screen overflow-hidden">
        <!-- Sidebar -->
        <aside class="w-64 bg-gradient-to-b from-gray-900 to-gray-800 text-white flex-shrink-0">
            <div class="p-6">
                <h1 class="text-2xl font-bold bg-gradient-to-r from-blue-400 to-purple-500 bg-clip-text text-transparent">
                    <i class="fas fa-graduation-cap"></i> E-Learning Admin
                </h1>
            </div>

            <nav class="mt-6">
                <a href="{{ route('admin.dashboard') }}" class="sidebar-link {{ request()->routeIs('admin.dashboard') ? 'active' : '' }} flex items-center px-6 py-3 text-gray-300 hover:text-white transition-all duration-200">
                    <i class="fas fa-home w-6"></i>
                    <span class="ml-3">Dashboard</span>
                </a>

                <a href="{{ route('admin.users') }}" class="sidebar-link {{ request()->routeIs('admin.users*') ? 'active' : '' }} flex items-center px-6 py-3 text-gray-300 hover:text-white transition-all duration-200">
                    <i class="fas fa-users w-6"></i>
                    <span class="ml-3">Users</span>
                </a>

                <a href="{{ route('admin.topics') }}" class="sidebar-link {{ request()->routeIs('admin.topics*') ? 'active' : '' }} flex items-center px-6 py-3 text-gray-300 hover:text-white transition-all duration-200">
                    <i class="fas fa-book w-6"></i>
                    <span class="ml-3">Topics</span>
                </a>

                <a href="{{ route('admin.materials') }}" class="sidebar-link {{ request()->routeIs('admin.materials*') ? 'active' : '' }} flex items-center px-6 py-3 text-gray-300 hover:text-white transition-all duration-200">
                    <i class="fas fa-video w-6"></i>
                    <span class="ml-3">Learning Materials</span>
                </a>

                <a href="{{ route('admin.packages.index') }}" class="sidebar-link {{ request()->routeIs('admin.packages*') ? 'active' : '' }} flex items-center px-6 py-3 text-gray-300 hover:text-white transition-all duration-200">
                    <i class="fas fa-box-open w-6"></i>
                    <span class="ml-3">Paket Kursus</span>
                </a>
            </nav>
        </aside>

        <!-- Main Content -->
        <div class="flex-1 flex flex-col overflow-hidden">
            <!-- Header -->
            <header class="bg-white shadow-sm z-10">
                <div class="flex items-center justify-between px-8 py-4">
                    <h2 class="text-2xl font-semibold text-gray-800">@yield('page-title', 'Dashboard')</h2>
                    <div class="flex items-center space-x-4">
                        <!-- User dropdown -->
                        <div class="relative">
                            <button onclick="document.getElementById('userMenu').classList.toggle('hidden')"
                                class="flex items-center gap-3 px-3 py-2 rounded-lg hover:bg-gray-100 transition">
                                <div class="w-9 h-9 rounded-full bg-gradient-to-br from-blue-500 to-purple-600 flex items-center justify-center text-white font-bold">
                                    {{ strtoupper(substr(auth()->user()->name ?? 'A', 0, 1)) }}
                                </div>
                                <div class="text-left hidden sm:block">
                                    <p class="text-sm font-semibold text-gray-800 leading-tight">{{ auth()->user()->name ?? 'Admin' }}</p>
                                    <p class="text-xs text-gray-500 leading-tight">{{ auth()->user()->email ?? '' }}</p>
                                </div>
                                <i class="fas fa-chevron-down text-xs text-gray-400"></i>
                            </button>

                            <div id="userMenu" class="hidden absolute right-0 mt-2 w-48 bg-white rounded-xl shadow-lg border border-gray-100 py-2 z-50">
                                <div class="px-4 py-2 border-b border-gray-100 sm:hidden">
                                    <p class="text-sm font-semibold text-gray-800">{{ auth()->user()->name ?? 'Admin' }}</p>
                                    <p class="text-xs text-gray-500">{{ auth()->user()->email ?? '' }}</p>
                                </div>
                                <form action="{{ route('admin.logout') }}" method="POST">
                                    @csrf
                                    <button type="submit" class="w-full flex items-center gap-3 px-4 py-2 text-sm text-red-600 hover:bg-red-50 transition">
                                        <i class="fas fa-right-from-bracket w-4"></i>
                                        Logout
                                    </button>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </header>

            <!-- Content Area -->
            <main class="flex-1 overflow-y-auto p-8">
                @if(session('success'))
                <div class="mb-6 bg-green-100 border-l-4 border-green-500 text-green-700 p-4 rounded-lg shadow-sm animate-pulse">
                    <div class="flex items-center">
                        <i class="fas fa-check-circle text-xl mr-3"></i>
                        <p>{{ session('success') }}</p>
                    </div>
                </div>
                @endif

                @if(session('error'))
                <div class="mb-6 bg-red-100 border-l-4 border-red-500 text-red-700 p-4 rounded-lg shadow-sm">
                    <div class="flex items-center">
                        <i class="fas fa-exclamation-circle text-xl mr-3"></i>
                        <p>{{ session('error') }}</p>
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
            const alerts = document.querySelectorAll('.animate-pulse');
            alerts.forEach(alert => {
                alert.style.transition = 'opacity 0.5s';
                alert.style.opacity = '0';
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
    </script>
</body>

</html>