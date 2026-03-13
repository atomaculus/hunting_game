# Juego de Caza Roblox - GDD MVP

## Objetivo
Crear un juego de caza en Roblox con progresion por armas, perros y zonas de caza. El foco del MVP es validar que el loop principal sea divertido, claro y rentable para expandir despues.

## Vision del juego
El jugador sale desde un campamento, equipa un arma y un perro, entra a una zona de caza, encuentra presas, las caza, cobra la recompensa y vende lo obtenido para mejorar su equipo.

La progresion principal se divide en tres ejes:
- armas
- perros de caza
- acceso a mejores presas y zonas

## Principios de diseno
- El jugador debe sentir que caza el, no que el perro resuelve todo.
- Cada perro debe servir para tareas distintas, no existir uno claramente superior en todo.
- Las armas deben tener roles claros por tipo de presa.
- La economia debe obligar a elegir entre vender, guardar y alimentar perros.
- El MVP debe ser pequeno y testeable antes de escalar contenido.
- La experiencia debe ser viable en Roblox sin depender de simulacion extrema.

## Direccion elegida
- tono: semi realista
- camara base: tercera persona
- apuntado: vista en primera persona o apuntado cerrado al hombro al usar arma
- modo principal: PvE con opcion futura de cooperativo
- estilo visual: estilizado con base realista

## Camara y disparo
La recomendacion para el MVP es:
- exploracion y movimiento en tercera persona
- al apuntar, transicion a una vista mas precisa en primera persona

Esto da varias ventajas:
- mejor lectura del entorno cuando el jugador se mueve con su perro
- disparo mas inmersivo y controlado
- interfaz mas natural para Roblox que jugar siempre en primera persona

Si la implementacion de primera persona da problemas al principio, el plan B del MVP es usar una camara sobre el hombro mas cerrada y dejar la primera persona completa para una version posterior.

## Loop principal
1. Entrar al campamento.
2. Equipar arma, municion y un perro.
3. Ir a una zona de caza.
4. Buscar rastros, sonidos o movimiento.
5. Usar al perro como apoyo para detectar o recuperar.
6. Cazar la presa.
7. Decidir si vender la presa, guardarla o usar parte como alimento del perro.
8. Volver al campamento, vender y comprar mejoras.

## MVP propuesto
El MVP inicial incluye:
- 1 mapa principal con campamento y 2 zonas de caza.
- 4 armas.
- 3 perros.
- 5 presas.
- 1 tienda.
- 1 sistema de venta.
- 1 sistema simple de alimentacion y estado del perro.
- 1 perro equipado por salida de caza en el MVP.
- 1 inventario basico.

## Armas del MVP
### 1. Gomera
- Tier: inicial.
- Uso: aves pequenas y caza menor muy basica.
- Ventaja: barata, silenciosa.
- Desventaja: muy poco alcance y dano.

### 2. Escopeta calibre 28
- Tier: intermedio bajo.
- Uso: aves y algunas presas medianas pequenas.
- Ventaja: facil de usar, buen paso desde la gomera.
- Desventaja: menos versatil que la calibre 12.

### 3. Escopeta calibre 12
- Tier: intermedio alto.
- Uso: aves, algunas presas medianas y contenido generalista.
- Ventaja: mas potente y versatil.
- Desventaja: mas cara y con municion mas costosa.

### 4. Fusil de caza mayor
- Tier: avanzado.
- Uso ideal: caza mayor.
- Ventaja: alto alcance y dano.
- Desventaja: aunque se puede disparar a aves y caza menor, es una mala herramienta para eso.

## Regla de rol del fusil
El fusil no se bloquea artificialmente para aves o caza menor. En cambio, se desincentiva su uso con reglas del juego:
- apuntado mas dificil sobre blancos chicos y rapidos
- municion cara
- penalizacion economica por usar un arma inapropiada sobre presas pequenas
- menor eficiencia de farmeo frente a escopetas o gomera

Resultado esperado:
- el jugador puede intentar usarlo en cualquier presa
- en la practica, comprar el fusil lo orienta hacia caza mayor porque ahi si rinde de verdad

## Presas del MVP
### Aves
- Paloma: comun, barata, ideal para empezar.
- Pato: valor medio, puede requerir cobro en agua.

### Caza menor
- Liebre: valor medio, mas rapida y nerviosa.

### Caza mayor
- Ciervo: valor alto, requiere mejor arma y seguimiento.
- Jabali: valor alto, mas agresivo o mas dificil de rastrear.

