# Arquitectura Tecnica Inicial

## Objetivo
Mantener el MVP simple, separando datos compartidos, logica del servidor y control del cliente.

## Distribucion propuesta

### ReplicatedStorage
Contiene datos y modulos que necesitan cliente y servidor.

- `Shared/Constants.lua`: constantes del juego.
- `Shared/Config/Weapons.lua`: definicion de armas.
- `Shared/Config/Dogs.lua`: definicion de perros.
- `Shared/Config/Prey.lua`: definicion de presas.

### ServerScriptService
Contiene la autoridad del juego.

- `Bootstrap.server.lua`: inicializa servicios y remotes.
- `Services/DogService.lua`: seguimiento del estado del perro, hambre, comandos y placeholder visible en `Workspace`.
- `Services/HuntService.lua`: spawns, placeholders de presas activas, estados de presa (`Detected` / `Retrievable`), deteccion, huida y resultado de la caza.
- `Services/EconomyService.lua`: venta de presas, monedas y costos.

### StarterPlayerScripts
Contiene experiencia local del jugador.

- `ClientBootstrap.client.lua`: arranque del cliente.
- `Controllers/DogController.lua`: entrada de usuario para Seguir, Buscar y Cobrar.

## Criterios de diseno
- El servidor decide economia, presas validas, resultados de caza y estado final del perro.
- El cliente solo manda intenciones y muestra feedback.
- La representacion visible inicial del perro tambien la crea y mueve el servidor para evitar divergencias cliente-servidor.
- Las presas placeholder activas tambien viven en servidor y exponen un estado simple para que cliente y mundo reflejen la misma progresion.
- La configuracion vive en modulos separados para poder iterar balance rapido.
- El MVP usa un solo perro por salida de caza.

## Orden sugerido de implementacion
1. `Constants.lua`
2. configuraciones base de armas, perros y presas
3. `Bootstrap.server.lua`
4. `DogController.lua`
5. `DogService.lua`
6. `HuntService.lua`
7. `EconomyService.lua`

## Primer alcance realista
Primero deberia funcionar esto:
- entrar al mapa
- equipar un perro
- usar Seguir, Buscar y Cobrar
- detectar una presa de ave y una de caza mayor
- vender el resultado y ganar monedas
