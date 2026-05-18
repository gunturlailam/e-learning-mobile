@extends('admin.layout')

@section('title', 'Dashboard')
@section('page-title', 'Dashboard')

@section('content')
<div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
    <!-- Users Card -->
    <div class="bg-gradient-to-br from-blue-500 to-blue-600 rounded-xl shadow-lg p-6 text-white transform hover:scale-105 transition-transform duration-200">
        <div class="flex items-center justify-between">
            <div>
                <p class="text-blue-100 text-sm font-medium">Total Users</p>
                <h3 class="text-4xl font-bold mt-2">{{ $userCount }}</h3>
            </div>
            <div class="bg-white bg-opacity-20 rounded-full p-4">
                <i class="fas fa-users text-3xl"></i>
            </div>
        </div>
        <a href="{{ route('admin.users') }}" class="mt-4 inline-block text-sm text-blue-100 hover:text-white">
            View all users <i class="fas fa-arrow-right ml-1"></i>
        </a>
    </div>

    <!-- Topics Card -->
    <div class="bg-gradient-to-br from-purple-500 to-purple-600 rounded-xl shadow-lg p-6 text-white transform hover:scale-105 transition-transform duration-200">
        <div class="flex items-center justify-between">
            <div>
                <p class="text-purple-100 text-sm font-medium">Total Topics</p>
                <h3 class="text-4xl font-bold mt-2">{{ $topicCount }}</h3>
            </div>
            <div class="bg-white bg-opacity-20 rounded-full p-4">
                <i class="fas fa-book text-3xl"></i>
            </div>
        </div>
        <a href="{{ route('admin.topics') }}" class="mt-4 inline-block text-sm text-purple-100 hover:text-white">
            View all topics <i class="fas fa-arrow-right ml-1"></i>
        </a>
    </div>

    <!-- Materials Card -->
    <div class="bg-gradient-to-br from-green-500 to-green-600 rounded-xl shadow-lg p-6 text-white transform hover:scale-105 transition-transform duration-200">
        <div class="flex items-center justify-between">
            <div>
                <p class="text-green-100 text-sm font-medium">Speaking Materials</p>
                <h3 class="text-4xl font-bold mt-2">{{ $materialCount }}</h3>
            </div>
            <div class="bg-white bg-opacity-20 rounded-full p-4">
                <i class="fas fa-video text-3xl"></i>
            </div>
        </div>
        <a href="{{ route('admin.materials') }}" class="mt-4 inline-block text-sm text-green-100 hover:text-white">
            View all materials <i class="fas fa-arrow-right ml-1"></i>
        </a>
    </div>
</div>

<!-- Quick Actions -->
<div class="bg-white rounded-xl shadow-lg p-6">
    <h3 class="text-xl font-semibold text-gray-800 mb-4">
        <i class="fas fa-bolt text-yellow-500"></i> Quick Actions
    </h3>
    <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
        <a href="{{ route('admin.users.create') }}" class="flex items-center p-4 bg-blue-50 hover:bg-blue-100 rounded-lg transition-colors duration-200">
            <i class="fas fa-user-plus text-2xl text-blue-600 mr-4"></i>
            <div>
                <p class="font-semibold text-gray-800">Add New User</p>
                <p class="text-sm text-gray-600">Create a new user account</p>
            </div>
        </a>

        <a href="{{ route('admin.topics.create') }}" class="flex items-center p-4 bg-purple-50 hover:bg-purple-100 rounded-lg transition-colors duration-200">
            <i class="fas fa-book-medical text-2xl text-purple-600 mr-4"></i>
            <div>
                <p class="font-semibold text-gray-800">Add New Topic</p>
                <p class="text-sm text-gray-600">Create a new learning topic</p>
            </div>
        </a>

        <a href="{{ route('admin.materials.create') }}" class="flex items-center p-4 bg-green-50 hover:bg-green-100 rounded-lg transition-colors duration-200">
            <i class="fas fa-video text-2xl text-green-600 mr-4"></i>
            <div>
                <p class="font-semibold text-gray-800">Add New Material</p>
                <p class="text-sm text-gray-600">Upload speaking material</p>
            </div>
        </a>
    </div>
</div>

<!-- Welcome Message -->
<div class="mt-8 bg-gradient-to-r from-indigo-500 via-purple-500 to-pink-500 rounded-xl shadow-lg p-8 text-white">
    <h2 class="text-3xl font-bold mb-2">Welcome to E-Learning Admin Panel! 🎓</h2>
    <p class="text-lg text-white text-opacity-90">
        Manage your users, topics, and speaking materials all in one place. Use the sidebar to navigate through different sections.
    </p>
</div>
@endsection