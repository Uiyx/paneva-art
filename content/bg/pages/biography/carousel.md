---
title: „Награди и участия“
date: 2026-06-18
summary: „Награди и участия – галерия“
---

<!-- Bootstrap carousel -->
<div id="awardsCarousel" class="carousel slide" data-bs-ride="carousel">
  <div class="carousel-inner">
    {{ $files := (readDir "static/carousel/Участия и награди") }}
    {{ range $index, $file := $files }}
      <div class="carousel-item {{ if eq $index 0 }}active{{ end }}">
        <img src="{{ "static/carousel/Участия и награди/" | relURL }}{{ $file.Name }}" class="d-block w-100" alt="{{ $file.Name | replace "_" " " }}" style="object-fit: contain;">
        <div class="carousel-caption d-none d-md-block">
          <h5>„{{ $file.Name | replace "_" " " }}“</h5>
        </div>
      </div>
    {{ end }}
  </div>
  <button class="carousel-control-prev" type="button" data-bs-target="#awardsCarousel" data-bs-slide="prev">
    <span class="carousel-control-prev-icon" aria-hidden="true"></span>
    <span class="visually-hidden">Предишен</span>
  </button>
  <button class="carousel-control-next" type="button" data-bs-target="#awardsCarousel" data-bs-slide="next">
    <span class="carousel-control-next-icon" aria-hidden="true"></span>
    <span class="visually-hidden">Следващ</span>
  </button>
</div>
