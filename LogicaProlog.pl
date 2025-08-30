usuario(juan).
usuario(maria).
usuario(carlos).
usuario(ana).
usuario(pedro).
usuario(sofia).
usuario(luis).
usuario(carmen).

producto(laptop_gaming).
producto(mouse_gamer).
producto(teclado_mecanico).
producto(monitor_4k).
producto(auriculares_bluetooth).
producto(smartphone_premium).
producto(tablet_pro).
producto(camara_digital).
producto(libro_ia).
producto(libro_algoritmos).
producto(libro_fisica).
producto(curso_python).
producto(curso_java).
producto(netflix_suscripcion).
producto(spotify_premium).
producto(zapatillas_running).
producto(ropa_deportiva).
producto(suplementos_gym).

categoria(laptop_gaming, tecnologia).
categoria(mouse_gamer, tecnologia).
categoria(teclado_mecanico, tecnologia).
categoria(monitor_4k, tecnologia).
categoria(auriculares_bluetooth, tecnologia).
categoria(smartphone_premium, tecnologia).
categoria(tablet_pro, tecnologia).
categoria(camara_digital, tecnologia).
categoria(libro_ia, educacion).
categoria(libro_algoritmos, educacion).
categoria(libro_fisica, educacion).
categoria(curso_python, educacion).
categoria(curso_java, educacion).
categoria(netflix_suscripcion, entretenimiento).
categoria(spotify_premium, entretenimiento).
categoria(zapatillas_running, deportes).
categoria(ropa_deportiva, deportes).
categoria(suplementos_gym, deportes).

compro(juan, laptop_gaming).
compro(juan, mouse_gamer).
compro(juan, teclado_mecanico).
compro(juan, libro_ia).
compro(juan, curso_python).

compro(maria, smartphone_premium).
compro(maria, auriculares_bluetooth).
compro(maria, netflix_suscripcion).
compro(maria, spotify_premium).
compro(maria, libro_algoritmos).

compro(carlos, monitor_4k).
compro(carlos, laptop_gaming).
compro(carlos, mouse_gamer).
compro(carlos, curso_java).
compro(carlos, libro_ia).

compro(ana, zapatillas_running).
compro(ana, ropa_deportiva).
compro(ana, suplementos_gym).
compro(ana, spotify_premium).

compro(pedro, tablet_pro).
compro(pedro, camara_digital).
compro(pedro, netflix_suscripcion).
compro(pedro, libro_fisica).

compro(sofia, smartphone_premium).
compro(sofia, auriculares_bluetooth).
compro(sofia, zapatillas_running).
compro(sofia, spotify_premium).

compro(luis, laptop_gaming).
compro(luis, teclado_mecanico).
compro(luis, monitor_4k).
compro(luis, curso_python).
compro(luis, libro_algoritmos).

compro(carmen, tablet_pro).
compro(carmen, netflix_suscripcion).
compro(carmen, libro_fisica).
compro(carmen, ropa_deportiva).

calificacion(juan, laptop_gaming, 5).
calificacion(juan, mouse_gamer, 4).
calificacion(juan, teclado_mecanico, 5).
calificacion(juan, libro_ia, 4).

calificacion(maria, smartphone_premium, 5).
calificacion(maria, auriculares_bluetooth, 4).
calificacion(maria, netflix_suscripcion, 5).
calificacion(maria, libro_algoritmos, 3).

calificacion(carlos, monitor_4k, 5).
calificacion(carlos, laptop_gaming, 4).
calificacion(carlos, mouse_gamer, 4).
calificacion(carlos, libro_ia, 5).

calificacion(ana, zapatillas_running, 5).
calificacion(ana, ropa_deportiva, 3).
calificacion(ana, suplementos_gym, 4).

calificacion(pedro, tablet_pro, 4).
calificacion(pedro, camara_digital, 5).
calificacion(pedro, netflix_suscripcion, 4).

calificacion(sofia, smartphone_premium, 4).
calificacion(sofia, auriculares_bluetooth, 5).
calificacion(sofia, zapatillas_running, 4).

calificacion(luis, laptop_gaming, 5).
calificacion(luis, teclado_mecanico, 4).
calificacion(luis, monitor_4k, 5).
calificacion(luis, curso_python, 4).

calificacion(carmen, tablet_pro, 3).
calificacion(carmen, netflix_suscripcion, 5).
calificacion(carmen, libro_fisica, 4).

ha_comprado(Usuario, Producto) :-
    compro(Usuario, Producto).

obtener_calificacion(Usuario, Producto, Calificacion) :-
    calificacion(Usuario, Producto, Calificacion).

calificacion_alta(Usuario, Producto) :-
    calificacion(Usuario, Producto, Calificacion),
    Calificacion > 3.

productos_comunes(Usuario1, Usuario2, Count) :-
    findall(Producto, (compro(Usuario1, Producto), compro(Usuario2, Producto)), Productos),
    length(Productos, Count).

