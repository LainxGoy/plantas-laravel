<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\PlantaController;

Route::get('/plantas', [PlantaController::class, 'index'])->name('plantas.index');

Route::get('/plantas/{id}', [PlantaController::class, 'show'])->name('plantas.show');

