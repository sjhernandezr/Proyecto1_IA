# 🛒 Sistema de Recomendaciones en Prolog

## 🎯 Overview

Un sistema de recomendación de productos implementado en Prolog que utiliza filtrado colaborativo para sugerir productos basándose en similitudes entre usuarios. El sistema analiza patrones de compra y calificaciones para generar recomendaciones personalizadas.

**📊 Base de datos:**
- 8 usuarios
- 18 productos (4 categorías: Tecnología, Educación, Entretenimiento, Deportes)
- Relaciones de compra y calificaciones (1-5 estrellas)

## 🚀 Cómo usar

### 1. Cargar el código
```prolog
?- [LogicaProlog].
```

### 2. Consultas básicas 🔍
```prolog
% Verificar compra
?- ha_comprado(juan, laptop_gaming).

% Ver calificación
?- obtener_calificacion(maria, smartphone_premium, Cal).

% Calificación alta (>3)
?- calificacion_alta(ana, zapatillas_running).
```

### 3. Análisis de usuarios 👥
```prolog
% Productos en común
?- productos_comunes(juan, carlos, Count).

% Similitud entre usuarios
?- similitud_usuarios(maria, sofia, Sim).

% Usuarios similares
?- usuarios_similares(pedro, Similares).
```

### 4. Recomendaciones ⭐
```prolog
% Recomendar un producto
?- recomendar_item(ana, Producto).

% Lista de recomendaciones (hasta 5)
?- recomendar_lista(luis, Lista).

% Recomendación con exploración de categorías
?- recomendacion_recursiva(carmen, Producto).
```

### 5. Utilidades 🛠️
```prolog
% Top 10 productos de un grupo
?- top_10_items_usuarios([juan, carlos, luis], Top10).

% Info completa de usuario
?- info_usuario(maria).

% Productos por categoría
?- productos_categoria(tecnologia).
```
