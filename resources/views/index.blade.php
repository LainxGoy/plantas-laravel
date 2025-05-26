@extends('layouts.app')

@section('content')
<div class="container py-4">
    <h1 class="mb-4 text-center">Plantas Medicinales y Mortales</h1>

    {{-- Slider --}}
    @if($plantas->count() > 0)
    <div id="plantasCarousel" class="carousel slide mb-5" data-bs-ride="carousel">
      <div class="carousel-inner">
        @foreach($plantas->take(5) as $index => $planta)
        <div class="carousel-item @if($index == 0) active @endif">
          <img src="{{ $planta->imagen }}" class="d-block w-100" alt="{{ $planta->nombre }}" style="height: 300px; object-fit: cover;">
          <div class="carousel-caption d-none d-md-block bg-dark bg-opacity-50 rounded px-3 py-2">
            <h5>{{ $planta->nombre }}</h5>
            <p class="mb-0 text-truncate">{{ $planta->descripcion }}</p>
          </div>
        </div>
        @endforeach
      </div>
      <button class="carousel-control-prev" type="button" data-bs-target="#plantasCarousel" data-bs-slide="prev">
        <span class="carousel-control-prev-icon" aria-hidden="true"></span>
        <span class="visually-hidden">Anterior</span>
      </button>
      <button class="carousel-control-next" type="button" data-bs-target="#plantasCarousel" data-bs-slide="next">
        <span class="carousel-control-next-icon" aria-hidden="true"></span>
        <span class="visually-hidden">Siguiente</span>
      </button>
    </div>
    @endif

    {{-- Lista de plantas en cards --}}
    <div class="row row-cols-1 row-cols-md-3 row-cols-lg-4 g-4">
        @foreach ($plantas as $planta)
        <div class="col">
            <div class="card h-100 shadow-sm">
                <img src="{{ $planta->imagen }}" class="card-img-top" alt="{{ $planta->nombre }}" style="height:200px; object-fit: cover;">
                <div class="card-body d-flex flex-column">
                    <h5 class="card-title">{{ $planta->nombre }}</h5>
                    <p class="card-text text-truncate">{{ $planta->descripcion }}</p>
                    <a href="{{ route('plantas.show', $planta->id) }}" class="btn btn-primary mt-auto">Ver Detalle</a>
                </div>
                <div class="card-footer text-muted small">
                    Tipo: <strong>{{ ucfirst($planta->tipo) }}</strong>
                </div>
            </div>
        </div>
        @endforeach
    </div>

    <div class="mt-4">
        {{ $plantas->links() }}
    </div>
</div>
@endsection
