<?php

namespace App\Http\Controllers;

use App\Models\Planta;
use Illuminate\Http\Request;

class PlantaController extends Controller
{
    // Mostrar todas las plantas en cards
    public function index()
    {
        $plantas = Planta::all();
        return view('plantas.index', compact('plantas'));
    }

    // Mostrar detalles de una planta
    public function show($id)
    {
        $planta = Planta::findOrFail($id);
        return view('plantas.show', compact('planta'));
    }
}
