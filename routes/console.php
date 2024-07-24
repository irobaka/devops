<?php

use App\Jobs\PublishPostJob;
use Illuminate\Foundation\Inspiring;
use Illuminate\Support\Facades\Artisan;
use Illuminate\Support\Facades\Schedule;

Artisan::command('inspire', function () {
    $this->comment(Inspiring::quote());
})->purpose('Display an inspiring quote')->hourly();

Schedule::job(PublishPostJob::class)->everyMinute();

if (config('app.env') === 'production') {
    Schedule::command('backup:clean')->daily()->at('01:00');
    Schedule::command('backup:run')->daily()->at('01:30');
}

if (config('app.env') === 'local') {
    Schedule::command('telescope:prune')->daily();
}
