<?php

namespace App\Http\Controllers;

use App\Http\Requests\PostRequest;
use App\Models\Post;
use Illuminate\Http\Response;

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

    public function publish(Post $post)
    {
        $post->published = true;
        $post->save();

        return new Response('OK');
    }
}
