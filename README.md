# Roblox Hunting Game

Proyecto base para un juego de caza en Roblox, desarrollado con Rojo, Roblox Studio y Git.

## Estado actual
- Ya existe una primera vertical slice de comandos del perro.
- El cliente muestra HUD y recibe input `Z`, `X`, `C`.
- El servidor procesa `Follow`, `Search` y `Retrieve`.
- Economia y seleccion basica de presa ya estan conectadas.
- El perro todavia no existe como entidad visible en el mundo.
- El loop de hunting todavia es logico, no espacial.

## Objetivo inmediato
Pasar de una mecanica abstracta de perro a un loop jugable visible en mundo:
- spawn del perro
- seguimiento del jugador
- hunting real entre `Search` y `Retrieve`
- presa fisica o actor de prueba
- feedback visual claro

## Estructura
- `src/ReplicatedStorage/Shared/Config`: datos compartidos de armas, perros y presas.
- `src/ReplicatedStorage/Client`: modulos reutilizables del cliente.
- `src/ServerScriptService/Services`: logica del servidor para caza, economia y perros.
- `src/StarterPlayer/StarterPlayerScripts`: bootstrap cliente secundario.
- `src/StarterGui`: bootstrap cliente redundante para asegurar inicializacion en Studio.

## Metodologia de trabajo
Este proyecto se desarrolla con una metodologia incremental:

1. Primero funcionalidad minima jugable.
2. Despues representacion visual en mundo.
3. Despues polish, balance y contenido.

Reglas de trabajo:
- No saltar directo a UI final o arte final si la mecanica base no existe.
- Resolver primero autoridad servidor/cliente y luego feedback visual.
- Hacer cambios chicos, verificables y faciles de revertir.
- Mantener logs de debug solo mientras hacen falta; limpiarlos despues.
- Evitar features "simuladas" si despues obligan a reescribir todo.

## Plan de accion

### Fase 1. Base jugable
- input cliente para perro
- HUD basico
- remotes y servicios
- economia minima
- seleccion basica de presa

Estado: hecho en una primera version.

### Fase 2. Perro en el mundo
- crear un perro placeholder visible
- spawnearlo junto al jugador
- follow basico
- mostrar estados en mundo

Estado: pendiente.

### Fase 3. Hunting real
- crear presa visible o dummy de prueba
- hacer que `Search` no cobre instantaneamente
- agregar tiempo, distancia y resolucion real
- definir resultado de caza

Estado: pendiente. Esta es la brecha principal actual del MVP.

### Fase 4. Integracion perro + presa
- perro busca objetivo
- perro persigue
- perro vuelve o habilita recupero
- `Retrieve` actua sobre una presa realmente conseguida

Estado: pendiente.

### Fase 5. Presentacion y polish
- animaciones
- sonido
- VFX
- mejor HUD
- tuning de ritmo y recompensas

Estado: pendiente.

### Fase 6. QA y balance
- test de input
- test de respawn
- test de sincronizacion cliente-servidor
- test de spam
- test de multiplayer

Estado: pendiente.

## Metodologia de testeo
Cada feature nueva debe probarse, como minimo, asi:

1. `Play` en Roblox Studio, no solo `Run`.
2. validar cliente y servidor por separado en `Output`.
3. validar respawn del jugador.
4. validar spam de input.
5. validar que UI y estado servidor no diverjan.

Checklist minima por milestone:
- el cliente inicializa
- los remotes existen
- el servidor recibe y responde
- el HUD refleja el estado correcto
- no quedan errores nuevos propios de la feature

## Flujo de desarrollo con Codex
Este repositorio esta preparado para que otras instancias de Codex trabajen con el mismo criterio.

### Principios
- priorizar mecanicas reales sobre mockups visuales
- no romper la separacion cliente/servidor
- mantener cambios enfocados por feature
- actualizar documentacion cuando cambie el enfoque del proyecto

### Forma de avanzar
1. leer `README.md`, `GDD-MVP.md` y `ARCHITECTURE.md`
2. identificar en que fase del plan cae el trabajo
3. implementar el cambio minimo util
4. probar en Studio
5. limpiar logs de debug si ya no son necesarios
6. documentar cualquier decision importante
7. commit pequeño y descriptivo

### Criterio para priorizar
- si una feature depende de una mecanica base ausente, primero se construye la base
- si algo solo mejora apariencia pero no jugabilidad, se posterga
- si hay un bug de sincronizacion cliente/servidor, eso tiene prioridad alta

## Git y versionado
Repositorio remoto:
- `https://github.com/atomaculus/hunting_game.git`

Reglas sugeridas:
- un commit por cambio coherente
- mensajes de commit cortos y tecnicos
- no mezclar refactors, UX y logica de gameplay en un mismo commit si se puede evitar
- antes de pushear, revisar que no haya archivos temporales innecesarios

## Herramientas de trabajo
- Roblox Studio
- VS Code
- Rojo
- Git

## Notas actuales
- El bootstrap cliente estable hoy entra correctamente desde `StarterGui`.
- Se mantiene tambien un bootstrap en `StarterPlayerScripts`.
- Puede haber errores de assets de Roblox Studio (`DnsResolve`, animaciones, meshes) ajenos a la logica propia del juego.
