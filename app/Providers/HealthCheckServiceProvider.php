<?php

namespace App\Providers;

use Illuminate\Support\Facades\App;
use Illuminate\Support\ServiceProvider;
use Spatie\CpuLoadHealthCheck\CpuLoadCheck;
use Spatie\Health\Checks\Checks\DatabaseCheck;
use Spatie\Health\Checks\Checks\DatabaseConnectionCountCheck;
use Spatie\Health\Checks\Checks\DebugModeCheck;
use Spatie\Health\Checks\Checks\RedisCheck;
use Spatie\Health\Checks\Checks\RedisMemoryUsageCheck;
use Spatie\Health\Checks\Checks\UsedDiskSpaceCheck;
use Spatie\Health\Facades\Health;

class HealthCheckServiceProvider extends ServiceProvider
{
    public function boot(): void
    {
        $checks = [
            UsedDiskSpaceCheck::new(),
            DatabaseCheck::new(),
            CpuLoadCheck::new()
                ->failWhenLoadIsHigherInTheLast5Minutes(2)
                ->failWhenLoadIsHigherInTheLast15Minutes(1.75),
            DatabaseConnectionCountCheck::new()
                ->warnWhenMoreConnectionsThan(50)
                ->failWhenMoreConnectionsThan(100),
            RedisCheck::new(),
            RedisMemoryUsageCheck::new(),
        ];

        if (App::environment('production')) {
            $checks[] = DebugModeCheck::new();
        }

        Health::checks($checks);
    }
}
