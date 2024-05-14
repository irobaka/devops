@extends('layouts.app')

@section('content')
    <h1>Dodaj post</h1>

    <form class="mt-6" method="post" action="{{ route('posts.store') }}">

        @csrf

        <div class="mb-5">
            <label for="title" class="block mb-2 text-sm font-medium text-primary">Tytuł <span class="text-yellow-dark">*</span></label>
            <input type="text"
                   id="title"
                   name="title"
                   class="border border-primary text-primary text-sm rounded-md focus:ring-yellow-dark focus:border-yellow-dark block w-full p-2.5 is-invalid"
                   required/>

            @error('title')
            <div class="text-xs text-yellow-dark mt-2">{{ $message }}</div>
            @enderror
        </div>

        <div class="mb-5">
            <label for="body" class="block mb-2 text-sm font-medium text-primary">Treść <span
                    class="text-yellow-dark">*</span></label>
            <textarea type="text"
                      id="body"
                      name="body"
                      rows="6"
                      class="border border-primary text-primary text-sm rounded-md focus:ring-yellow-dark focus:border-yellow-dark block w-full p-2.5"
                      required></textarea>

            @error('body')
            <div class="text-xs text-yellow-dark mt-2">{{ $message }}</div>
            @enderror
        </div>

        <button type="submit"
                class="mb-5 bg-primary text-white hover:bg-secondary focus:ring-4 focus:ring-yellow-dark focus:outline-none rounded-md text-sm w-full sm:w-auto px-5 py-2.5 text-center">
            Zapisz
        </button>
    </form>
@endsection
