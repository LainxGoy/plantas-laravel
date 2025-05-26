<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Planta extends Model
{
    use HasFactory;

    protected $fillable = [
        'nombre',
        'nombre_cientifico',
        'tipo',
        'descripcion',
        'ubicacion',
        'imagen',
        'uso_principal',
        'peligro',
    ];
}
