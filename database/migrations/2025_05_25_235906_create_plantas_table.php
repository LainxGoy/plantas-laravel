<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreatePlantasTable extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('plantas', function (Blueprint $table) {
            $table->id();
            $table->string('nombre');
            $table->string('nombre_cientifico');
            $table->string('tipo'); // medicinal o mortal
            $table->text('descripcion');
            $table->string('ubicacion');
            $table->string('imagen');
            $table->string('uso_principal');
            $table->string('peligro')->nullable(); // solo si es mortal
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('plantas');
    }
}