similitud_usuarios(Usuario1, Usuario2, Similitud) :-
    Usuario1 \= Usuario2,
    productos_comunes(Usuario1, Usuario2, Comunes),
    findall(P, compro(Usuario1, P), P1),
    findall(P, compro(Usuario2, P), P2),
    length(P1, L1),
    length(P2, L2),
    Total is L1 + L2 - Comunes,
    (Total > 0 -> Similitud is Comunes / Total ; Similitud = 0).

recomendar_item(Usuario, ProductoRecomendado) :-
    findall([Sim, UsuarioSimilar], 
            (similitud_usuarios(Usuario, UsuarioSimilar, Sim), Sim > 0), 
            Similitudes),
    sort(1, @>=, Similitudes, [[_|[MasSimilar]]|_]),

    calificacion_alta(MasSimilar, ProductoRecomendado),
    \+ ha_comprado(Usuario, ProductoRecomendado).

recomendar_lista(Usuario, ListaRecomendaciones) :-
    % Obtener todos los usuarios similares
    findall([Sim, UsuarioSimilar], 
            (similitud_usuarios(Usuario, UsuarioSimilar, Sim), Sim > 0.1), 
            UsuariosSimilares),
    sort(1, @>=, UsuariosSimilares, UsuariosOrdenados),

    findall(Producto, 
            (member([_, UsuSim], UsuariosOrdenados),
             calificacion_alta(UsuSim, Producto),
             \+ ha_comprado(Usuario, Producto)), 
            TodosProductos),

    list_to_set(TodosProductos, ProductosUnicos),
    (length(ProductosUnicos, Len), Len >= 5 ->
        append(ListaRecomendaciones, _, ProductosUnicos),
        length(ListaRecomendaciones, 5)
    ;
        ListaRecomendaciones = ProductosUnicos
    ).

recomendacion_recursiva(Usuario, ProductoRecomendado) :-
    findall(Cat, (compro(Usuario, P), categoria(P, Cat), calificacion_alta(Usuario, P)), CatsPreferidas),
    list_to_set(CatsPreferidas, CategoriasUnicas),
    
    % Buscar recursivamente en categorías relacionadas
    buscar_recomendacion_recursiva(Usuario, CategoriasUnicas, [], ProductoRecomendado).

buscar_recomendacion_recursiva(Usuario, _, Visitadas, Producto) :-
    categoria(Producto, Cat),
    \+ member(Cat, Visitadas),
    \+ ha_comprado(Usuario, Producto),
    % Verificar que alguien similar haya calificado bien este producto
    similitud_usuarios(Usuario, OtroUsuario, Sim),
    Sim > 0.2,
    calificacion_alta(OtroUsuario, Producto).

buscar_recomendacion_recursiva(Usuario, [Cat|RestoCats], Visitadas, Producto) :-
    \+ member(Cat, Visitadas),
    NuevasVisitadas = [Cat|Visitadas],

    findall(NuevaCat, 
            (compro(UsuarioRel, ProductoCat),
             categoria(ProductoCat, Cat),
             compro(UsuarioRel, OtroProd),
             categoria(OtroProd, NuevaCat),
             NuevaCat \= Cat), 
            CatsRelacionadas),
    
    list_to_set(CatsRelacionadas, CatsUnicasRel),
    append(RestoCats, CatsUnicasRel, NuevasCategorias),
    buscar_recomendacion_recursiva(Usuario, NuevasCategorias, NuevasVisitadas, Producto).

top_10_items_usuarios(ListaUsuarios, Top10) :-
    findall([Producto, Count], 
            contar_calificaciones_altas(ListaUsuarios, Producto, Count),
            ProductosConConteo),

    sort(2, @>=, ProductosConConteo, ProductosOrdenados),

    tomar_primeros_10(ProductosOrdenados, Top10).

contar_calificaciones_altas(ListaUsuarios, Producto, Count) :-
    producto(Producto),
    findall(Usuario, 
            (member(Usuario, ListaUsuarios), calificacion_alta(Usuario, Producto)),
            UsuariosQueLoCalifican),
    length(UsuariosQueLoCalifican, Count),
    Count > 0.

tomar_primeros_10(Lista, Primeros10) :-
    (length(Lista, Len), Len >= 10 ->
        append(Primeros10, _, Lista),
        length(Primeros10, 10)
    ;
        Primeros10 = Lista
    ).

info_usuario(Usuario) :-
    format('Usuario: ~w~n', [Usuario]),
    format('Productos comprados:~n'),
    forall(compro(Usuario, Producto), 
           format('  - ~w~n', [Producto])),
    format('Calificaciones:~n'),
    forall(calificacion(Usuario, Producto, Cal), 
           format('  - ~w: ~w estrellas~n', [Producto, Cal])).

productos_categoria(Categoria) :-
    format('Productos en categoría ~w:~n', [Categoria]),
    forall(categoria(Producto, Categoria),
           format('  - ~w~n', [Producto])).

usuarios_similares(Usuario, UsuariosSimilares) :-
    findall([Sim, UsuSim], 
            (similitud_usuarios(Usuario, UsuSim, Sim), Sim > 0),
            Similitudes),
    sort(1, @>=, Similitudes, UsuariosSimilares).