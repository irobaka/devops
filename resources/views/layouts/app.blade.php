<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <link
        crossorigin="crossorigin"
        href="https://fonts.gstatic.com"
        rel="preconnect"
    />

    <link
        as="style"
        href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap"
        rel="preload"
    />

    <link
        href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap"
        rel="stylesheet"
    />

    <link
        rel="stylesheet"
        href="https://unpkg.com/boxicons@2.0.7/css/boxicons.min.css"
    />


    <script src="//cdnjs.cloudflare.com/ajax/libs/highlight.js/10.5.0/highlight.min.js"></script>

    <link
        rel="stylesheet"
        href="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/10.5.0/styles/atom-one-dark.min.css"
    />

    <script>
        hljs.initHighlightingOnLoad();
    </script>

    <title>Posts</title>

    @vite(['resources/js/app.js', 'resources/css/app.css'])
</head>
<body>

<div id="main">
    <div class="container mx-auto">
        <div class="flex items-center justify-between py-6 lg:py-10">
            <a href="/" class="flex items-center">
                  <span href="{{ route('posts.index') }}" class="mr-2">
                    <img src="{{ Vite::asset('resources/img/logo.svg') }}" alt="logo"/>
                  </span>
                <p class="hidden font-body text-2xl font-bold text-primary dark:text-white lg:block">
                    John Doe
                </p>
            </a>
            <div class="hidden lg:block">
                <ul class="flex items-center">

                    <li class="group relative mr-6 mb-1">
                        <div
                            class="absolute left-0 bottom-0 z-20 h-0 w-full opacity-75 transition-all group-hover:h-2 group-hover:bg-yellow"></div>
                        <a href="{{ route('posts.index') }}"
                           class="relative z-30 block px-2 font-body text-lg font-medium text-primary transition-colors group-hover:text-green dark:text-white dark:group-hover:text-secondary"
                        >
                            Posty
                        </a>
                    </li>

                    <li class="group relative mr-6 mb-1">
                        <div
                            class="absolute left-0 bottom-0 z-20 h-0 w-full opacity-75 transition-all group-hover:h-2 group-hover:bg-yellow"></div>
                        <a href="{{ route('posts.create') }}"
                           class="relative z-30 block px-2 font-body text-lg font-medium text-primary transition-colors group-hover:text-green dark:text-white dark:group-hover:text-secondary"
                        >
                            Dodaj post
                        </a>
                    </li>
                </ul>
            </div>
        </div>
    </div>

    <div class="container mx-auto">
        @yield('content')
    </div>

    <div class="container mx-auto">
        <div class="flex flex-col items-center justify-between border-t border-grey-lighter py-10 sm:flex-row sm:py-12">
            <div class="mr-auto flex flex-col items-center sm:flex-row">
                <a href="/" class="mr-auto sm:mr-6">
                    <img src="{{ Vite::asset('resources/img/logo.svg') }}" alt="logo"/>
                </a>
                <p class="pt-5 font-body font-light text-primary dark:text-white sm:pt-0">
                    ©2024 John Doe.
                </p>
            </div>
            <div class="mr-auto flex items-center pt-5 sm:mr-0 sm:pt-0">

                <a href="https://github.com/ " target="_blank">
                    <i class="text-4xl text-primary dark:text-white pl-5 hover:text-secondary dark:hover:text-secondary transition-colors bx bxl-github"></i>
                </a>

                <a href="https://codepen.io/ " target="_blank">
                    <i class="text-4xl text-primary dark:text-white pl-5 hover:text-secondary dark:hover:text-secondary transition-colors bx bxl-codepen"></i>
                </a>

                <a href="https://www.linkedin.com/ " target="_blank">
                    <i class="text-4xl text-primary dark:text-white pl-5 hover:text-secondary dark:hover:text-secondary transition-colors bx bxl-linkedin"></i>
                </a>

            </div>
        </div>
    </div>

</div>

</body>
</html>