## Perros del MVP
### 1. Pointer ingles
- Rol: deteccion de aves.
- Fortaleza principal: olfato.
- Habilidad: marcar presencia de aves cercanas con mas precision.
- Debilidad: menos util en cobro y caza mayor.

### 2. Pointer aleman
- Rol: perro versatil.
- Fortaleza principal: velocidad.
- Habilidad: rastrea mas rapido y puede asistir en varias presas.
- Debilidad: no domina ninguna tarea tanto como un especialista.

### 3. Labrador cobrador
- Rol: recuperacion.
- Fortaleza principal: cobro de aves abatidas, especialmente en zonas con agua.
- Habilidad: reduce la probabilidad de perder presas caidas lejos o en lagunas.
- Debilidad: menos util para localizar caza mayor.

## Estadisticas base de perros
Cada perro tiene estas stats:
- olfato
- velocidad
- obediencia
- resistencia
- hambre
- especialidad

## Sistema de perros factible para Roblox
Para que sea viable y no demasiado complejo al inicio, el perro no usa una IA realista extrema. En el MVP hace pocas cosas, pero utiles:
- seguir al jugador
- entrar en modo busqueda cuando el jugador lo ordena
- marcar una direccion o area de interes
- recuperar presas caidas en casos puntuales

El perro no debe:
- matar presas
- decidir toda la ruta por su cuenta
- resolver automaticamente la caza

## Alimentacion del perro
El perro tiene un medidor de hambre.
- si esta bien alimentado, rinde al 100 por ciento
- si tiene hambre, baja obediencia y resistencia
- si esta muy mal alimentado, no puede salir a cazar o tiene una penalizacion fuerte

Fuentes de alimento posibles:
- comprar alimento en tienda
- reservar parte de ciertas presas para comida en lugar de venderlas

Esto agrega una decision economica util:
- vender todo da mas dinero ahora
- guardar parte para el perro mejora el rendimiento futuro

## Economia del MVP
Moneda principal:
- monedas

Gastos:
- armas
- municion
- perros
- comida para perros
- outfits

Ingresos:
- venta de presas
- posibles bonus por caza limpia o uso correcto de equipo

Importante:
El balance debe evitar que el jugador compre la mejor arma demasiado rapido.

## Inventario basico
El jugador guarda:
- arma equipada
- un perro equipado
- municion
- presas obtenidas
- alimento para perro
- monedas

## Zonas del MVP
### Zona 1: humedal o campo abierto
- foco en paloma y pato
- ideal para gomera y escopeta 28

### Zona 2: bosque o monte
- foco en liebre, ciervo y jabali
- ideal para calibre 12 y fusil


## Comportamiento de presas en el MVP
Para mantener el proyecto viable en Roblox, las presas del MVP usan comportamientos simples pero claros.

### Aves
- aparecen en zonas concretas
- se mueven con patrones simples
- huyen rapido al detectar al jugador o escuchar un disparo

### Caza menor
- aparece en zonas definidas
- se mueve de forma nerviosa o erratica
- huye en recorridos cortos cuando detecta peligro

### Caza mayor
- aparece en sectores concretos del mapa
- puede dejar rastros simples para seguimiento
- huye si detecta al jugador, ruido o un disparo cercano
- la huida debe ser sostenida, no instantanea, para permitir persecucion y rastreo

La idea es que la caza mayor no se sienta quieta ni estatica, pero tampoco requiera una IA compleja en la primera version.
## Reglas de progresion
- ciertas presas requieren arma minima recomendada
- ciertos perros ayudan mucho en presas concretas, pero no son obligatorios en todos los casos
- nuevas armas y perros se compran con monedas
- el jugador avanza mejorando tasa de exito y eficiencia

## Monetizacion a tener en mira
La monetizacion tiene que existir, pero sin romper el juego. Para Roblox, el camino mas sano es:
- gamepasses de calidad de vida
- cosmeticos premium
- montos moderados de moneda premium o bundles

Buenas opciones futuras:
- outfit premium de cazador
- kennel slot extra para tener mas perros guardados
- skins de armas
- emotes o decoracion del campamento

Opciones a evitar al principio:
- vender armas claramente pay-to-win
- vender perros muy superiores solo con Robux
- bloquear el progreso base detras de pago

## Riesgos del proyecto
- que disparar no se sienta bien
- que el rastreo sea aburrido
- que el perro haga demasiado o demasiado poco
- que la economia se rompa rapido
- que la caza mayor requiera sistemas demasiado complejos para una primera version
- que la transicion entre tercera persona y apuntado se sienta torpe

