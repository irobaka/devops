<?php


use function Pest\Laravel\post;

it('should create a new post', function () {
    $title = 'Test title';
    $body = \Illuminate\Support\Str::random(35);

    $data = \App\Models\Post::factory()->make([
        'title' => $title,
        'body' => $body
    ])->toArray();

    post(route('posts.store'), $data)
        ->assertStatus(302);

    $post = \App\Models\Post::first();

    expect($post->title)->toEqual($title)
        ->and($post->body)->toEqual($body);
});
