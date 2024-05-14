<?php

namespace App\Http\Controllers;

use App\Http\Requests\PostRequest;
use App\Models\Post;
use Illuminate\Contracts\View\View;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Response;

class PostsController extends Controller
{
    public function index(): View
    {
        return view('posts', [
            'posts' => Post::orderBy('id', 'DESC')->get(),
        ]);
    }

    public function create(): View
    {
        return view('post-create');
    }

    public function store(PostRequest $request): RedirectResponse
    {
        $validated = $request->validated();

        Post::create([
            'title' => $validated['title'],
            'body' => $validated['body'],
        ]);

        return redirect(route('posts.index'));
    }

    public function show(Post $post): View
    {
        if (! $post->published) {
            abort(404, 'Post nie jest opublikowany.');
        }

        return view('post', [
            'post' => $post,
        ]);
    }

    public function publish(Post $post): Response
    {
        $post->published = true;
        $post->save();

        return new Response('OK');
    }
}
