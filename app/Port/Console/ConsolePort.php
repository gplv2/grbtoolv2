<?php

namespace App\Port\Console;

use App\Containers\Welcome\UI\CLI\Commands\SayWelcome;
use Illuminate\Console\Scheduling\Schedule;
use Illuminate\Foundation\Console\Kernel as LaravelConsoleKernel;

/**
 * Class ConsolePort
 *
 * A.K.A (app/Console/Kernel.php)
 *
 * @author  Mahmoud Zalt  <mahmoud@zalt.me>
 */
class ConsolePort extends LaravelConsoleKernel
{
    /**
     * The Artisan commands provided by your application.
     *
     * @var array
     */
    protected $commands = [
        // Inspire::class,
        SayWelcome::class,
    ];

    /**
     * Define the application's command schedule.
     *
     * @param  \Illuminate\Console\Scheduling\Schedule  $schedule
     * @return void
     */
    protected function schedule(Schedule $schedule)
    {
        // $schedule->command('inspire')->hourly();

    }

    /**
     * Register the Closure based commands for the application.
     *
     * @return void
     */
    protected function commands()
    {
        //require base_path('routes/console.php');
    }
}