## Recomendacion tecnica inicial
Primero construir solo esto:
- campamento
- una zona de aves
- una zona de caza mayor simple
- sistema de disparo basico
- cambio de camara a modo apuntado
- una presa de aves
- una presa de caza mayor
- un perro detector
- un perro recuperador
- tienda y venta

Si eso funciona, se agregan mas razas, armas, comportamientos y zonas.

## Siguientes decisiones a definir
- si el apuntado sera primera persona completa o una camara cerrada al hombro
- si la penalizacion del fusil en presas pequenas sera economica, de precision o ambas
- el MVP usara un solo perro por salida; varios perros queda para una expansion futura
- si las presas aparecen por spawns simples o por sistema de rastros


## Decision cerrada
- En el MVP, el jugador solo puede llevar un perro por salida de caza.
- Esto simplifica IA, interfaz, animaciones, comandos y balance.
- La posibilidad de varios perros queda reservada para una etapa posterior si el juego demuestra traccion.



## Balance inicial del MVP
Estos numeros no son finales. Son una base de trabajo para prototipar y ajustar despues de probar sensaciones en Roblox Studio.

### Armas
| Arma | Tier | Dano | Alcance | Precision | Cadencia | Costo | Presa ideal |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Gomera | Inicial | 15 | Bajo | Media | Media | 0 o muy bajo | Paloma |
| Escopeta calibre 28 | Intermedio bajo | 45 | Medio | Media | Media | 350 | Paloma, pato |
| Escopeta calibre 12 | Intermedio alto | 65 | Medio | Media alta | Media baja | 900 | Pato, liebre |
| Fusil de caza mayor | Avanzado | 95 | Alto | Alta | Baja | 2200 | Ciervo, jabali |

### Reglas iniciales de armas
- La gomera es el arma de entrada y debe permitir ganar las primeras monedas sin frustrar.
- La escopeta 28 es la mejor puerta de entrada a caza de aves rentable.
- La escopeta 12 es el arma mas versatil del MVP.
- El fusil tiene el mayor dano y alcance, pero su municion es la mas cara.
- Si el fusil se usa sobre presas chicas, el rendimiento economico debe ser peor que con las armas correctas.

### Perros
| Perro | Rol | Olfato | Velocidad | Obediencia | Resistencia | Hambre base | Costo |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Pointer ingles | Deteccion de aves | 9 | 6 | 7 | 6 | 5 | 500 |
| Pointer aleman | Versatil | 7 | 8 | 7 | 7 | 6 | 850 |
| Labrador cobrador | Recuperacion | 6 | 6 | 8 | 8 | 7 | 700 |

### Reglas iniciales de perros
- Las stats usan una escala simple de 1 a 10.
- Hambre base mas alta implica mas mantenimiento o necesidad de alimentacion frecuente.
- El pointer ingles debe sentirse claramente superior para detectar aves.
- El pointer aleman debe ser el perro equilibrado para quien quiera una opcion flexible.
- El labrador debe ser el mejor recuperando piezas, sobre todo en agua o vegetacion incomoda.

### Presas
| Presa | Tipo | Valor de venta | Dificultad | Velocidad/Huida | Arma recomendada | Perro recomendado |
| --- | --- | --- | --- | --- | --- | --- |
| Paloma | Ave | 20 | Baja | Alta | Gomera o 28 | Pointer ingles |
| Pato | Ave | 45 | Media | Media alta | 28 o 12 | Labrador |
| Liebre | Caza menor | 70 | Media | Alta | 12 | Pointer aleman |
| Ciervo | Caza mayor | 180 | Alta | Media | Fusil | Pointer aleman |
| Jabali | Caza mayor | 220 | Alta | Media alta | Fusil | Pointer aleman |

### Reglas iniciales de economia
- El jugador debe poder comprar la escopeta 28 despues de varias salidas exitosas, no de una sola.
- Comprar un perro debe sentirse como una inversion importante.
- La comida del perro debe costar lo suficiente para generar decision, pero no tanto como para sentirse castigo constante.
- La municion del fusil debe obligar a pensar antes de disparar.

### Costos iniciales sugeridos
| Item | Costo |
| --- | --- |
| Comida simple para perro | 25 |
| Caja de municion calibre 28 | 30 |
| Caja de municion calibre 12 | 55 |
| Caja de municion fusil | 90 |
| Outfit basico | 120 |

### Hipotesis de balance a validar
- El jugador deberia pasar de gomera a escopeta 28 relativamente rapido.
- La escopeta 12 deberia sentirse como una mejora importante, no obligatoria inmediata.
- El primer perro deberia comprarse antes del fusil.
- El fusil deberia representar una especializacion hacia caza mayor y mayor riesgo economico.

