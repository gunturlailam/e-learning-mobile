<!DOCTYPE html>
<html lang="id">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - E-Learning Admin</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        @keyframes float {
            0%, 100% { transform: translateY(0) rotate(0deg); }
            50% { transform: translateY(-20px) rotate(6deg); }
        }
        @keyframes float-slow {
            0%, 100% { transform: translateY(0) translateX(0); }
            50% { transform: translateY(25px) translateX(15px); }
        }
        .animate-float { animation: float 6s ease-in-out infinite; }
        .animate-float-slow { animation: float-slow 8s ease-in-out infinite; }

        .glass {
            background: rgba(255, 255, 255, 0.12);
            backdrop-filter: blur(18px);
            -webkit-backdrop-filter: blur(18px);
            border: 1px solid rgba(255, 255, 255, 0.18);
        }

        .input-glass {
            background: rgba(255, 255, 255, 0.08);
            border: 1px solid rgba(255, 255, 255, 0.2);
            transition: all 0.3s ease;
        }
        .input-glass:focus {
            background: rgba(255, 255, 255, 0.16);
            border-color: rgba(255, 255, 255, 0.55);
            box-shadow: 0 0 0 4px rgba(255, 255, 255, 0.08);
        }
        .input-glass::placeholder { color: rgba(255, 255, 255, 0.55); }

        @keyframes shake {
            0%, 100% { transform: translateX(0); }
            20%, 60% { transform: translateX(-6px); }
            40%, 80% { transform: translateX(6px); }
        }
        .animate-shake { animation: shake 0.4s ease; }
    </style>
</head>

<body class="min-h-screen flex items-center justify-center relative overflow-hidden"
    style="background: linear-gradient(135deg, #4f46e5 0%, #7c3aed 45%, #db2777 100%);">

    <!-- Floating decorative blobs -->
    <div class="absolute top-10 left-10 w-72 h-72 bg-white/10 rounded-full blur-3xl animate-float-slow"></div>
    <div class="absolute bottom-10 right-10 w-96 h-96 bg-pink-400/20 rounded-full blur-3xl animate-float"></div>
    <div class="absolute top-1/3 right-1/4 w-40 h-40 bg-blue-300/20 rounded-full blur-2xl animate-float"></div>

    <!-- Login Card -->
    <div class="glass rounded-3xl shadow-2xl p-8 sm:p-10 w-full max-w-md mx-4 relative z-10 {{ $errors->any() ? 'animate-shake' : '' }}">

        <!-- Logo / Brand -->
        <div class="text-center mb-8">
            <div class="inline-flex items-center justify-center w-20 h-20 rounded-2xl bg-white/20 shadow-lg mb-4 animate-float">
                <i class="fas fa-graduation-cap text-4xl text-white"></i>
            </div>
            <h1 class="text-3xl font-extrabold text-white tracking-tight">E-Learning</h1>
            <p class="text-white/70 mt-1 text-sm">Admin Panel · Silakan masuk untuk melanjutkan</p>
        </div>

        <!-- Error / Success Alerts -->
        @if(session('success'))
        <div class="mb-5 flex items-center gap-3 bg-green-500/20 border border-green-300/40 text-green-50 px-4 py-3 rounded-xl text-sm">
            <i class="fas fa-check-circle"></i>
            <span>{{ session('success') }}</span>
        </div>
        @endif

        @if($errors->any())
        <div class="mb-5 flex items-center gap-3 bg-red-500/25 border border-red-300/40 text-red-50 px-4 py-3 rounded-xl text-sm">
            <i class="fas fa-circle-exclamation"></i>
            <span>{{ $errors->first() }}</span>
        </div>
        @endif

        <!-- Form -->
        <form action="{{ route('admin.login.submit') }}" method="POST" class="space-y-5">
            @csrf

            <!-- Email -->
            <div>
                <label class="block text-white/80 text-sm font-medium mb-2">Email</label>
                <div class="relative">
                    <span class="absolute inset-y-0 left-0 flex items-center pl-4 text-white/50">
                        <i class="fas fa-envelope"></i>
                    </span>
                    <input type="email" name="email" value="{{ old('email') }}"
                        placeholder="admin@elearning.com" required autofocus
                        class="input-glass w-full rounded-xl py-3 pl-12 pr-4 text-white outline-none">
                </div>
            </div>

            <!-- Password -->
            <div>
                <label class="block text-white/80 text-sm font-medium mb-2">Password</label>
                <div class="relative">
                    <span class="absolute inset-y-0 left-0 flex items-center pl-4 text-white/50">
                        <i class="fas fa-lock"></i>
                    </span>
                    <input type="password" name="password" id="password"
                        placeholder="••••••••" required
                        class="input-glass w-full rounded-xl py-3 pl-12 pr-12 text-white outline-none">
                    <button type="button" onclick="togglePassword()"
                        class="absolute inset-y-0 right-0 flex items-center pr-4 text-white/50 hover:text-white transition">
                        <i class="fas fa-eye" id="toggleIcon"></i>
                    </button>
                </div>
            </div>

            <!-- Remember + Forgot -->
            <div class="flex items-center justify-between text-sm">
                <label class="flex items-center gap-2 text-white/70 cursor-pointer select-none">
                    <input type="checkbox" name="remember" class="rounded border-white/30 bg-white/10 text-purple-500 focus:ring-0">
                    Ingat saya
                </label>
            </div>

            <!-- Submit -->
            <button type="submit"
                class="w-full bg-white text-purple-700 font-bold py-3 rounded-xl shadow-lg hover:bg-purple-50 hover:shadow-xl transform hover:-translate-y-0.5 transition-all duration-200 flex items-center justify-center gap-2">
                <i class="fas fa-right-to-bracket"></i>
                Masuk
            </button>
        </form>

        <p class="text-center text-white/50 text-xs mt-8">
            &copy; {{ date('Y') }} E-Learning Admin. All rights reserved.
        </p>
    </div>

    <script>
        function togglePassword() {
            const input = document.getElementById('password');
            const icon = document.getElementById('toggleIcon');
            if (input.type === 'password') {
                input.type = 'text';
                icon.classList.replace('fa-eye', 'fa-eye-slash');
            } else {
                input.type = 'password';
                icon.classList.replace('fa-eye-slash', 'fa-eye');
            }
        }
    </script>
</body>

</html>
