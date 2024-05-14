@extends('layouts.app')

@section('content')
    @if($posts->isEmpty())
        <div class="p-4 mb-4 text-sm text-blue-dark rounded-lg bg-yellow-light dark:bg-gray-800 dark:text-red-400"
             role="alert">
            Brak postów.
        </div>
    @else
        <div class="grid grid-cols-1 gap-6 lg:gap-8 sm:grid-cols-2 lg:grid-cols-3 mb-5">
            @foreach($posts as $post)
                <div class="rounded overflow-hidden shadow-lg">
                    <img class="w-full" src="https://picsum.photos/400/300" alt="Blog Image">
                    <div class="px-6 py-4">
                        <div class="flex text-primary justify-between items-center text-xs mb-2">
                            @if(!$post->published)
                                <div class="rounded-sm bg-grey-light px-2 py-1">nieopublikowane</div>
                            @else
                                <div></div>
                            @endif
                            <div>{{ $post->created_at->format('d-m-Y H:i') }}</div>
                        </div>
                        <h2 class="font-bold text-2xl mb-2 text-yellow-dark">{{ $post->title }}</h2>
                        <p class="mt-3 text-primary text-base">
                            {{ $post->body }}
                        </p>
                        @if($post->published)
                            <p class="text-end mt-5 mb-2">
                                <a href="{{ route('posts.show', $post) }}"
                                   class="bg-primary text-white hover:bg-secondary focus:ring-4 focus:ring-yellow-dark focus:outline-none rounded-md text-sm w-full sm:w-auto px-5 py-2.5 text-center">
                                    Czytaj więcej
                                </a>
                            </p>
                        @endif
                    </div>
                </div>
            @endforeach
        </div>
    @endif
@endsection