## Comandos del perro en el MVP
El perro del MVP se controla con tres comandos simples. La idea es que sean faciles de entender para el jugador y faciles de implementar en Roblox.

### Tabla de comandos
| Comando | Input sugerido | Que hace | Limites | Perro que mas lo aprovecha |
| --- | --- | --- | --- | --- |
| Seguir | Tecla rapida o boton UI | El perro se mantiene cerca del jugador y lo acompana por el mapa | No investiga a fondo ni se aleja demasiado | Todos |
| Buscar | Tecla rapida o boton UI | El perro se mueve dentro de un radio limitado para detectar presas, rastros o zonas de interes | Cooldown corto, consumo de resistencia, peor rendimiento con hambre | Pointer ingles y Pointer aleman |
| Cobrar | Tecla rapida o boton UI apuntando a presa abatida o zona cercana | El perro va a recuperar una presa abatida o a marcar su posicion exacta | Solo funciona con piezas validas, dentro de rango y no resuelve presas vivas | Labrador cobrador |

### Seguir
Seguir es el estado por defecto.

Implicancias en la dinamica del juego:
- el perro acompana al jugador durante la exploracion
- mantiene una distancia corta o media sin estorbar demasiado
- permite reposicionar al perro rapido si se separo por otra orden
- puede dar una alerta leve si detecta algo cercano, sin activar una busqueda completa

Objetivo jugable:
- mantener orden y claridad
- evitar que la IA del perro se vuelva caotica
- hacer que el jugador sienta compania util sin automatizacion excesiva

### Buscar
Buscar es la orden activa para trabajo de campo.

Implicancias en la dinamica del juego:
- el perro se separa del jugador dentro de un area controlada
- intenta encontrar presas, rastros o direccion probable de movimiento
- si detecta algo, no lo resuelve: lo marca con animacion, postura o indicador simple
- cada raza usa este comando mejor en tareas distintas

Ejemplos practicos:
- pointer ingles: mejora fuerte detectando aves ocultas o agrupadas
- pointer aleman: mejor rastreo general y seguimiento hacia caza mayor
- labrador: puede usarlo, pero no debe ser el mejor buscando

Limites recomendados:
- cooldown corto entre usos
- consumo de resistencia del perro
- menos eficacia si el perro tiene hambre
- radio maximo limitado para no romper el mapa

Objetivo jugable:
- darle valor tactico al perro
- reforzar diferencias entre razas
- hacer que el jugador decida cuando usar el recurso

### Cobrar
Cobrar se usa despues del disparo, no antes.

Implicancias en la dinamica del juego:
- el perro va hacia la presa abatida o ultima posicion marcada
- puede traer la pieza al jugador o dejarla identificada claramente
- reduce la frustracion de perder presas en agua, pasto alto o terreno irregular
- tiene mucho valor en caza de aves y en zonas complicadas del mapa

Limites recomendados:
- solo funciona con presas abatidas o marcadas como recuperables
- requiere que la presa este dentro de un rango razonable
- puede tardar mas o rendir peor si el perro esta cansado o con hambre
- no sirve para perseguir ni derribar presas vivas

Objetivo jugable:
- dar utilidad fuerte al perro sin quitar protagonismo al jugador
- mejorar la sensacion de caza bien ejecutada
- volver mas atractivas ciertas razas sin volverlas obligatorias en todo contexto

### Loop del perro dentro de una salida de caza
1. El jugador explora con el perro en Seguir.
2. Al entrar en una zona prometedora, usa Buscar.
3. El perro marca un rastro, una direccion o una presa.
4. El jugador se posiciona, apunta y dispara.
5. Si la presa cae en zona dificil, el jugador ordena Cobrar.

### Regla central de diseno
El perro ayuda a encontrar y recuperar, pero no reemplaza al jugador en:
- decidir la ruta
- elegir el momento del disparo
- apuntar
- disparar
- administrar economia y recursos

### Primera propuesta de implementacion en Roblox
Para el MVP, estos comandos se pueden resolver de forma simple:
- Seguir: movimiento de seguimiento con distancia minima y maxima respecto al jugador
- Buscar: navegacion a puntos o patrullaje corto dentro de un radio, con chequeo simple de deteccion
- Cobrar: ir hacia una presa abatida, reproducir animacion simple y devolver item o confirmar recuperacion

Esto es suficiente para un primer prototipo sin meternos todavia en una IA demasiado compleja.
