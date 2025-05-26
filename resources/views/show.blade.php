@extends('layouts.app')

@section('content')
<div class="container py-4">
    <a href="{{ route('plantas.index') }}" class="btn btn-secondary mb-3">← Volver a la lista</a>

    <div class="card shadow-sm">
        <div class="row g-0">
            <div class="col-md-5">
                <img src="{{ $planta->imagen }}" class="img-fluid rounded-start" alt="{{ $planta->nombre }}" style="height:100%; object-fit: cover;">
            </div>
            <div class="col-md-7">
                <div class="card-body">
                    <h2 class="card-title">{{ $planta->nombre }}</h2>
                    <h5 class="text-muted"><em>{{ $planta->nombre_cientifico }}</em></h5>
                    <p><strong>Tipo:</strong> {{ ucfirst($planta->tipo) }}</p>
                    <p><strong>Ubicación:</strong> {{ $planta->ubicacion }}</p>
                    <p><strong>Uso principal:</strong> {{ $planta->uso_principal }}</p>
                    <p><strong>Descripción:</strong> {{ $planta->descripcion }}</p>
                    @if ($planta->tipo === 'mortal')
                    <p class="text-danger"><strong>Peligro:</strong> {{ $planta->peligro }}</p>
                    @endif
                </div>
            </div>
        </div>
    </div>
</div>
@endsection
