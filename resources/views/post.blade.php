@extends('layouts.app')

@section('content')
    <div class="rounded overflow-hidden shadow-lg">
        <img class="w-full" src="https://picsum.photos/800/600" alt="Blog Image">
        <div class="px-6 py-4">
            <div class="text-end text-primary text-xs mb-2">
                {{ $post->created_at->format('d-m-Y H:i') }}
            </div>
            <h2 class="font-bold text-2xl mb-2 text-yellow-dark">{{ $post->title }}</h2>
            <p class="mt-3 text-primary text-base">
                {{ $post->body }}
            </p>
        </div>
@endsection
