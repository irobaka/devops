<?php

namespace App\Http\Controllers;

use App\Http\Requests\PostRequest;
use App\Models\Post;

class PostsController extends Controller
{
    public function index()
    {
        return view('posts', [
            'posts' => Post::orderBy('id', 'DESC')->get()
        ]);
    }

    public function create()
    {
        return view('post-create');
    }

    public function store(PostRequest $request)
    {
        $validated = $request->validated();

        $post = Post::create([
            'title' => $validated['title'],
            'body' => $validated['body']
        ]);

        return redirect(route('posts.index'));
    }
}
