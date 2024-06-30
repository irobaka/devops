<?php

use App\Http\Controllers\PostsController;
use Illuminate\Support\Facades\Route;

Route::controller(PostsController::class)->group(function () {
    Route::get('/', 'index')->name('posts.index');
    Route::get('create', 'create')->name('posts.create');
    Route::post('/', 'store')->name('posts.store');
    Route::post('publish/{post}', 'publish')->name('posts.publish');
    Route::get('post/{post}', 'show')->name('posts.show');
    Route::get('health-check', fn() => response('', 200));
});
