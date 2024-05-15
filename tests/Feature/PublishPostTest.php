<?php

use function Pest\Laravel\get;
use function Pest\Laravel\post;

it('should publish a post', function () {
    $post = \App\Models\Post::factory()->create();

    $post = \App\Models\Post::find($post->id);
    expect($post->published)->toBeFalse();

    post(route('posts.publish', ['post' => $post]))
        ->assertStatus(200);

    $post = \App\Models\Post::find($post->id);
    expect($post->published)->toBeTrue();
});

it('should returns 200 if post is published', function () {
    $post = \App\Models\Post::factory()->create(['published' => true]);

    get(route('posts.show', ['post' => $post]))
        ->assertStatus(200);
});

it('should returns 404 if post is unpublished', function () {
    $post = \App\Models\Post::factory()->create();

    get(route('posts.show', ['post' => $post]))
        ->assertStatus(404);
});
