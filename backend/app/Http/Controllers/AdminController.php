<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\User;
use App\Models\Topic;
use App\Models\LearningMaterial;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Hash;

class AdminController extends Controller
{
    // Dashboard
    public function dashboard()
    {
        $userCount = User::count();
        $topicCount = Topic::count();
        $materialCount = LearningMaterial::count();

        return view('admin.dashboard', compact('userCount', 'topicCount', 'materialCount'));
    }

    // ===== USER MANAGEMENT =====
    public function users()
    {
        $users = User::latest()->paginate(10);
        return view('admin.users.index', compact('users'));
    }

    public function createUser()
    {
        return view('admin.users.create');
    }

    public function storeUser(Request $request)
    {
        $request->validate([
            'name' => 'required|string|max:255',
            'email' => 'required|email|unique:users,email',
            'password' => 'required|string|min:6'
        ]);

        User::create([
            'name' => $request->name,
            'email' => $request->email,
            'password' => Hash::make($request->password)
        ]);

        return redirect()->route('admin.users')->with('success', 'User berhasil ditambahkan!');
    }

    public function editUser(int $id)
    {
        $user = User::findOrFail($id);
        return view('admin.users.edit', compact('user'));
    }

    public function updateUser(Request $request, int $id)
    {
        $user = User::findOrFail($id);

        $request->validate([
            'name' => 'required|string|max:255',
            'email' => 'required|email|unique:users,email,' . $id,
            'password' => 'nullable|string|min:6'
        ]);

        $user->name = $request->name;
        $user->email = $request->email;

        if ($request->filled('password')) {
            $user->password = Hash::make($request->password);
        }

        $user->save();

        return redirect()->route('admin.users')->with('success', 'User berhasil diperbarui!');
    }

    public function deleteUser(int $id)
    {
        $user = User::findOrFail($id);
        $user->delete();

        return redirect()->route('admin.users')->with('success', 'User berhasil dihapus!');
    }

    // ===== TOPIC MANAGEMENT =====
    public function topics()
    {
        $topics = Topic::latest()->paginate(10);
        return view('admin.topics.index', compact('topics'));
    }

    public function createTopic()
    {
        return view('admin.topics.create');
    }

    public function storeTopic(Request $request)
    {
        $request->validate([
            'title' => 'required|string|max:255',
            'description' => 'nullable|string',
            'price' => 'nullable|numeric|min:0',
            'is_free' => 'boolean'
        ]);

        Topic::create([
            'title' => $request->title,
            'description' => $request->description,
            'price' => $request->price ?? 0,
            'is_free' => $request->has('is_free')
        ]);

        return redirect()->route('admin.topics')->with('success', 'Topik berhasil ditambahkan!');
    }

    public function editTopic(int $id)
    {
        $topic = Topic::findOrFail($id);
        return view('admin.topics.edit', compact('topic'));
    }

    public function updateTopic(Request $request, int $id)
    {
        $topic = Topic::findOrFail($id);

        $request->validate([
            'title' => 'required|string|max:255',
            'description' => 'nullable|string',
            'price' => 'nullable|numeric|min:0',
            'is_free' => 'boolean'
        ]);

        $topic->update([
            'title' => $request->title,
            'description' => $request->description,
            'price' => $request->price ?? 0,
            'is_free' => $request->has('is_free')
        ]);

        return redirect()->route('admin.topics')->with('success', 'Topik berhasil diperbarui!');
    }

    public function deleteTopic(int $id)
    {
        $topic = Topic::findOrFail($id);
        $topic->delete();

        return redirect()->route('admin.topics')->with('success', 'Topik berhasil dihapus!');
    }

    // ===== LEARNING MATERIAL MANAGEMENT =====
    public function materials()
    {
        $materials = LearningMaterial::latest()->paginate(10);
        return view('admin.materials.index', compact('materials'));
    }

    public function createMaterial()
    {
        return view('admin.materials.create');
    }

    public function storeMaterial(Request $request)
    {
        $request->validate([
            'title' => 'required|string|max:255',
            'description' => 'nullable|string',
            'kategori' => 'required|string|max:100',
            'video' => 'required|file|mimes:mp4,mov,avi,mkv|max:512000',
            'pdf' => 'nullable|file|mimes:pdf|max:51200'
        ]);

        try {
            $video = $request->file('video')->store('videos', 'public');
            $pdf = $request->hasFile('pdf') ? $request->file('pdf')->store('pdfs', 'public') : null;

            LearningMaterial::create([
                'title' => $request->title,
                'description' => $request->description,
                'kategori' => $request->kategori,
                'video' => $video,
                'pdf' => $pdf,
            ]);

            return redirect()->route('admin.materials')->with('success', 'Materi berhasil ditambahkan!');
        } catch (\Exception $e) {
            return back()->with('error', 'Error: ' . $e->getMessage());
        }
    }

    public function editMaterial(int $id)
    {
        $material = LearningMaterial::findOrFail($id);
        return view('admin.materials.edit', compact('material'));
    }

    public function updateMaterial(Request $request, int $id)
    {
        $material = LearningMaterial::findOrFail($id);

        $request->validate([
            'title' => 'required|string|max:255',
            'description' => 'nullable|string',
            'kategori' => 'required|string|max:100',
            'video' => 'nullable|mimes:mp4,mov,avi|max:102400',
            'pdf' => 'nullable|mimes:pdf|max:10240'
        ]);

        if ($request->hasFile('video')) {
            if ($material->video && Storage::disk('public')->exists($material->video)) {
                Storage::disk('public')->delete($material->video);
            }
            $material->video = $request->file('video')->store('videos', 'public');
        }

        if ($request->hasFile('pdf')) {
            if ($material->pdf && Storage::disk('public')->exists($material->pdf)) {
                Storage::disk('public')->delete($material->pdf);
            }
            $material->pdf = $request->file('pdf')->store('pdfs', 'public');
        }

        $material->title = $request->title;
        $material->description = $request->description;
        $material->kategori = $request->kategori;
        $material->save();

        return redirect()->route('admin.materials')->with('success', 'Materi berhasil diperbarui!');
    }

    public function deleteMaterial(int $id)
    {
        $material = LearningMaterial::findOrFail($id);

        if ($material->video && Storage::disk('public')->exists($material->video)) {
            Storage::disk('public')->delete($material->video);
        }

        if ($material->pdf && Storage::disk('public')->exists($material->pdf)) {
            Storage::disk('public')->delete($material->pdf);
        }

        $material->delete();

        return redirect()->route('admin.materials')->with('success', 'Materi berhasil dihapus!');
    }
}
